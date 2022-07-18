import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../../../resources/resources.dart';
import '../../common_widgets/loader.dart';
import '../bloc/wallpapers_bloc.dart';
import '../widgets/widgets.dart';

class WallpapersPage extends StatelessWidget {
  const WallpapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WallpapersBloc(context.read<WallpaperRepository>())
        ..add(WallpapersFetched()),
      child: const WallpapersView(),
    );
  }
}

class WallpapersView extends StatefulWidget {
  const WallpapersView({super.key});

  @override
  State<WallpapersView> createState() => _WallpapersViewState();
}

class _WallpapersViewState extends State<WallpapersView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    const wallpaperGridMode = WallpaperGridMode();

    const wallpaperListMode = WallpaperListMode();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarWidget(),
            const SizedBox(height: 18),
            BlocBuilder<WallpapersBloc, WallpapersState>(
              builder: (context, 
              state) {
                final isGridMode =
                    state.displayMode == WallpaperDisplayMode.grid;
                final gridDelegate = isGridMode
                    ? const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 203,
                        maxCrossAxisExtent: 170,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                      )
                    : const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                        crossAxisCount: 1,
                        childAspectRatio: 327 / 130,
                      );

                switch (state.status) {
                  case WallpaperStatus.initial:
                    return const Loader();
                  case WallpaperStatus.failure:
                    return const Center(
                        child: Text('failed to fetch wallpapers'));
                  case WallpaperStatus.success:
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          controller: _scrollController,
                          itemCount: state.wallpapers.length,
                          gridDelegate: gridDelegate,
                          itemBuilder: (context, index) {
                            if (index >= state.wallpapers.length) {
                              return const Loader();
                            }
                            final wallpaper = state.wallpapers[index];
                            return MultiProvider(
                              providers: [
                                Provider(create: (_) => wallpaper),
                                Provider(create: (_) => index),
                              ],
                              child: isGridMode
                                  ? wallpaperGridMode
                                  : wallpaperListMode,
                            );
                          },
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final isBottom = currentScroll >= (maxScroll * 0.9);

    if (isBottom) {
      context.read<WallpapersBloc>().add(WallpapersFetched());
    }
  }
}
