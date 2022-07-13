import 'package:flutter/material.dart';

class WallpapersOverviewPage extends StatelessWidget {
  const WallpapersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ColoredBox(
          color: Colors.yellow,
          child: Image(
            image: AssetImage('assets/images/expand.png'),
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
