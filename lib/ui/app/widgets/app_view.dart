import 'package:flutter/material.dart';

import '../../navigation/main_navigation.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        onGenerateRoute: onGenerateRoute,
        initialRoute: MainNavigationRouteNames.wallpapersScreen,
      );
}
