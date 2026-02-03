import 'package:contest_bell/controller/home_controller.dart';
import 'package:contest_bell/models/contest.dart';
import 'package:contest_bell/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header Section
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contest Bell',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Constants.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${homeController.allContests.length} upcoming contests',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Constants.lightIconColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Content Section
              Expanded(
                child: Obx(() {
                  if (homeController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Constants.loadingIndicatorColor,
                        ),
                      ),
                    );
                  }

                  if (homeController.allContests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No contests available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for upcoming contests',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: homeController.allContests.length,
                    itemBuilder: (context, index) {
                      final contest = homeController.allContests[index];
                      return ContestCard(
                        contest: contest,
                        controller: homeController,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  final Contest contest;
  final HomeController controller;

  const ContestCard({
    super.key,
    required this.contest,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.fromMillisecondsSinceEpoch(
      (contest.startTimeSeconds ?? 0) * 1000,
    );

    final duration = Duration(seconds: contest.durationSeconds ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest.name ?? 'Unknown Contest',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Constants.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            contest.platform == 'Codeforces'
                                ? 'assets/codeforces_logo.png'
                                : 'assets/codechef_logo.png',
                            height: 25,
                            fit: BoxFit.fitHeight,
                          ),
                          const SizedBox(width: 8),
                          if (contest.platform == 'Codeforces' && controller.getContestTypeText(contest) != null) Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: controller.getContestTypeColor(contest),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              controller.getContestTypeText(contest)!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Only notification icon with tap functionality
                GestureDetector(
                  onTap: () => controller.addToCalendar(contest),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Constants.lightIconColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contest details
            Row(
              children: [
                // Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Constants.lightIconColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Constants.lightIconColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM').format(startTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Constants.textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Constants.lightIconColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Constants.lightIconColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(startTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Constants.textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Constants.lightIconColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Duration',
                            style: TextStyle(
                              fontSize: 12,
                              color: Constants.lightIconColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.formatDuration(duration),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Constants.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
