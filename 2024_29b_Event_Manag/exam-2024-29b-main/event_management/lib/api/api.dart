import 'package:dio/dio.dart';
import 'package:event_management/models/project.dart';
import 'package:logger/logger.dart';

const String baseUrl = 'http://10.0.2.2:2429';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<EventData>> getEvents() async {
    logger.log(Level.info, "getEvents() called");
    final response = await dio.get('$baseUrl/events');
    logger.log(Level.info, "getEvents() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => EventData.fromJson(e))
          .toList();
    } else {
      logger.log(Level.error, "getEvents() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<List<EventData>> getSortedEvents() async {
  logger.log(Level.info, "getSortedEvents() called");
  final response = await dio.get('$baseUrl/events');
  logger.log(Level.info, "getSortedEvents() response: $response");
  if (response.statusCode == 200) {
    List<EventData> events = (response.data as List).map((e) => EventData.fromJson(e)).toList();

    // Sort events by category in ascending order
    events.sort((a, b) => a.category.compareTo(b.category));

    // Sort events by capacity in ascending order
    events.sort((a, b) => a.capacity.compareTo(b.capacity));

    return events;
  } else {
    logger.log(Level.error, "getSortedEvents() error: ${response.statusMessage}");
    throw Exception(response.statusMessage);
  }
}

Future<void> reserveEventSpot(int eventId) async {
  logger.log(Level.info, "reserveEventSpot() called for event ID: $eventId");

  // Assuming you have a proper endpoint for the reserve operation
  final response = await dio.put('$baseUrl/reserve/$eventId');
  logger.log(Level.info, "reserveEventSpot() response: $response");

  if (response.statusCode == 200) {
    // Spot reserved successfully
    logger.log(Level.info, "Event with ID $eventId reserved successfully");
  } else {
    logger.log(Level.error, "reserveEventSpot() error: ${response.statusMessage}");
    throw Exception(response.statusMessage);
  }
}

  Future<List<EventData>> getReservedEvents() async {
    logger.log(Level.info, "getReservedEvents() called");
    final response = await dio.get('$baseUrl/reserved');
    logger.log(Level.info, "getReservedEvents() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => EventData.fromJson(e)).toList();
    } else {
      logger.log(Level.error, "getReservedEvents() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  Future<EventData> addEventData(EventData eventData) async {
    logger.log(Level.info, "addEventData() called");
    final response =
        await dio.post('$baseUrl/event', data: eventData.toJsonWithoutId());
    logger.log(Level.info, "addEventData() response: $response");
    if (response.statusCode == 200) {
      return EventData.fromJson(response.data);
    } else {
      logger.log(
          Level.error, "addEventData() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  // Future<List<EventData>> getInProgressProjects() async {
  //   logger.log(Level.info, "getInProgressProjects() called");
  //   final response = await dio.get('$baseUrl/projects');
  //   logger.log(Level.info, "getInProgressProjects() response: $response");
  //   if (response.statusCode == 200) {
  //     final List<ProjectData> allProjects = (response.data as List)
  //         .map((e) => ProjectData.fromJson(e))
  //         .toList();
  //     // Filter projects with status "in progress"
  //     final List<ProjectData> inProgressProjects =
  //         allProjects.where((project) => project.status == "in progress").toList();

  //     return inProgressProjects;
  //   } else {
  //     logger.log(Level.error, "getInProgressProjects() error: ${response.statusMessage}");
  //     throw Exception(response.statusMessage);
  //   }
  // }
}
