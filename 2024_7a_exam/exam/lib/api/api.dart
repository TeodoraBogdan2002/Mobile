import 'package:dio/dio.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2407';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<ActivityData>> getActivities() async {
    logger.log(Level.info, "getActivities() called");
    final response = await dio.get('$baseUrl/activities');
    logger.log(Level.info, "getActivities() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => ActivityData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getActivities() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<String>> getTypes() async {
    logger.log(Level.info, "getTypes() called");
    final response = await dio.get('$baseUrl/types');
    logger.log(Level.info, "getTypes() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => e as String).toList();
    } else {
      logger.log(Level.error, "getTypes() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<ActivityData>> getMealDataByType(String type) async {
    logger.log(Level.info, "getMealDataByType() called");
    final response = await dio.get('$baseUrl/meals/$type');
    logger.log(Level.info, "getMealDataByType() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => ActivityData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error,
          "getMealDataByType() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<ActivityData> addActivityData(ActivityData fitnessData) async {
    logger.log(Level.info, "addActivityData() called");
    final response =
        await dio.post('$baseUrl/activity', data: fitnessData.toJsonWithoutId());
    logger.log(Level.info, "addActivityData() response: $response");
    if (response.statusCode == 200) {
      return ActivityData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addActivityData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  void deleteActivityData(int id) async {
    logger.log(Level.info, "deleteActivityData() called");
    final response = await dio.delete('$baseUrl/meal/$id');
    logger.log(Level.info, "deleteActivityData() response: $response");
    if (response.statusCode != 200) {
      logger.log(
          Level.error, "deleteActivityData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<ActivityData> getActivityById(int id) async {
  final String apiUrl = '$baseUrl/activity/$id';

  try {
    final response = await Dio().get(apiUrl);
    
    if (response.statusCode == 200) {
      return ActivityData.fromJson(response.data);
    } else {
      // Handle error response
      throw Exception('Failed to load activity with id: $id. Status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle Dio errors
    throw Exception('Error fetching data: $e');
  }
}

Future<List<ActivityData>> getActivitiesSortedByMonth() async {
  logger.log(Level.info, "getActivitiesSortedByMonth() called");
  final response = await dio.get('$baseUrl/participation');
  logger.log(Level.info, "getActivitiesSortedByMonth() response: $response");

  if (response.statusCode == 200) {
    final List<dynamic> rawActivities = response.data;

    // Assuming ActivityData has a 'date' property representing the month
    List<ActivityData> activities = rawActivities
        .map((e) => ActivityData.fromJson(e))
        .toList();

    // Sort activities based on the month in descending order
    activities.sort((a, b) => b.date.compareTo(a.date));

    return activities;
  } else {
    logger.log(
        Level.error, "getActivitiesSortedByMonth() error: ${response.statusMessage}");
    throw Exception(response.statusMessage);
  }
}
Future<Map<String, int>> getSumParticipantsPerMonth() async {
  logger.log(Level.info, "getSumParticipantsPerMonth() called");
  final response = await dio.get('$baseUrl/participation');
  logger.log(Level.info, "getSumParticipantsPerMonth() response: $response");

  if (response.statusCode == 200) {
    final List<dynamic> rawActivities = response.data;

    // Assuming ActivityData has a 'date' property and 'participants' property
    Map<String, int> sumParticipantsMap = {};

    for (dynamic rawActivity in rawActivities) {
      ActivityData activity = ActivityData.fromJson(rawActivity);
      if (activity.date != null && activity.participants != null) {
        // If activity date and participants are not null, add or update the sum of participants
        sumParticipantsMap.update(
          activity.date,
          (existingSum) => existingSum + activity.participants,
          ifAbsent: () => activity.participants,
        );
      }
    }

    return sumParticipantsMap;
  } else {
    logger.log(
        Level.error, "getSumParticipantsPerMonth() error: ${response.statusMessage}");
    throw Exception(response.statusMessage);
  }
}

Future<ActivityData> registerActivity(String type) async {
    logger.log(Level.info, "registerActivity() called");
    final response = await dio.put('$baseUrl/register/$type');
    logger.log(Level.info, "registerActivity() response: $response");

    if (response.statusCode == 200) {
      // Assuming the response body is a JSON representing the updated activity
      return ActivityData.fromJson(response.data);
    } else {
      logger.log(Level.error, "registerActivity() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  

}
