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
    on<WallpaperDetailThumbSmallGotBytes>(
      _onWallpaperDetailThumbSmallGotBytes,
      transformer: concurrent(),
    );
    on<WallpaperDetailThumbOriginGotBytes>(
      _onWallpaperDetailThumbOriginGotBytes,
      transformer: concurrent(),
    );
  }

  final WallpaperRepository _wallpaperRepository;

  FutureOr<void> _onFetched(
    WallpapersFetched event,
    Emitter<WallpapersState> emit,
  ) {
    if (state.isCache) {
      add(const WallpapersFetchedFromCache());
    } else {
      add(const WallpapersFetchedFromApi());
    }
  }

  FutureOr<void> _onFetchedFromApi(
    WallpapersFetchedFromApi event,
    Emitter<WallpapersState> emit,
  ) async {
    if (state.hasReachedMax) {
      emit(state.copyWith(status: WallpapersScreenStatus.success));
      return;
    }

    try {
      final int currentPage;
      if (state.status == WallpapersScreenStatus.initial) {
        currentPage = state.currentPage;
      } else {
        currentPage = state.currentPage + 1;
      }

      final response =
          await _wallpaperRepository.getWallpaperFromApi(currentPage);

      if (response.data.isEmpty) throw const WallpapersEmpty();

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
    } catch (_) {
      emit(state.copyWith(status: WallpapersScreenStatus.failure));
    }
  }

  FutureOr<void> _onFetchedFromCache(
    WallpapersFetchedFromCache event,
    Emitter<WallpapersState> emit,
  ) async {
    if (state.hasReachedMax) {
      emit(state.copyWith(status: WallpapersScreenStatus.success));
      return;
    }

    try {
      final int currentPage;
      if (state.status == WallpapersScreenStatus.initial) {
        currentPage = state.currentPage;
      } else {
        currentPage = state.currentPage + 1;
      }

      final response = await _wallpaperRepository.getWallpapersFromStorage(
        currentPage,
        WallpapersState.limitWallpapersPerRequestToStorage,
      );

      if (response.isEmpty) throw const WallpapersEmpty();

      final wallpapers = response.map(_createWallpaperFromCache).toList();
      final hasReachedMaxValue =
          wallpapers.length < WallpapersState.limitWallpapersPerRequestToStorage
              ? true
              : false;

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
    } catch (_) {
      emit(state.copyWith(status: WallpapersScreenStatus.failure));
    }
  }

  FutureOr<void> _onFetchedRestart(
    WallpapersFetchedRestart event,
    Emitter<WallpapersState> emit,
  ) async {
    emit(state.copyWith(
      currentPage: 1,
      status: WallpapersScreenStatus.initial,
      isCache: false,
      hasReachedMax: false,
      wallpapers: [],
    ));

    add(const WallpapersFetchedFromApi());
  }

  FutureOr<void> _onGridModeSwitched(
    WallpaperGridModeSwitched event,
    Emitter<WallpapersState> emit,
  ) {
    if (state.displayMode == WallpaperDisplayMode.list) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.grid));
    }
  }

  FutureOr<void> _onListModeSwitched(
    WallpaperListModeSwitched event,
    Emitter<WallpapersState> emit,
  ) {
    if (state.displayMode == WallpaperDisplayMode.grid) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.list));
    }
  }

  FutureOr<void> _onWallpaperDownloaded(
    WallpaperDownloaded event,
    Emitter<WallpapersState> emit,
  ) async {
    emit(
      state.copyWith(
        wallpapers: _updateWallpaperStatus(
          event.wallpaper,
          WallpaperStatus.loading,
        ),
      ),
    );

    if (!event.wallpaper.isFromCache) {
      final isSave = await _wallpaperRepository.saveWallpaperInStorage(
        event.wallpaper,
        event.wallpaper.mainImageBytesFromApi.bytes,
        event.wallpaper.thumbSmallImageBytesFromApi.bytes,
        event.wallpaper.thumbOriginalImageBytesFromApi.bytes,
      );
      if (isSave) {
        emit(
          state.copyWith(
            wallpapers: _updateWallpaperStatus(
              event.wallpaper,
              WallpaperStatus.downloaded,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            wallpapers: _updateWallpaperStatus(
              event.wallpaper,
              WallpaperStatus.initial,
            ),
          ),
        );
      }
    }
  }

  FutureOr<void> _onWallpaperDetailThumbSmallGotBytes(
    WallpaperDetailThumbSmallGotBytes event,
    Emitter<WallpapersState> emit,
  ) async {
    final thumb = event.wallpaper.thumbs?.thumbSmall;
    final bytes = thumb?.bytes;
    final path = thumb?.path;

    if (bytes != null) {
      final wallpapers = _copyStateWallpapersUpdateThumbSmallWallpaperBytes(
          event.wallpaper, bytes);

      emit(state.copyWith(wallpapers: wallpapers));
    } else if (path != null) {
      final bytes = await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytes != null) {
        final wallpapers = _copyStateWallpapersUpdateThumbSmallWallpaperBytes(
            event.wallpaper, bytes);

        emit(state.copyWith(wallpapers: wallpapers));
      }
    }
  }

  FutureOr<void> _onWallpaperDetailThumbOriginGotBytes(
    WallpaperDetailThumbOriginGotBytes event,
    Emitter<WallpapersState> emit,
  ) async {
    final thumb = event.wallpaper.thumbs?.thumbOrigin;
    final bytes = thumb?.bytes;
    final path = thumb?.path;

    if (bytes != null) {
      final wallpapers = _copyStateWallpapersUpdateThumbOriginWallpaperBytes(
          event.wallpaper, bytes);

      emit(state.copyWith(wallpapers: wallpapers));
    } else if (path != null) {
      final bytes = await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytes != null) {
        final wallpapers = _copyStateWallpapersUpdateThumbOriginWallpaperBytes(
            event.wallpaper, bytes);

        emit(state.copyWith(wallpapers: wallpapers));
      }
    }
  }

  List<WallpaperModelBloc> _copyStateWallpapersUpdateThumbSmallWallpaperBytes(
    WallpaperModelBloc wallpaper,
    Uint8List bytes,
  ) {
    final copyList = List<WallpaperModelBloc>.from(state.wallpapers);

    final cacheImageBytes =
        wallpaper.thumbSmallImageBytesFromApi.copyWith(bytes: bytes);

    final index = _getIndex(copyList, wallpaper.id);

    copyList[index] =
        copyList[index].copyWith(thumbSmallImageBytesFromApi: cacheImageBytes);
    return copyList;
  }

  List<WallpaperModelBloc> _copyStateWallpapersUpdateThumbOriginWallpaperBytes(
    WallpaperModelBloc wallpaper,
    Uint8List bytes,
  ) {
    final copyList = List<WallpaperModelBloc>.from(state.wallpapers);

    final cacheImageBytes =
        wallpaper.thumbOriginalImageBytesFromApi.copyWith(bytes: bytes);

    final index = _getIndex(copyList, wallpaper.id);

    copyList[index] = copyList[index]
        .copyWith(thumbOriginalImageBytesFromApi: cacheImageBytes);
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
        responseDomain.data.map(_createWallpaperFromApi).toList();

    final updatedWallpapersFromStorage =
        await _updateWallpapersFromStorage(wallpapers);
    return updatedWallpapersFromStorage;
  }

  WallpaperModelBloc _createWallpaperFromApi(WallpaperModelDomain wallpaper) {
    final w = wallpaper;
    return WallpaperModelBloc(
      id: w.id,
      favorites: w.favorites,
      category: w.category,
      resolution: w.resolution,
      fileSizeBytes: w.fileSizeBytes,
      createdAt: w.createdAt,
      mainImage: ImageWallpaperDomain(
        bytes: null,
        path: w.mainImage?.path,
      ),
      thumbs: ThumbsDomain(
        thumbOrigin: ImageWallpaperDomain(
          bytes: null,
          path: w.thumbs?.thumbOrigin?.path,
        ),
        thumbSmall: ImageWallpaperDomain(
          bytes: null,
          path: w.thumbs?.thumbSmall?.path,
        ),
      ),
      isFromCache: false,
      wallpaperStatus: WallpaperStatus.initial,
    );
  }

  WallpaperModelBloc _createWallpaperFromCache(
      WallpaperLocalStorage wallpaper) {
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
        path: null,
      ),
      thumbs: ThumbsDomain(
        thumbOrigin: ImageWallpaperDomain(
          bytes: Uint8List.fromList(w.thumbs.originalImageBytes),
          path: null,
        ),
        thumbSmall: ImageWallpaperDomain(
          bytes: Uint8List.fromList(w.thumbs.smallImageBytes),
          path: null,
        ),
      ),
      isFromCache: true,
      wallpaperStatus: w.isSetWallpaper
          ? WallpaperStatus.installedWallpaper
          : WallpaperStatus.downloaded,
    );
  }

  List<WallpaperModelBloc> _updateWallpaperStatus(
    WallpaperModelBloc wallpaper,
    WallpaperStatus status,
  ) {
    final wallpapers = List<WallpaperModelBloc>.from(state.wallpapers);
    final index = _getIndex(wallpapers, wallpaper.id);
    wallpapers[index] = wallpapers[index].copyWith(wallpaperStatus: status);
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
        updated.add(_createWallpaperFromCache(storageWallpaper));
      } on LocalStorageGetWallpaperNotFoundFailure {
        updated.add(element);
      }
    }
    return updated;
  }
}
