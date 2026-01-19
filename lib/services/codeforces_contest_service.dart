import 'package:contest_bell/utils/endpoints.dart';

import '../models/contest.dart';
import 'api/api_service.dart';

class CodeforcesContestService {
  Future<List<Contest>> getAllContests() async {
    try {
      final response = await HttpService.get(GET_CONTESTS);
      if (response.statusCode == 200) {
        final data = response.data;
        // Create a single Contest object with the results
        final contest = Contest(
          status: data['status'],
          result: (data['result'] as List)
              .map((contestData) => Result.fromJson(contestData))
              .toList(),
        );
        return [contest];
      } else {
        throw Exception('Failed to load contests');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching contests: $e');
      return [];
    }
  }
}
