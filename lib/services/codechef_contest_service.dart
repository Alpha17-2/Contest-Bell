import 'package:contest_bell/models/codechef_contest.dart';
import 'package:contest_bell/services/api/api_service.dart';
import 'package:contest_bell/utils/endpoints.dart';

class CodechefContestService {
  /// Fetches all upcoming CodeChef contests
  Future<List<CodechefContest>> getAllUpcomingCodechefContests() async {
    try {
      final response = await HttpService.get(
        GET_CODECHEF_CONTESTS,
        serviceName: 'codechef',
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data != null && data is Map<String, dynamic>) {
       
          final codechefContestListResponse = CodechefContestListResponse.fromJson(data);
          return codechefContestListResponse.futureContests ?? [];
        }
        
        return [];
      } else {
        throw Exception('Failed to load CodeChef contests: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching CodeChef contests: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }
}
