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
      if (state.status == WallpapersScreenStatus.initial) {
        final response =
            await _wallpaperRepository.getWallpaperFromApi(state.currentPage);

        final wallpapers = response.data.map(_createWallpaperFromApi).toList();

        final updatedWallpapersFromStorage =
            await _updateWallpapersFromStorage(wallpapers);

        final hasReachedMaxValue = _hasReachedMax(response.meta);

        return emit(
          state.copyWith(
            wallpapers: updatedWallpapersFromStorage,
            hasReachedMax: hasReachedMaxValue,
            currentPage: response.meta.currentPage,
            status: WallpapersScreenStatus.success,
          ),
        );
      }

      final response =
          await _wallpaperRepository.getWallpaperFromApi(state.currentPage + 1);
      final wallpapers = response.data.map(_createWallpaperFromApi).toList();

      final updatedWallpapersFromStorage =
          await _updateWallpapersFromStorage(wallpapers);

      final hasReachedMaxValue = _hasReachedMax(response.meta);

      emit(
        state.copyWith(
          wallpapers: List.of(state.wallpapers)
            ..addAll(updatedWallpapersFromStorage),
          hasReachedMax: hasReachedMaxValue,
          currentPage: response.meta.currentPage,
          status: WallpapersScreenStatus.success,
        ),
      );
    } on SocketException {
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
      if (state.status == WallpapersScreenStatus.initial) {
        final response = await _wallpaperRepository.getWallpapersFromStorage(
          state.currentPage,
          WallpapersState.limitWallpapersPerRequestToStorage,
        );

        final wallpapers = response.map(_createWallpaperFromCache).toList();
        final hasReachedMaxValue = wallpapers.length <
                WallpapersState.limitWallpapersPerRequestToStorage
            ? true
            : false;

        return emit(
          state.copyWith(
            wallpapers: wallpapers,
            hasReachedMax: hasReachedMaxValue,
            currentPage: 1,
            status: WallpapersScreenStatus.success,
          ),
        );
      }

      final currentPage = state.currentPage + 1;
      final response =
          await _wallpaperRepository.getWallpapersFromStorage(currentPage);
      final hasReachedMaxValue = response.isEmpty;
      final wallpapers = response.map(_createWallpaperFromCache).toList();

      emit(
        state.copyWith(
          wallpapers: List.of(state.wallpapers)..addAll(wallpapers),
          hasReachedMax: hasReachedMaxValue,
          currentPage: currentPage,
          status: WallpapersScreenStatus.success,
        ),
      );
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
      final isSave =
          await _wallpaperRepository.saveWallpaperInStorage(event.wallpaper);
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

  bool _hasReachedMax(MetaDomain meta) => meta.lastPage == meta.currentPage;

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
