import 'package:dio/dio.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2320';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<MealData>> getMeals() async {
    logger.log(Level.info, "getMeals() called");
    final response = await dio.get('$baseUrl/all');
    logger.log(Level.info, "getMeals() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => MealData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getMeals() error: ${response.statusMessage}");
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

  Future<List<MealData>> getMealDataByType(String type) async {
    logger.log(Level.info, "getMealDataByType() called");
    final response = await dio.get('$baseUrl/meals/$type');
    logger.log(Level.info, "getMealDataByType() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => MealData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error,
          "getMealDataByType() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<MealData> addMealData(MealData fitnessData) async {
    logger.log(Level.info, "addMealData() called");
    final response =
        await dio.post('$baseUrl/meal', data: fitnessData.toJsonWithoutId());
    logger.log(Level.info, "addMealData() response: $response");
    if (response.statusCode == 200) {
      return MealData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addMealData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  void deleteMealData(int id) async {
    logger.log(Level.info, "deleteMealData() called");
    final response = await dio.delete('$baseUrl/meal/$id');
    logger.log(Level.info, "deleteMealData() response: $response");
    if (response.statusCode != 200) {
      logger.log(
          Level.error, "deleteMealData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<MealData>> getTop10Meals() async {
    logger.log(Level.info, "getTop10Meals() called");
    final response = await dio.get('$baseUrl/all');
    logger.log(Level.info, "getTop10Meals() response: $response");
    
    if (response.statusCode == 200) {
      final List<dynamic> rawMeals = response.data;
      
      // Assuming MealData has a 'calories' property
      List<MealData> meals = rawMeals.map((e) => MealData.fromJson(e)).toList();

      // Sort meals based on calories in descending order
      meals.sort((a, b) => b.calories.compareTo(a.calories));

      // Take the top 10 meals
      List<MealData> top10Meals = meals.take(10).toList();

      return top10Meals;
    } else {
      logger.log(Level.error, "getTop10Meals() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<Map<String, int>> getTotalCaloriesForEachMeal() async {
    logger.log(Level.info, "getTotalCaloriesForEachMeal() called");
    final response = await dio.get('$baseUrl/all');
    logger.log(Level.info, "getTotalCaloriesForEachMeal() response: $response");

    if (response.statusCode == 200) {
      final List<dynamic> rawMeals = response.data;

      // Assuming MealData has a 'calories' property and a 'name' property
      Map<String, int> totalCaloriesMap = {};

      for (dynamic rawMeal in rawMeals) {
        MealData meal = MealData.fromJson(rawMeal);
        if (meal.calories != null && meal.type != null) {
          // If meal name is not null, add or update the total calories
          totalCaloriesMap.update(
            meal.type,
            (existingTotalCalories) => existingTotalCalories + meal.calories,
            ifAbsent: () => meal.calories,
          );
        }
      }

      return totalCaloriesMap;
    } else {
      logger.log(
          Level.error, "getTotalCaloriesForEachMeal() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }


}
