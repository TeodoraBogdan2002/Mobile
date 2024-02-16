import 'dart:isolate';

class ActivityData {
  int? id;
  String name;
  String date;
  String details;
  String status;
  int participants;
  String type;

  ActivityData({
    this.id,
    required this.name,
    required this.date,
    required this.details,
    required this.status,
    required this.participants,
    required this.type,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      id: json['id'] as int?,
      name: json['name'] as String,
      date: json['date'] as String,
      details: json['details'] as String,
      status: json['status'] as String,
      participants: json['participants'] as int,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'details': details,
      'status': status,
      'participants': participants,
      'type' : type,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'date': date,
      'details': details,
      'status': status,
      'participants':participants,
      'type':type,
    };
  }

  ActivityData copy({
    int? id,
    String? name,
    String? date,
    String? details,
    String? status,
    int? participants,
    String? type,
  }) =>
      ActivityData(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        details: details ?? this.details,
        status: status ?? this.status,
        participants: participants ?? this.participants,
        type: type?? this.type,
      );

  @override
  String toString() {
    return 'Activity Data - name: $name, date: $date, details: $details, status: $status, participants: $participants';
  }
}
