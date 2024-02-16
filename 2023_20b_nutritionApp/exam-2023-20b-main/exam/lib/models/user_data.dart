class UserData {
  int? id;
  String name;
  int age;
  int height;

  UserData({
    this.id,
    required this.name,
    required this.age,
    required this.height,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int?,
      name: json['name'] as String,
      age: json['age'] as int,
      height: json['height'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'age': age,
      'height': height,
    };
  }

  UserData copy({
    int? id,
    String? name,
    int? age,
    int? height,
  }) =>
      UserData(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        height: height ?? this.height,
      );

  @override
  String toString() {
    return 'Meal Data - name: $name, age: $age, height: $height';
  }
}
