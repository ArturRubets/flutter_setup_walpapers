import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../../wallpapers/models/wallpaper_response.dart';

part 'wallpaper_detail_event.dart';
part 'wallpaper_detail_state.dart';

class WallpaperDetailBloc
    extends Bloc<WallpaperDetailEvent, WallpaperDetailState> {
  WallpaperDetailBloc(
    this._wallpaperRepository,
    WallpaperModelBloc wallpaper,
  ) : super(WallpaperDetailState(wallpaper)) {
    on<WallpaperDetailDownloaded>(_onWallpaperDetailDownloaded);
    on<WallpaperDetailGotImageInBytes>(_onWallpaperDetailGotImageInBytes);
  }

  final WallpaperRepository _wallpaperRepository;

  FutureOr<void> _onWallpaperDetailDownloaded(
    WallpaperDetailDownloaded event,
    Emitter<WallpaperDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        wallpaper: state.wallpaper.copyWith(
          wallpaperStatus: WallpaperStatus.loading,
        ),
      ),
    );

    if (!state.wallpaper.isFromCache) {
      final isSave = await _wallpaperRepository.saveWallpaperInStorage(
        state.wallpaper,
        state.wallpaper.mainImageBytesFromApi.bytes,
        state.wallpaper.thumbSmallImageBytesFromApi.bytes,
        state.wallpaper.thumbOriginalImageBytesFromApi.bytes,
      );
      if (isSave) {
        emit(
          state.copyWith(
            wallpaper: state.wallpaper.copyWith(
              wallpaperStatus: WallpaperStatus.downloaded,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            wallpaper: state.wallpaper.copyWith(
              wallpaperStatus: WallpaperStatus.initial,
            ),
          ),
        );
      }
    }
  }

  FutureOr<void> _onWallpaperDetailGotImageInBytes(
    WallpaperDetailGotImageInBytes event,
    Emitter<WallpaperDetailState> emit,
  ) async {
    final mainImage = state.wallpaper.mainImage;
    final bytes = mainImage?.bytes;
    final path = mainImage?.path;

    if (bytes != null) {
      final newWallpaper = state.wallpaper
          .copyWith(mainImageBytesFromApi: CacheImageBytes(bytes: bytes));

      emit(state.copyWith(wallpaper: newWallpaper));
    } else if (path != null) {
      final bytes = await _wallpaperRepository.imageFromNetworkInBytes(path);

      if (bytes != null) {
        final newWallpaper = state.wallpaper
            .copyWith(mainImageBytesFromApi: CacheImageBytes(bytes: bytes));

        emit(state.copyWith(wallpaper: newWallpaper));
      }
    }
  }
}
