import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'view/splash_screen.dart';

void main(List<String> args) {
  runApp(const ContestBell());
}

class ContestBell extends StatelessWidget {
  const ContestBell({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(title: 'Contest Bell', home: SplashScreen());
  }
}
