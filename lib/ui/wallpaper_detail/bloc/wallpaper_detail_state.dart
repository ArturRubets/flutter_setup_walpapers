part of 'wallpaper_detail_bloc.dart';

class WallpaperDetailState extends Equatable {
  const WallpaperDetailState(this.wallpaper);

  final WallpaperModelBloc wallpaper;

  @override
  List<Object?> get props => [wallpaper];

  WallpaperDetailState copyWith({
    WallpaperModelBloc? wallpaper,
  }) {
    return WallpaperDetailState(
      wallpaper ?? this.wallpaper,
    );
  }
}
