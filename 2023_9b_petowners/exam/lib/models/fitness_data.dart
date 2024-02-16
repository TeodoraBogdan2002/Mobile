class PetData {
  int? id;
  String name;
  String breed;
  int age;
  int weight;
  String owner;
  String location;
  String description;

  PetData({
    this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.owner,
    required this.location,
    required this.description,
  });

  // factory PetData.fromJson(Map<String, dynamic> json) {
  //   return PetData(
  //     id: json['id'] as int?,
  //     name: json['name'] as String,
  //     breed: json['breed'] as String,
  //     age: json['age'] as int,
  //     weight: json['weight'] as int,
  //     owner: json['owner'] as String,
  //     location: json['location'] as String,
  //     description: json['description'] as String,
  //   );
  // }
  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '', // Use the empty string as a default if 'name' is null
      breed: json['breed'] as String? ?? '',
      age: json['age'] as int? ?? 0, // Use 0 as a default if 'age' is null
      weight: json['weight'] as int? ?? 0,
      owner: json['owner'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'weight': weight,
      'owner': owner,
      'location': location,
      'description': description,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'breed': breed,
      'age': age,
      'weight': weight,
      'owner': owner,
      'location': location,
      'description': description,
    };
  }

  PetData copy({
    int? id,
    String? name,
    String? breed,
    int? age,
    int? weight,
    String? owner,
    String? location,
    String? description
  }) =>
      PetData(
        id: id ?? this.id,
        name: name ?? this.name,
        breed: breed ?? this.breed,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        owner: owner ?? this.owner,
        location: location ?? this.location,
        description: description ?? this.description,
      );

  @override
  String toString() {
    return 'Pet Data - name: $name, breed: $breed, age: $age, owner: $owner, location: $location';
  }
}
