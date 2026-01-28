import 'dart:convert';

CodechefContestListResponse codechefContestFromJson(String str) => CodechefContestListResponse.fromJson(json.decode(str));

class CodechefContestListResponse {
    String? status;
    String? message;
    List<CodechefContest>? futureContests;


    CodechefContestListResponse({
        this.status,
        this.message,
        this.futureContests,
    });

    CodechefContestListResponse copyWith({
        String? status,
        String? message,
        List<CodechefContest>? futureContests,
        
    }) => 
        CodechefContestListResponse(
            status: status ?? this.status,
            message: message ?? this.message,
            
            futureContests: futureContests ?? this.futureContests,
        );

    factory CodechefContestListResponse.fromJson(Map<String, dynamic> json) => CodechefContestListResponse(
        status: json["status"],
        message: json["message"],
        futureContests: json["contests"] == null ? [] : List<CodechefContest>.from(json["contests"]!.map((x) => CodechefContest.fromJson(x))),
    );
}

class CodechefContest {
    String? contestCode;
    String? contestName;
    String? contestStartDate;
    String? contestEndDate;
    String? contestStartDateIso;
    String? contestEndDateIso;
    String? contestDuration;
    int? distinctUsers;
    int? problemCount;

    CodechefContest({
        this.contestCode,
        this.contestName,
        this.contestStartDate,
        this.contestEndDate,
        this.contestStartDateIso,
        this.contestEndDateIso,
        this.contestDuration,
        this.distinctUsers,
        this.problemCount,
    });

    CodechefContest copyWith({
        String? contestCode,
        String? contestName,
        String? contestStartDate,
        String? contestEndDate,
        String? contestStartDateIso,
        String? contestEndDateIso,
        String? contestDuration,
        int? distinctUsers,
        int? problemCount,
    }) => 
        CodechefContest(
            contestCode: contestCode ?? this.contestCode,
            contestName: contestName ?? this.contestName,
            contestStartDate: contestStartDate ?? this.contestStartDate,
            contestEndDate: contestEndDate ?? this.contestEndDate,
            contestStartDateIso: contestStartDateIso ?? this.contestStartDateIso,
            contestEndDateIso: contestEndDateIso ?? this.contestEndDateIso,
            contestDuration: contestDuration ?? this.contestDuration,
            distinctUsers: distinctUsers ?? this.distinctUsers,
            problemCount: problemCount ?? this.problemCount,
        );

    factory CodechefContest.fromJson(Map<String, dynamic> json) => CodechefContest(
        contestCode: json["contest_code"],
        contestName: json["contest_name"],
        contestStartDate: json["contest_start_date"],
        contestEndDate: json["contest_end_date"],
        contestStartDateIso: json["contest_start_date_iso"],
        contestEndDateIso: json["contest_end_date_iso"],
        contestDuration: json["contest_duration"],
        distinctUsers: json["distinct_users"],
        problemCount: json["problem_count"],
    );

    Map<String, dynamic> toJson() => {
        "contest_code": contestCode,
        "contest_name": contestName,
        "contest_start_date": contestStartDate,
        "contest_end_date": contestEndDate,
        "contest_start_date_iso": contestStartDateIso,
        "contest_end_date_iso": contestEndDateIso,
        "contest_duration": contestDuration,
        "distinct_users": distinctUsers,
        "problem_count": problemCount,
    };
}
