part of 'wallpapers_bloc.dart';

abstract class WallpapersEvent extends Equatable {
  const WallpapersEvent();

  @override
  List<Object> get props => [];
}

class WallpapersFetched extends WallpapersEvent {}
