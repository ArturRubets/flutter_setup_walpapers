import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../../wallpapers/models/wallpaper.dart';

part 'wallpaper_detail_event.dart';
part 'wallpaper_detail_state.dart';

class WallpaperDetailBloc
    extends Bloc<WallpaperDetailEvent, WallpaperDetailState> {
  WallpaperDetailBloc(this._wallpaperRepository, WallpaperModelBloc wallpaper)
      : super(WallpaperDetailState(wallpaper)) {
    on<WallpaperDetailDownloaded>(_onWallpaperDetailDownloaded);
  }

  final WallpaperRepository _wallpaperRepository;

  FutureOr<void> _onWallpaperDetailDownloaded(
    WallpaperDetailDownloaded event,
    Emitter<WallpaperDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        wallpaper: state.wallpaper.copyWith(
          wallpaperDownload: WallpaperDownload.loading,
        ),
      ),
    );

    if (!state.wallpaper.isFromCache) {
      await _wallpaperRepository.saveWallpaperInStorage(state.wallpaper);
    }

    emit(
      state.copyWith(
        wallpaper: state.wallpaper.copyWith(
          wallpaperDownload: WallpaperDownload.success,
        ),
      ),
    );
  }
}
