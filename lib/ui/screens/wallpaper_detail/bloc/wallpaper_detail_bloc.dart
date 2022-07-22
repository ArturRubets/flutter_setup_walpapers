import 'dart:async';

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
    // on<WallpaperDetailGotImageInBytes>(_onWallpaperDetailGotImageInBytes);
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
      await _wallpaperRepository.saveWallpaperInStorage(state.wallpaper);
    }

    emit(
      state.copyWith(
        wallpaper: state.wallpaper.copyWith(
          wallpaperStatus: WallpaperStatus.downloaded,
        ),
      ),
    );
  }

  // FutureOr<void> _onWallpaperDetailGotImageInBytes(
  //   WallpaperDetailGotImageInBytes event,
  //   Emitter<WallpaperDetailState> emit,
  // ) {
  //   emit(
  //     state.copyWith(
  //       wallpaper: state.wallpaper.copyWith(imageBytes: event.imageInBytes),
  //     ),
  //   );
  // }

  // Future<Image?> getImageWidget(String? path, List<int>? imageBytes) async {
  //   Image? image;
  //   if (imageBytes != null) {
  //     image = Image.memory(
  //       Uint8List.fromList(imageBytes),
  //       fit: BoxFit.cover,
  //     );
  //   } else if (path != null) {
  //     final imageBytesFromPath =
  //         await _wallpaperRepository.imageFromNetworkInBytes(path);

  //     add(WallpaperDetailGotImageInBytes(imageInBytes: imageBytesFromPath));

  //     if (imageBytesFromPath != null) {
  //       image = Image.memory(
  //         Uint8List.fromList(imageBytesFromPath),
  //         fit: BoxFit.cover,
  //       );
  //     }
  //   }
  //   return image;
  // }

}
