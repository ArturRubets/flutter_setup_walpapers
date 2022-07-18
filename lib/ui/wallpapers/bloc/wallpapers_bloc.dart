import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../data/local_storage/local_storage_wallpapers/models/wallpaper.dart';
import '../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../models/wallpaper.dart';

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
    on<WallpaperGridModeSwitched>(
      _onGridModeSwitched,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpaperListModeSwitched>(
      _onListModeSwitched,
      transformer: _throttleDroppable(_throttleDuration),
    );
    on<WallpaperDownloaded>(
      _onWallpaperDownloaded,
      transformer: _throttleDroppable(_throttleDuration),
    );
  }

  final WallpaperRepository _wallpaperRepository;

  FutureOr<void> _onFetched(
    WallpapersFetched event,
    Emitter<WallpapersState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == WallpaperStatus.initial) {
        final wallpapers =
            await _fetchWallpapersFromApiAndCache(state.currentPage);
        final hasReachedMax = _hasReachedMax(wallpapers);

        return emit(
          state.copyWith(
            wallpapers: wallpapers.data,
            hasReachedMax: hasReachedMax,
            currentPage: wallpapers.meta.currentPage,
            status: WallpaperStatus.success,
          ),
        );
      }
      final wallpapers =
          await _fetchWallpapersFromApiAndCache(state.currentPage + 1);
      final hasReachedMax = _hasReachedMax(wallpapers);
      emit(
        state.copyWith(
          wallpapers: List.of(state.wallpapers)..addAll(wallpapers.data),
          hasReachedMax: hasReachedMax,
          currentPage: wallpapers.meta.currentPage,
          status: WallpaperStatus.success,
        ),
      );
    } on SocketException {
      final wallpapers = _createAllWallpapersBlocFromCache().data;
      emit(
        state.copyWith(
          hasReachedMax: true,
          status: WallpaperStatus.success,
          wallpapers: wallpapers,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: WallpaperStatus.failure));
    }
  }

  FutureOr<void> _onGridModeSwitched(
      WallpaperGridModeSwitched event, Emitter<WallpapersState> emit) {
    if (state.displayMode == WallpaperDisplayMode.list) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.grid));
    }
  }

  FutureOr<void> _onListModeSwitched(
      WallpaperListModeSwitched event, Emitter<WallpapersState> emit) {
    if (state.displayMode == WallpaperDisplayMode.grid) {
      emit(state.copyWith(displayMode: WallpaperDisplayMode.list));
    }
  }

  bool _hasReachedMax(WallpaperResponseBloc wallpapers) {
    final lastPage = wallpapers.meta.lastPage;
    final currentPage = wallpapers.meta.currentPage;
    return lastPage == currentPage;
  }

  Future<WallpaperResponseBloc> _fetchWallpapersFromApiAndCache(
      int page) async {
    final wallpapersApi = await _wallpaperRepository.getWallpaper(page);
    final wallpapersStorage = _wallpaperRepository.getWallpaperFromStorage();

    final wallpapersBloc = <WallpaperModelBloc>[];

    for (var i = 0; i < wallpapersApi.data.length; i++) {
      if (_findWallpaperInCacheById(
        wallpapersStorage,
        wallpapersApi.data[i].id,
      )) {
        final wallpaper = _createWallpaperBlocFromCache(wallpapersStorage
            .firstWhere((element) => element.id == wallpapersApi.data[i].id));
        wallpapersBloc.add(wallpaper);
      } else {
        final wallpaper = _createWallpaperBlocFromApi(wallpapersApi.data[i]);
        wallpapersBloc.add(wallpaper);
      }
    }

    return WallpaperResponseBloc(
      data: wallpapersBloc,
      meta: MetaBloc(
        currentPage: wallpapersApi.meta.currentPage,
        lastPage: wallpapersApi.meta.lastPage,
      ),
    );
  }

  bool _findWallpaperInCacheById(
    List<WallpaperLocalStorage> wallpaperRepository,
    String id,
  ) {
    return wallpaperRepository.map((e) => e.id).contains(id);
  }

  WallpaperResponseBloc _createAllWallpapersBlocFromCache() {
    final wallpaperStorage = _wallpaperRepository.getWallpaperFromStorage();
    final wallpapers = wallpaperStorage
        .map<WallpaperModelBloc>(_createWallpaperBlocFromCache)
        .toList();
    return WallpaperResponseBloc(
      data: wallpapers,
      meta: const MetaBloc(
        currentPage: 1,
        lastPage: 1,
      ),
    );
  }

  WallpaperModelBloc _createWallpaperBlocFromCache(WallpaperLocalStorage w) {
    return WallpaperModelBloc(
      favorites: w.favorites,
      category: w.category,
      resolution: w.resolution,
      fileSizeBytes: w.fileSizeBytes,
      createdAt: w.createdAt,
      path: null,
      thumbs: ThumbsBloc(
        original: null,
        small: null,
        thumbOriginalBytes: w.thumbs.originalImageBytes,
        thumbSmallBytes: w.thumbs.smallImageBytes,
      ),
      id: w.id,
      imageBytes: w.imageBytes,
      isFromCache: true,
      wallpaperDownload: WallpaperDownload.success,
    );
  }

  WallpaperModelBloc _createWallpaperBlocFromApi(WallpaperDomain w) {
    return WallpaperModelBloc(
      favorites: w.favorites,
      category: w.category,
      resolution: w.resolution,
      fileSizeBytes: w.fileSizeBytes,
      createdAt: w.createdAt,
      path: w.path,
      thumbs: ThumbsBloc(
        original: w.thumbs.original,
        small: w.thumbs.small,
        thumbOriginalBytes: null,
        thumbSmallBytes: null,
      ),
      id: w.id,
      imageBytes: null,
      isFromCache: false,
      wallpaperDownload: WallpaperDownload.initial,
    );
  }

  FutureOr<void> _onWallpaperDownloaded(
    WallpaperDownloaded event,
    Emitter<WallpapersState> emit,
  ) async {
    final eventWallpaper = event.wallpaperBloc;
    final eventIndex = event.indexWallpaperInList;

    emit(
      state.copyWith(
        wallpapers: _updateWallpaperDownloadList(
          eventIndex,
          WallpaperDownload.loading,
        ),
      ),
    );
    if (!event.wallpaperBloc.isFromCache) {
      await _wallpaperRepository.saveWallpaperInStorage(eventWallpaper);
    }
    emit(
      state.copyWith(
        wallpapers: _updateWallpaperDownloadList(
          eventIndex,
          WallpaperDownload.success,
        ),
      ),
    );
  }

  List<WallpaperModelBloc> _updateWallpaperDownloadList(
      int eventIndex, WallpaperDownload status) {
    var wallpaperUpdate = List<WallpaperModelBloc>.from(state.wallpapers);

    wallpaperUpdate[eventIndex] =
        wallpaperUpdate[eventIndex].copyWith(wallpaperDownload: status);

    return wallpaperUpdate;
  }
}
