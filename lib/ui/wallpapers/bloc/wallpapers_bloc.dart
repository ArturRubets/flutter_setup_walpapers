import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';

part 'wallpapers_event.dart';
part 'wallpapers_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class WallpapersBloc extends Bloc<WallpapersEvent, WallpapersState> {
  WallpapersBloc() : super(const WallpapersState()) {
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
  }

  final _wallpaperRepository = WallpaperRepository();

  FutureOr<void> _onFetched(
      WallpapersFetched event, Emitter<WallpapersState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == WallpaperStatus.initial) {
        final wallpapers = await _fetchWallpapers(state.currentPage);
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
      final wallpapers = await _fetchWallpapers(state.currentPage + 1);
      final hasReachedMax = _hasReachedMax(wallpapers);
      emit(
        state.copyWith(
          wallpapers: List.of(state.wallpapers)..addAll(wallpapers.data),
          hasReachedMax: hasReachedMax,
          currentPage: wallpapers.meta.currentPage,
          status: WallpaperStatus.success,
        ),
      );
    } catch (e) {
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

  bool _hasReachedMax(WallpaperResponse wallpapers) {
    return wallpapers.meta.lastPage == wallpapers.meta.currentPage;
  }

  Future<WallpaperResponse> _fetchWallpapers(int page) async {
    return await _wallpaperRepository.getWallpaper(page);
  }
}
