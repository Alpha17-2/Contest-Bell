import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'services/api/api_service.dart';
import 'utils/routes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HTTP service
  await HttpService.initialize();

  runApp(const ContestBell());
}

class ContestBell extends StatelessWidget {
  const ContestBell({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.getPages(),
      title: 'Contest Bell',
    );
  }
}
