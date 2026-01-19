import 'package:contest_bell/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> pulseAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    initializeAnimations();
    startSplashFlow();
  }

  void initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController.repeat(reverse: true);
  }

  void startSplashFlow() {
    // Navigate to main screen after 1 seconds
    Future.delayed(const Duration(seconds: 1), () {
      navigateToMainScreen();
    });
  }

  void navigateToMainScreen() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
