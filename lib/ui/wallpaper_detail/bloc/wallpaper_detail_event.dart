part of 'wallpaper_detail_bloc.dart';

abstract class WallpaperDetailEvent extends Equatable {
  const WallpaperDetailEvent();

  @override
  List<Object> get props => [];
}

class WallpaperDetailDownloaded extends WallpaperDetailEvent {
  const WallpaperDetailDownloaded();
}
