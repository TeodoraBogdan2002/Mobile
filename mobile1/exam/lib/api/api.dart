import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2419';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<VehicleData>> getVehicles() async {
    logger.log(Level.info, "getVehicles() called");
    final response = await dio.get('$baseUrl/all');
    logger.log(Level.info, "getVehicles() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => VehicleData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getVehicles() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<String>> getManufacturers() async {
    logger.log(Level.info, "getManufacturers() called");
    final response = await dio.get('$baseUrl/types');
    logger.log(Level.info, "getManufacturers() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => e as String).toList();
    } else {
      logger.log(Level.error, "getManufacturers() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<VehicleData>> getCarDataByType(String type) async {
    logger.log(Level.info, "getCarDataByType() called");
    final response = await dio.get('$baseUrl/vehicles/$type');
    logger.log(Level.info, "getCarDataByType() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => VehicleData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error,
          "getCarDataByType() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<VehicleData> addCarData(VehicleData fitnessData) async {
    logger.log(Level.info, "addCarData() called");
    final response =
        await dio.post('$baseUrl/vehicle', data: fitnessData.toJsonWithoutId());
    logger.log(Level.info, "addCarData() response: $response");
    if (response.statusCode == 200) {
      return VehicleData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addCarData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  void deleteCarData(int id) async {
    logger.log(Level.info, "deleteCarData() called");
    final response = await dio.delete('$baseUrl/vehicle/$id');
    logger.log(Level.info, "deleteCarData() response: $response");
    if (response.statusCode != 200) {
      logger.log(
          Level.error, "deleteCarData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<VehicleData> getCarById(int id) async {
  final String apiUrl = '$baseUrl/vehicle/$id';

  try {
    final response = await Dio().get(apiUrl);
    
    if (response.statusCode == 200) {
      return VehicleData.fromJson(response.data);
    } else {
      // Handle error response
      throw Exception('Failed to load activity with id: $id. Status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle Dio errors
    throw Exception('Error fetching data: $e');
  }
}

Future<List<VehicleData>> getTop10VehiclesByCapacity() async {
  try {
    logger.log(Level.info, "getTop10VehiclesByCapacity() called");
    
    final response = await dio.get('$baseUrl/all');
    logger.log(Level.info, "getTop10VehiclesByCapacity() response: $response");

    if (response.statusCode == 200) {
      // Convert response data to List<VehicleData>
      List<VehicleData> allVehicles = (response.data as List)
          .map((e) => VehicleData.fromJson(e))
          .toList();

      // Sort the vehicles by capacity in descending order
      allVehicles.sort((a, b) => b.capacity.compareTo(a.capacity));

      // Return only the top 10 vehicles
      return UnmodifiableListView(allVehicles.take(10).toList());
    } else {
      logger.log(Level.error, "getTop10VehiclesByCapacity() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  } catch (e) {
    logger.log(Level.error, "Error in getTop10VehiclesByCapacity(): $e");
    rethrow;
  }
}

// Future<List<VehicleData>> getActivitiesSortedByMonth() async {
//   logger.log(Level.info, "getActivitiesSortedByMonth() called");
//   final response = await dio.get('$baseUrl/participation');
//   logger.log(Level.info, "getActivitiesSortedByMonth() response: $response");

//   if (response.statusCode == 200) {
//     final List<dynamic> rawActivities = response.data;

//     // Assuming ActivityData has a 'date' property representing the month
//     List<VehicleData> activities = rawActivities
//         .map((e) => VehicleData.fromJson(e))
//         .toList();

//     // Sort activities based on the month in descending order
//     activities.sort((a, b) => b.status.compareTo(a.status));

//     return activities;
//   } else {
//     logger.log(
//         Level.error, "getActivitiesSortedByMonth() error: ${response.statusMessage}");
//     throw Exception(response.statusMessage);
//   }
// }
// Future<Map<String, int>> getSumParticipantsPerMonth() async {
//   logger.log(Level.info, "getSumParticipantsPerMonth() called");
//   final response = await dio.get('$baseUrl/participation');
//   logger.log(Level.info, "getSumParticipantsPerMonth() response: $response");

//   if (response.statusCode == 200) {
//     final List<dynamic> rawActivities = response.data;

//     // Assuming ActivityData has a 'date' property and 'participants' property
//     Map<String, int> sumParticipantsMap = {};

//     for (dynamic rawActivity in rawActivities) {
//       VehicleData activity = VehicleData.fromJson(rawActivity);
//       if (activity.status != null && activity.manufacturer != null) {
//         // If activity date and participants are not null, add or update the sum of participants
//         sumParticipantsMap.update(
//           activity.status,
//           (existingSum) => existingSum + activity.manufacturer,
//           ifAbsent: () => activity.manufacturer,
//         );
//       }
//     }

//     return sumParticipantsMap;
//   } else {
//     logger.log(
//         Level.error, "getSumParticipantsPerMonth() error: ${response.statusMessage}");
//     throw Exception(response.statusMessage);
//   }
// }

// Future<VehicleData> registerActivity(String type) async {
//     logger.log(Level.info, "registerActivity() called");
//     final response = await dio.put('$baseUrl/register/$type');
//     logger.log(Level.info, "registerActivity() response: $response");

//     if (response.statusCode == 200) {
//       // Assuming the response body is a JSON representing the updated activity
//       return VehicleData.fromJson(response.data);
//     } else {
//       logger.log(Level.error, "registerActivity() error: ${response.statusMessage}");
//       throw Exception(response.statusMessage);
//     }
//   }

  

}
