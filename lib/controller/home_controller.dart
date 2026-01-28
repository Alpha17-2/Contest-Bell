import 'package:contest_bell/models/codechef_contest.dart';
import 'package:contest_bell/models/codeforces_contest.dart' as cdfc;
import 'package:contest_bell/models/contest.dart';
import 'package:contest_bell/services/codechef_contest_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../services/codeforces_contest_service.dart';

class HomeController extends GetxController {
  var codeforcesContests = <cdfc.CodeforcesContest>[].obs;
  var codechefContests = <CodechefContest>[].obs;
  var allContests = <Contest>[].obs;
  RxBool isLoading = false.obs;
  CodeforcesContestService codeforcesContestService =
      CodeforcesContestService();
  CodechefContestService codechefContestService =
      CodechefContestService();

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    try {
      await getCodeforcesContest();
      await getCodechefContest();
      combineContests();
    } finally {
      isLoading.value = false;
    }
  }

  void combineContests() {
    // Clear existing contests to avoid duplicates
    allContests.clear();
    
    // Add Codeforces contests
    for (var codeforcesContest in codeforcesContests) {
      final Contest contest = Contest(
        id: codeforcesContest.id,
        name: codeforcesContest.name,
        startTimeSeconds: codeforcesContest.startTimeSeconds,
        durationSeconds: codeforcesContest.durationSeconds,
        platform: 'Codeforces',
      );
      allContests.add(contest);
    }
    
    // Add CodeChef contests
    for (var codechefContest in codechefContests) {
      //Convert ISO date → epoch seconds (UTC)
      final DateTime startDate =
          DateTime.parse(codechefContest.contestStartDateIso!);

      final int startTimeSeconds =
          startDate.toUtc().millisecondsSinceEpoch ~/ 1000;

      //Convert duration (minutes → seconds)
      final int durationSeconds =
          int.parse(codechefContest.contestDuration!) * 60;

      //Create normalized Contest (Codeforces-style)
      final Contest contest = Contest(
        id: codechefContest.contestCode, 
        name: codechefContest.contestName,
        startTimeSeconds: startTimeSeconds,
        durationSeconds: durationSeconds,
        platform: 'Codechef',
      );
      allContests.add(contest);
    }
    
    // Sort the combined contests by start time (earliest first)
    allContests.sort(
      (a, b) => (a.startTimeSeconds ?? 0)
          .compareTo(b.startTimeSeconds ?? 0),
    );
  }

  Future<void> getCodechefContest() async {
    final contests = await codechefContestService.getAllUpcomingCodechefContests();
    codechefContests.value = contests;
  }

  Future<void> getCodeforcesContest() async {
    final contests = await codeforcesContestService.getAllCodeforcesContests();
    // Filter only upcoming contests (phase == BEFORE)
    final upcomingContests = contests
        .where((contest) => contest.phase == cdfc.Phase.BEFORE)
        .toList();
    codeforcesContests.value = upcomingContests;
  }

  // Helper method to get contest type display text
  String getContestTypeText(Contest contest) {
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
    return 'Codechef';
  }

  // Helper method to get contest type color
  Color getContestTypeColor(Contest contest) {
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
  Future<void> addToCalendar(Contest contest) async {
    try {
      final startTime = DateTime.fromMillisecondsSinceEpoch(
        (contest.startTimeSeconds ?? 0) * 1000,
      );
      final duration = Duration(seconds: contest.durationSeconds ?? 0);
      final endTime = startTime.add(duration);

      final Event event = Event(
        title: contest.name ?? 'Codeforces Contest',
        description: 'Coding Contest',
        location: contest.platform == 'Codeforces'
            ? 'https://codeforces.com/contest/${contest.id}'
            : 'https://codechef.com/${contest.id}',
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
