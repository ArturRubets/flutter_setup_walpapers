part of 'wallpapers_bloc.dart';

enum WallpapersScreenStatus { initial, success, failure }

enum WallpaperDisplayMode { grid, list }

class WallpapersState extends Equatable {
  const WallpapersState({
    this.wallpapers = const <WallpaperModelBloc>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.status = WallpapersScreenStatus.initial,
    this.displayMode = WallpaperDisplayMode.grid,
    this.isCache = false,
  });

  static const limitWallpapersPerRequestToStorage = 24;
  final List<WallpaperModelBloc> wallpapers;
  final bool hasReachedMax;
  final int currentPage;
  final WallpapersScreenStatus status;
  final WallpaperDisplayMode displayMode;
  final bool isCache;

  @override
  List<Object> get props {
    return [
      wallpapers,
      hasReachedMax,
      currentPage,
      status,
      displayMode,
      isCache,
    ];
  }

  WallpapersState copyWith({
    List<WallpaperModelBloc>? wallpapers,
    bool? hasReachedMax,
    int? currentPage,
    WallpapersScreenStatus? status,
    WallpaperDisplayMode? displayMode,
    bool? isCache,
  }) {
    return WallpapersState(
      wallpapers: wallpapers ?? this.wallpapers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      displayMode: displayMode ?? this.displayMode,
      isCache: isCache ?? this.isCache,
    );
  }
}
