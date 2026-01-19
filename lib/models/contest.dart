import 'dart:convert';

Contest contestFromJson(String str) => Contest.fromJson(json.decode(str));

String contestToJson(Contest data) => json.encode(data.toJson());

class Contest {
    String? status;
    List<Result>? result;

    Contest({
        this.status,
        this.result,
    });

    Contest copyWith({
        String? status,
        List<Result>? result,
    }) => 
        Contest(
            status: status ?? this.status,
            result: result ?? this.result,
        );

    factory Contest.fromJson(Map<String, dynamic> json) => Contest(
        status: json["status"],
        result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class Result {
    int? id;
    String? name;
    Type? type;
    Phase? phase;
    bool? frozen;
    int? durationSeconds;
    int? startTimeSeconds;
    int? relativeTimeSeconds;
    int? freezeDurationSeconds;

    Result({
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

    Result copyWith({
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
        Result(
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

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        type: typeValues.map[json["type"]]!,
        phase: phaseValues.map[json["phase"]]!,
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
