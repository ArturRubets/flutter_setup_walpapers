part of 'wallpapers_bloc.dart';

abstract class WallpapersEvent extends Equatable {
  const WallpapersEvent();

  @override
  List<Object> get props => [];
}

class WallpapersFetched extends WallpapersEvent {}

class WallpapersFetchedUpdate extends WallpapersEvent {}

class WallpaperGridModeSwitched extends WallpapersEvent {}

class WallpaperListModeSwitched extends WallpapersEvent {}

class WallpaperDownloaded extends WallpapersEvent {
  const WallpaperDownloaded(
    this.wallpaperBloc,
    this.indexWallpaperInList,
  );

  final WallpaperModelBloc wallpaperBloc;
  final int indexWallpaperInList;
}
