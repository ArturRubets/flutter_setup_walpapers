import 'package:flutter/material.dart';

import '../../navigation/main_navigation.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: MainNavigation.onGenerateRoute,
      initialRoute: MainNavigationRouteNames.wallpapersScreen,
    );
  }
}
