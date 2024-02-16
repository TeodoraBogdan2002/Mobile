class EventData {
  int? id;
  String name;
  String organizer;
  String category;
  int capacity;
  int registered;

  EventData({
    this.id,
    required this.name,
    required this.organizer,
    required this.category,
    required this.capacity,
    required this.registered,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] as int?,
      name: json['name'] as String,
      organizer: json['organizer'] as String,
      category: json['category'] as String,
      capacity: json['capacity'] as int,
      registered: json['registered'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organizer': organizer,
      'category': category,
      'capacity': capacity,
      'registered': registered,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'organizer': organizer,
      'category': category,
      'capacity': capacity,
      'registered': registered,
    };
  }

  EventData copy({
    int? id,
    String? name,
    String? organizer,
    String? category,
    int? capacity,
    int? registered,
  }) =>
      EventData(
        id: id ?? this.id,
        name: name ?? this.name,
        organizer: organizer ?? this.organizer,
        category: category ?? this.category,
        capacity: capacity ?? this.capacity,
        registered: registered ?? this.registered,
      );

  @override
  String toString() {
    return 'EventData - name: $name, organizer: $organizer, category: $category, capacity: $capacity, registerd nr: $registered';
  }
}
