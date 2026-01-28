import 'package:contest_bell/utils/endpoints.dart';

import '../models/codeforces_contest.dart';
import 'api/api_service.dart';

class CodeforcesContestService {
  /// Fetches all Codeforces contests
  Future<List<CodeforcesContest>> getAllCodeforcesContests() async {
    try {
      // Use the 'codeforces' service for API calls (default)
      final response = await HttpService.get(
        GET_CODEFORCES_CONTESTS,
        serviceName: 'codeforces',
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data != null && data is Map<String, dynamic>) {
          // Create a single Contest object with the results
          var codeforcesContestResponse = CodeforcesContestListResponse.fromJson(data);
          return codeforcesContestResponse.result ?? [];
        }
        
        return [];
      } else {
        throw Exception('Failed to load Codeforces contests: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching Codeforces contests: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }
}
