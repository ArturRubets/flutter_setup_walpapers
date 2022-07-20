part of 'wallpapers_bloc.dart';

enum WallpaperStatus { initial, loading, success, failure }

enum WallpaperDisplayMode { grid, list }

class WallpapersState extends Equatable {
  const WallpapersState({
    this.wallpapers = const <WallpaperModelBloc>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.status = WallpaperStatus.initial,
    this.displayMode = WallpaperDisplayMode.grid,
  });

  final List<WallpaperModelBloc> wallpapers;
  final bool hasReachedMax;
  final int currentPage;
  final WallpaperStatus status;
  final WallpaperDisplayMode displayMode;

  @override
  List<Object?> get props {
    return [
      wallpapers,
      hasReachedMax,
      currentPage,
      status,
      displayMode,
    ];
  }

  WallpapersState copyWith({
    List<WallpaperModelBloc>? wallpapers,
    bool? hasReachedMax,
    int? currentPage,
    WallpaperStatus? status,
    WallpaperDisplayMode? displayMode,
  }) {
    return WallpapersState(
      wallpapers: wallpapers ?? this.wallpapers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      displayMode: displayMode ?? this.displayMode,
    );
  }
}
