import 'dart:isolate';

class VehicleData {
  int? id;
  String model;
  String status;
  int capacity;
  String owner;
  String manufacturer;
  int cargo;

  VehicleData({
    this.id,
    required this.model,
    required this.status,
    required this.capacity,
    required this.owner,
    required this.manufacturer,
    required this.cargo,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id'] as int?,
      model: json['model'] as String,
      status: json['status'] as String,
      capacity: json['capacity'] as int,
      owner: json['owner'] as String,
      manufacturer: json['manufacturer'] as String,
      cargo: json['cargo'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'status': status,
      'capacity': capacity,
      'owner': owner,
      'manufacturer': manufacturer,
      'cargo' : cargo,
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'model': model,
      'status': status,
      'capacity': capacity,
      'owner': owner,
      'manufacturer':manufacturer,
      'cargo':cargo,
    };
  }

  VehicleData copy({
    int? id,
    String? model,
    String? status,
    int? capacity,
    String? owner,
    String? manufacturer,
    int? cargo,
  }) =>
      VehicleData(
        id: id ?? this.id,
        model: model ?? this.model,
        status: status ?? this.status,
        capacity: capacity ?? this.capacity,
        owner: owner ?? this.owner,
        manufacturer: manufacturer ?? this.manufacturer,
        cargo: cargo?? this.cargo,
      );

  @override
  String toString() {
    return 'Car Data - model: $model, status: $status, capacity: $capacity, owner: $owner, manufacturer: $manufacturer';
  }
}
