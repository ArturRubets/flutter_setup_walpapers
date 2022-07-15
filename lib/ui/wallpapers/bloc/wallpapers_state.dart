part of 'wallpapers_bloc.dart';

enum WallpaperStatus { initial, success, failure }

class WallpapersState extends Equatable {
  const WallpapersState({
    this.wallpapers = const <Wallpaper>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.status = WallpaperStatus.initial,
  });

  final List<Wallpaper> wallpapers;
  final bool hasReachedMax;
  final int currentPage;
  final WallpaperStatus status;

  @override
  List<Object?> get props {
    return [
      wallpapers,
      hasReachedMax,
      currentPage,
      status,
    ];
  }

  WallpapersState copyWith({
    List<Wallpaper>? wallpapers,
    bool? hasReachedMax,
    int? currentPage,
    WallpaperStatus? status,
  }) {
    return WallpapersState(
      wallpapers: wallpapers ?? this.wallpapers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
    );
  }
}
