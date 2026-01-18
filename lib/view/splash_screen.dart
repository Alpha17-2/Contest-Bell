import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon Container
              AnimatedBuilder(
                animation: controller.pulseAnimation,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: controller.pulseAnimation,
                    child: Transform.rotate(
                      angle: 12 * math.pi / 180, // 12 degrees in radians
                      child: Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF3B82F6), // blue-500
                              Color(0xFF9333EA), // purple-600
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 60,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Transform.rotate(
                          angle: -12 * math.pi / 180, 
                          child: Image.asset('assets/cup.png')
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // App Name
              AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: const Text(
                      'Contest Bell',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827), // gray-900
                        letterSpacing: -0.5,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Tagline
              AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: const Text(
                      'Contest Reminders',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280), // gray-500
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
