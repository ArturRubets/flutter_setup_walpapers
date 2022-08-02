import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../data/local_storage/local_storage_wallpapers/local_storage_wallpapers.dart';
import '../../../../data/local_storage/local_storage_wallpapers/models/wallpaper.dart';
import '../../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../models/wallpaper_response.dart';

part 'wallpapers_event.dart';
part 'wallpapers_state.dart';

class WallpapersEmpty implements Exception {
  const WallpapersEmpty();
}

const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class WallpapersBloc extends Bloc<WallpapersEvent, WallpapersState> {
  WallpapersBloc(this._wallpaperRepository) : super(const WallpapersState()) {
    on<WallpapersFetched>(
      _onFetched,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpapersFetchedFromApi>(
      _onFetchedFromApi,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpapersFetchedFromCache>(
      _onFetchedFromCache,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpapersFetchedRestart>(
      _onFetchedRestart,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpaperGridModeSwitched>(
      _onGridModeSwitched,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpaperListModeSwitched>(
      _onListModeSwitched,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpaperDownloaded>(_onWallpaperDownloaded);
    on<WallpaperThumbSmallGotBytes>(
      _onWallpaperDetailThumbSmallGotBytes,
      transformer: concurrent(),
    );
    on<WallpaperThumbOriginGotBytes>(
      _onWallpaperDetailThumbOriginGotBytes,
      transformer: concurrent(),
    );
    on<WallpaperMainImageGotBytes>(
      _onWallpaperMainImageGotBytes,
      transformer: concurrent(),
    );

    on<WallpaperSetWallpaper>(
      _onWallpaperSetWallpaper,
      transformer: _throttleDroppable(_throttleDuration),
    );
  }

  final WallpaperRepository _wallpaperRepository;

  FutureOr<void> _onFetched(_, __) {
    if (state.isCache) {
      add(const WallpapersFetchedFromCache());
    } else {
      add(const WallpapersFetchedFromApi());
    }
  }

  FutureOr<void> _onFetchedFromApi(_, Emitter<WallpapersState> emit) async {
    if (state.hasReachedMax) {
      emit(state.copyWith(status: WallpapersScreenStatus.success));

      return;
    }

    try {
      final int currentPage;
      currentPage = state.status == WallpapersScreenStatus.initial
          ? state.currentPage
          : state.currentPage + 1;

      final response =
          await _wallpaperRepository.getWallpaperFromApi(currentPage);

      if (response.data.isEmpty) {
        throw const WallpapersEmpty();
      }

      final wallpapers = await _getWallpaperFromApi(response);

      final hasReachedMaxValue = _hasReachedMax(response.meta);

      if (state.status == WallpapersScreenStatus.initial) {
        emit(
          state.copyWith(
            wallpapers: wallpapers,
            hasReachedMax: hasReachedMaxValue,
            currentPage: currentPage,
            status: WallpapersScreenStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            wallpapers: List.of(state.wallpapers)..addAll(wallpapers),
            hasReachedMax: hasReachedMaxValue,
            currentPage: currentPage,
            status: WallpapersScreenStatus.success,
          ),
        );
      }
    } on SocketException {
      emit(
        state.copyWith(
          isCache: true,
          hasReachedMax: false,
          status: WallpapersScreenStatus.initial,
        ),
      );
      add(const WallpapersFetchedFromCache());
    } on WallpapersEmpty {
      emit(
        state.copyWith(
          isCache: true,
          hasReachedMax: false,
          status: WallpapersScreenStatus.initial,
        ),
      );
      add(const WallpapersFetchedFromCache());
    } on Exception {
      emit(state.copyWith(status: WallpapersScreenStatus.failure));
    }
  }

  FutureOr<void> _onFetchedFromCache(_, Emitter<WallpapersState> emit) async {
    if (state.hasReachedMax) {
      emit(state.copyWith(status: WallpapersScreenStatus.success));

      return;
    }

    try {
      final int currentPage;
      currentPage = state.status == WallpapersScreenStatus.initial
          ? state.currentPage
          : state.currentPage + 1;

      final response =
          await _wallpaperRepository.getWallpapersFromStorage(currentPage);

      if (response.isEmpty) {
        throw const WallpapersEmpty();
      }

      final wallpapers =
          response.map(_createWallpaperFromStorageToModelBloc).toList();
      final hasReachedMaxValue = wallpapers.length <
              WallpapersState.limitWallpapersPerRequestToStorage ||
          false;

      if (state.status == WallpapersScreenStatus.initial) {
        emit(
          state.copyWith(
            wallpapers: wallpapers,
            hasReachedMax: hasReachedMaxValue,
            currentPage: currentPage,
            status: WallpapersScreenStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            wallpapers: List.of(state.wallpapers)..addAll(wallpapers),
            hasReachedMax: hasReachedMaxValue,
            currentPage: currentPage,
            status: WallpapersScreenStatus.success,
          ),
        );
      }
    } on Exception {
      emit(state.copyWith(status: WallpapersScreenStatus.failure));
    }
  }

  FutureOr<void> _onFetchedRestart(_, Emitter<WallpapersState> emit) async {
    emit(
      state.copyWith(
        currentPage: 1,
        status: WallpapersScreenStatus.initial,
        isCache: false,
        hasReachedMax: false,
        wallpapers: [],
      ),
    );

    add(const WallpapersFetchedFromApi());
  }

  FutureOr<void> _onGridModeSwitched(_, Emitter<WallpapersState> emit) {
    if (state.displayMode == WallpaperDisplayMode.list) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.grid));
    }
  }

  FutureOr<void> _onListModeSwitched(_, Emitter<WallpapersState> emit) {
    if (state.displayMode == WallpaperDisplayMode.grid) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.list));
    }
  }

  FutureOr<void> _onWallpaperDownloaded(
    WallpaperDownloaded event,
    Emitter<WallpapersState> emit,
  ) async {
    if (event.wallpaper.isFromCache) {
      return;
    }

    emit(
      state.copyWith(
        wallpapers: _copyWallpapersStateUpdateWallpaper(
          event.wallpaper.copyWith(
            wallpaperStatus: WallpaperStatus.loading,
          ),
        ),
      ),
    );

    final wallpaperFromStorage =
        await _wallpaperRepository.saveWallpaperInStorage(
      wallpaper: event.wallpaper,
      isSetWallpaper: false,
    );

    if (wallpaperFromStorage != null) {
      emit(
        state.copyWith(
          wallpapers: _copyWallpapersStateUpdateWallpaper(
            event.wallpaper.copyWith(
              wallpaperStatus: WallpaperStatus.downloaded,
            ),
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          wallpapers: _copyWallpapersStateUpdateWallpaper(
            event.wallpaper.copyWith(
              wallpaperStatus: WallpaperStatus.initial,
            ),
          ),
        ),
      );
    }
  }

  FutureOr<void> _onWallpaperDetailThumbSmallGotBytes(
    WallpaperThumbSmallGotBytes event,
    Emitter<WallpapersState> emit,
  ) async {
    final bytes = event.wallpaper.thumbs.thumbSmall.bytes;
    final path = event.wallpaper.thumbs.thumbSmall.path;

    if (bytes == null) {
      final bytesFromNetwork =
          await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytesFromNetwork != null) {
        final wallpapers = _copyStateWallpapersUpdateThumbSmallWallpaperBytes(
          event.wallpaper,
          bytesFromNetwork,
        );

        emit(state.copyWith(wallpapers: wallpapers));
      }
    }
  }

  FutureOr<void> _onWallpaperDetailThumbOriginGotBytes(
    WallpaperThumbOriginGotBytes event,
    Emitter<WallpapersState> emit,
  ) async {
    final bytes = event.wallpaper.thumbs.thumbOrigin.bytes;
    final path = event.wallpaper.thumbs.thumbOrigin.path;

    if (bytes == null) {
      final bytesFromNetwork =
          await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytesFromNetwork != null) {
        final wallpapers = _copyStateWallpapersUpdateThumbOriginWallpaperBytes(
          event.wallpaper,
          bytesFromNetwork,
        );

        emit(state.copyWith(wallpapers: wallpapers));
      }
    }
  }

  FutureOr<void> _onWallpaperMainImageGotBytes(
    WallpaperMainImageGotBytes event,
    Emitter<WallpapersState> emit,
  ) async {
    final bytes = event.wallpaper.mainImage.bytes;
    final path = event.wallpaper.mainImage.path;

    if (bytes == null) {
      final bytesFromNetwork =
          await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytesFromNetwork != null) {
        final wallpapers = _copyStateWallpapersUpdateMainWallpaperBytes(
          event.wallpaper,
          bytesFromNetwork,
        );

        emit(state.copyWith(wallpapers: wallpapers));
      }
    }
  }

  FutureOr<void> _onWallpaperSetWallpaper(
    WallpaperSetWallpaper event,
    Emitter<WallpapersState> emit,
  ) async {
    emit(
      state.copyWith(
        wallpapers: _copyWallpapersStateUpdateWallpaper(
          event.wallpaper.copyWith(
            wallpaperStatus: WallpaperStatus.loading,
          ),
        ),
      ),
    );

    final path = event.wallpaper.mainImage.path;
    final isSet = await _wallpaperRepository.setWallpaper(path);
    if (isSet) {
      final wallpaper = event.wallpaper
          .copyWith(wallpaperStatus: WallpaperStatus.installedWallpaper);

      final wallpaperFromStorage =
          await _wallpaperRepository.saveWallpaperInStorage(
        wallpaper: wallpaper,
        isSetWallpaper: true,
      );

      if (wallpaperFromStorage != null) {
        final wallpaperModelBloc =
            _createWallpaperFromStorageToModelBloc(wallpaperFromStorage);
        emit(
          state.copyWith(
            wallpapers: _copyWallpapersStateUpdateWallpaper(
              wallpaperModelBloc.copyWith(
                wallpaperStatus: WallpaperStatus.installedWallpaper,
              ),
            ),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          wallpapers: _copyWallpapersStateUpdateWallpaper(
            event.wallpaper.copyWith(
              wallpaperStatus: WallpaperStatus.downloaded,
            ),
          ),
        ),
      );
    }
  }

  List<WallpaperModelBloc> _copyStateWallpapersUpdateThumbSmallWallpaperBytes(
    WallpaperModelBloc wallpaper,
    Uint8List bytes,
  ) {
    final copyList = List<WallpaperModelBloc>.from(state.wallpapers);

    final index = _getIndex(copyList, wallpaper.id);

    final thumbSmall = copyList[index].thumbs.thumbSmall.copyWith(bytes: bytes);

    final thumbs = copyList[index].thumbs.copyWith(thumbSmall: thumbSmall);

    copyList[index] = copyList[index].copyWith(thumbs: thumbs);

    return copyList;
  }

  List<WallpaperModelBloc> _copyStateWallpapersUpdateThumbOriginWallpaperBytes(
    WallpaperModelBloc wallpaper,
    Uint8List bytes,
  ) {
    final copyList = List<WallpaperModelBloc>.from(state.wallpapers);

    final index = _getIndex(copyList, wallpaper.id);

    final thumbOrigin =
        copyList[index].thumbs.thumbOrigin.copyWith(bytes: bytes);

    final thumbs = copyList[index].thumbs.copyWith(thumbOrigin: thumbOrigin);

    copyList[index] = copyList[index].copyWith(thumbs: thumbs);

    return copyList;
  }

  List<WallpaperModelBloc> _copyStateWallpapersUpdateMainWallpaperBytes(
    WallpaperModelBloc wallpaper,
    Uint8List bytes,
  ) {
    final copyList = List<WallpaperModelBloc>.from(state.wallpapers);

    final index = _getIndex(copyList, wallpaper.id);

    final mainImage = copyList[index].mainImage.copyWith(bytes: bytes);

    copyList[index] = copyList[index].copyWith(mainImage: mainImage);

    return copyList;
  }

  WallpaperModelBloc findById(String id) {
    return state.wallpapers.firstWhere((element) => element.id == id);
  }

  bool _hasReachedMax(MetaDomain meta) => meta.lastPage == meta.currentPage;

  Future<List<WallpaperModelBloc>> _getWallpaperFromApi(
    WallpaperResponseDomain responseDomain,
  ) async {
    final wallpapers =
        responseDomain.data.map(_createWallpaperFromApiToModelBloc).toList();

    final updatedWallpapersFromStorage =
        await _updateWallpapersFromStorage(wallpapers);

    return updatedWallpapersFromStorage;
  }

  WallpaperModelBloc _createWallpaperFromApiToModelBloc(
    WallpaperModelDomain wallpaper,
  ) {
    final w = wallpaper;

    return WallpaperModelBloc(
      id: w.id,
      favorites: w.favorites,
      category: w.category,
      resolution: w.resolution,
      fileSizeBytes: w.fileSizeBytes,
      createdAt: w.createdAt,
      mainImage: ImageWallpaperDomain(
        path: w.mainImage.path,
      ),
      thumbs: ThumbsDomain(
        thumbOrigin: ImageWallpaperDomain(
          path: w.thumbs.thumbOrigin.path,
        ),
        thumbSmall: ImageWallpaperDomain(
          path: w.thumbs.thumbSmall.path,
        ),
      ),
      isFromCache: false,
      wallpaperStatus: WallpaperStatus.initial,
    );
  }

  WallpaperModelBloc _createWallpaperFromStorageToModelBloc(
    WallpaperLocalStorage wallpaper,
  ) {
    final w = wallpaper;

    return WallpaperModelBloc(
      id: w.id,
      favorites: w.favorites,
      category: w.category,
      resolution: w.resolution,
      fileSizeBytes: w.fileSizeBytes,
      createdAt: w.createdAt,
      mainImage: ImageWallpaperDomain(
        bytes: Uint8List.fromList(w.imageBytes),
        path: w.path,
      ),
      thumbs: ThumbsDomain(
        thumbOrigin: ImageWallpaperDomain(
          bytes: Uint8List.fromList(w.thumbs.originalImageBytes),
          path: w.path,
        ),
        thumbSmall: ImageWallpaperDomain(
          bytes: Uint8List.fromList(w.thumbs.smallImageBytes),
          path: w.path,
        ),
      ),
      isFromCache: true,
      wallpaperStatus: w.isSetWallpaper
          ? WallpaperStatus.installedWallpaper
          : WallpaperStatus.downloaded,
    );
  }

  List<WallpaperModelBloc> _copyWallpapersStateUpdateWallpaper(
    WallpaperModelBloc wallpaper,
  ) {
    final wallpapers = List<WallpaperModelBloc>.from(state.wallpapers);
    final index = _getIndex(wallpapers, wallpaper.id);
    wallpapers[index] = wallpaper;

    return wallpapers;
  }

  int _getIndex(List<WallpaperModelBloc> wallpapers, String wallpaperId) {
    return wallpapers.indexWhere((element) => element.id == wallpaperId);
  }

  Future<List<WallpaperModelBloc>> _updateWallpapersFromStorage(
    List<WallpaperModelBloc> wallpapers,
  ) async {
    final updated = <WallpaperModelBloc>[];
    for (final element in wallpapers) {
      try {
        final storageWallpaper =
            await _wallpaperRepository.getWallpaperFromStorage(element.id);
        updated.add(_createWallpaperFromStorageToModelBloc(storageWallpaper));
      } on LocalStorageGetWallpaperNotFoundFailure {
        updated.add(element);
      }
    }

    return updated;
  }
}
