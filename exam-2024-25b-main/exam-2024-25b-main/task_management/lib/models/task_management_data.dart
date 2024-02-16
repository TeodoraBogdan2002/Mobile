class TaskManagementData {
  int? id;
  String date;
  String type;
  double duration;
  String priority;
  String category;
  String description;

  TaskManagementData({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.priority,
    required this.category,
    required this.description,
  });

  factory TaskManagementData.fromJson(Map<String, dynamic> json) {
    return TaskManagementData(
      id: json['id'] as int?,
      date: json['date'] as String,
      type: json['type'] as String,
      duration: json['duration'] as double,
      priority: json['priority'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'duration': duration,
      'priority': priority,
      'category': category,
      'description': description,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'date': date,
      'type': type,
      'duration': duration,
      'priority': priority,
      'category': category,
      'description': description,
    };
  }

  TaskManagementData copy({
    int? id,
    String? date,
    String? type,
    double? duration,
    String? priority,
    String? category,
    String? description,
  }) =>
      TaskManagementData(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        duration: duration ?? this.duration,
        priority: priority ?? this.priority,
        category: category ?? this.category,
        description: description ?? this.description,
      );

  @override
  String toString() {
    return 'TaskManagementData - date: $date, type: $type, duration: $duration, priority: $priority, category: $category, description: $description';
  }
}
