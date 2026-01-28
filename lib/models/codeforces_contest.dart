import 'dart:convert';

CodeforcesContestListResponse contestFromJson(String str) => CodeforcesContestListResponse.fromJson(json.decode(str));

String contestToJson(CodeforcesContestListResponse data) => json.encode(data.toJson());

class CodeforcesContestListResponse {
    String? status;
    List<CodeforcesContest>? result;

    CodeforcesContestListResponse({
        this.status,
        this.result,
    });

    CodeforcesContestListResponse copyWith({
        String? status,
        List<CodeforcesContest>? result,
    }) => 
        CodeforcesContestListResponse(
            status: status ?? this.status,
            result: result ?? this.result,
        );

    factory CodeforcesContestListResponse.fromJson(Map<String, dynamic> json) => CodeforcesContestListResponse(
        status: json["status"],
        result: json["result"] == null ? [] : List<CodeforcesContest>.from(json["result"]!.map((x) => CodeforcesContest.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class CodeforcesContest {
    int? id;
    String? name;
    Type? type;
    Phase? phase;
    bool? frozen;
    int? durationSeconds;
    int? startTimeSeconds;
    int? relativeTimeSeconds;
    int? freezeDurationSeconds;

    CodeforcesContest({
        this.id,
        this.name,
        this.type,
        this.phase,
        this.frozen,
        this.durationSeconds,
        this.startTimeSeconds,
        this.relativeTimeSeconds,
        this.freezeDurationSeconds,
    });

    CodeforcesContest copyWith({
        int? id,
        String? name,
        Type? type,
        Phase? phase,
        bool? frozen,
        int? durationSeconds,
        int? startTimeSeconds,
        int? relativeTimeSeconds,
        int? freezeDurationSeconds,
    }) => 
        CodeforcesContest(
            id: id ?? this.id,
            name: name ?? this.name,
            type: type ?? this.type,
            phase: phase ?? this.phase,
            frozen: frozen ?? this.frozen,
            durationSeconds: durationSeconds ?? this.durationSeconds,
            startTimeSeconds: startTimeSeconds ?? this.startTimeSeconds,
            relativeTimeSeconds: relativeTimeSeconds ?? this.relativeTimeSeconds,
            freezeDurationSeconds: freezeDurationSeconds ?? this.freezeDurationSeconds,
        );

    factory CodeforcesContest.fromJson(Map<String, dynamic> json) => CodeforcesContest(
        id: json["id"],
        name: json["name"],
        type: typeValues.map[json["type"]],
        phase: phaseValues.map[json["phase"]],
        frozen: json["frozen"],
        durationSeconds: json["durationSeconds"],
        startTimeSeconds: json["startTimeSeconds"],
        relativeTimeSeconds: json["relativeTimeSeconds"],
        freezeDurationSeconds: json["freezeDurationSeconds"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": typeValues.reverse[type],
        "phase": phaseValues.reverse[phase],
        "frozen": frozen,
        "durationSeconds": durationSeconds,
        "startTimeSeconds": startTimeSeconds,
        "relativeTimeSeconds": relativeTimeSeconds,
        "freezeDurationSeconds": freezeDurationSeconds,
    };
}

enum Phase {
    BEFORE,
    FINISHED
}

final phaseValues = EnumValues({
    "BEFORE": Phase.BEFORE,
    "FINISHED": Phase.FINISHED
});

enum Type {
    CF,
    ICPC,
    IOI
}

final typeValues = EnumValues({
    "CF": Type.CF,
    "ICPC": Type.ICPC,
    "IOI": Type.IOI
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
