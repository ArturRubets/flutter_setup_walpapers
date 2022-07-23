part of 'wallpapers_bloc.dart';

abstract class WallpapersEvent extends Equatable {
  const WallpapersEvent();

  @override
  List<Object> get props => [];
}

class WallpapersFetched extends WallpapersEvent {
  const WallpapersFetched();
}

class WallpapersFetchedFromApi extends WallpapersFetched {
  const WallpapersFetchedFromApi();
}

class WallpapersFetchedFromCache extends WallpapersFetched {
  const WallpapersFetchedFromCache();
}

class WallpapersFetchedRestart extends WallpapersEvent {
  const WallpapersFetchedRestart();
}

class WallpaperGridModeSwitched extends WallpapersEvent {
  const WallpaperGridModeSwitched();
}

class WallpaperListModeSwitched extends WallpapersEvent {
  const WallpaperListModeSwitched();
}

class WallpaperDownloaded extends WallpapersEvent {
  const WallpaperDownloaded(this.wallpaper);

  final WallpaperModelBloc wallpaper;

  @override
  List<Object> get props => [wallpaper];
}

class WallpaperDetailThumbSmallGotBytes extends WallpapersEvent {
  const WallpaperDetailThumbSmallGotBytes({required this.wallpaper});

  final WallpaperModelBloc wallpaper;

  @override
  List<Object> get props => [wallpaper];
}

class WallpaperDetailThumbOriginGotBytes extends WallpapersEvent {
  const WallpaperDetailThumbOriginGotBytes({required this.wallpaper});

  final WallpaperModelBloc wallpaper;

  @override
  List<Object> get props => [wallpaper];
}
