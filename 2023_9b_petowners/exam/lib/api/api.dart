import 'package:dio/dio.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2309';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<PetData>> getPets() async {
    logger.log(Level.info, "getPets() called");
    final response = await dio.get('$baseUrl/pets');
    logger.log(Level.info, "getPets() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => PetData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getPets() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<PetData> getPetById(int id) async {
  final String apiUrl = '$baseUrl/pet/$id';

  try {
    final response = await Dio().get(apiUrl);
    
    if (response.statusCode == 200) {
      return PetData.fromJson(response.data);
    } else {
      // Handle error response
      throw Exception('Failed to load pet with id: $id. Status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle Dio errors
    throw Exception('Error fetching data: $e');
  }
}

  Future<PetData> addPetData(PetData fitnessData) async {
    logger.log(Level.info, "addPetData() called");
    final response =
        await dio.post('$baseUrl/pet', data: fitnessData.toJsonWithoutId());
    logger.log(Level.info, "addPetData() response: $response");
    if (response.statusCode == 200) {
      return PetData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addPetData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  void deletePetData(int id) async {
    logger.log(Level.info, "deletePetData() called");
    final response = await dio.delete('$baseUrl/pet/$id');
    logger.log(Level.info, "deletePetData() response: $response");
    if (response.statusCode != 200) {
      logger.log(
          Level.error, "deletePetData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }


}
