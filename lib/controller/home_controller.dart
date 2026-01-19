import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import '../models/contest.dart';
import '../services/codeforces_contest_service.dart';

class HomeController extends GetxController {
  var contests = <Result>[].obs;
  RxBool isLoading = false.obs;
  CodeforcesContestService codeforcesContestService =
      CodeforcesContestService();

  @override
  void onInit() {
    super.onInit();
    getContests();
  }

  void getContests() async {
    isLoading.value = true;
    try {
      final allContests = await codeforcesContestService.getAllContests();
      // Filter only upcoming contests (phase == BEFORE)
      final upcomingContests = allContests
          .where((contest) => contest.result != null)
          .expand((contest) => contest.result!)
          .where((result) => result.phase == Phase.BEFORE)
          .toList();

      // Sort by start time
      upcomingContests.sort(
        (a, b) => (a.startTimeSeconds ?? 0).compareTo(b.startTimeSeconds ?? 0),
      );

      contests.value = upcomingContests;
    } catch (e) {
      print('Error fetching contests: $e');
      contests.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get contest type display text
  String getContestTypeText(Result contest) {
    if (contest.name?.toLowerCase().contains('educational') == true) {
      return 'Educational';
    }

    if (contest.name?.toLowerCase().contains('div. 1') == true) {
      return 'Div. 1';
    }

    if (contest.name?.toLowerCase().contains('div. 2') == true) {
      return 'Div. 2';
    }

    if (contest.name?.toLowerCase().contains('div. 3') == true) {
      return 'Div. 3';
    }

    if (contest.name?.toLowerCase().contains('div. 4') == true) {
      return 'Div. 4';
    }

    return 'Contest';
  }

  // Helper method to get contest type color
  Color getContestTypeColor(Result contest) {
    final typeText = getContestTypeText(contest);

    switch (typeText) {
      case 'Educational':
        return const Color(0xFF8B5CF6); // Purple
      case 'Div. 1':
        return const Color(0xFFEF4444); // Red
      case 'Div. 2':
        return const Color(0xFF3B82F6); // Blue
      case 'Div. 3':
        return const Color(0xFF10B981); // Green
      case 'Div. 4':
        return const Color(0xFFF59E0B); // Yellow/Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Method to add contest to Google Calendar
  Future<void> addToCalendar(Result contest) async {
    try {
      final startTime = DateTime.fromMillisecondsSinceEpoch(
        (contest.startTimeSeconds ?? 0) * 1000,
      );
      final duration = Duration(seconds: contest.durationSeconds ?? 0);
      final endTime = startTime.add(duration);

      final Event event = Event(
        title: contest.name ?? 'Codeforces Contest',
        description:
            'Codeforces ${getContestTypeText(contest)}\n'
            'Contest ID: ${contest.id}\n'
            'Duration: ${formatDuration(duration)}\n'
            'Join the contest at: https://codeforces.com/contest/${contest.id}',
        location: 'https://codeforces.com/contest/${contest.id}',
        startDate: startTime,
        endDate: endTime,
        iosParams: const IOSParams(reminder: Duration(minutes: 15)),
        androidParams: const AndroidParams(emailInvites: []),
      );

      // Add to calendar
      final bool result = await Add2Calendar.addEvent2Cal(event);

      if (!result) {
        Get.snackbar(
          'Error',
          'Failed to add contest to calendar',
          icon: const Icon(Icons.error, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } 
    } catch (e) {
      print('Error adding to calendar: $e');
      Get.snackbar(
        'Error',
        'Failed to add contest to calendar: ${e.toString()}',
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Helper method to format duration
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}
