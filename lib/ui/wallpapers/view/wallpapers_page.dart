import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../resources/resources.dart';
import '../../common_widgets/loader.dart';
import '../bloc/wallpapers_bloc.dart';
import '../widgets/widgets.dart';

class WallpapersPage extends StatelessWidget {
  const WallpapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WallpapersBloc()..add(WallpapersFetched()),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarWidget(),
            const SizedBox(height: 18),
            BlocBuilder<WallpapersBloc, WallpapersState>(
              builder: (context, state) {
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
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 203,
                            maxCrossAxisExtent: 164,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 7,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= state.wallpapers.length) {
                              return const Loader();
                            }
                            final wallpaper = state.wallpapers[index];
                            return Provider(
                              create: (context) => wallpaper,
                              child: const WallpaperWidget(),
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
