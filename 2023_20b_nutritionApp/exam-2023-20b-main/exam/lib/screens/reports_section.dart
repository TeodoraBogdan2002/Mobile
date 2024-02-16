import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:exam/screens/add_data.dart';
import 'package:exam/screens/fitness_data_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class ReportsSection extends StatefulWidget {
  @override
  _ReportsSectionState createState() => _ReportsSectionState();
}

class _ReportsSectionState extends State<ReportsSection> {
  var logger = Logger();
  bool online = true;
  late List<MealData> dates = [];
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
  }

  void connection() {
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      _source = source;
      var newStatus = true;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: online' : 'Mobile: offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'Wifi: online' : 'Wifi: offline';
          newStatus = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          newStatus = false;
      }
      if (online != newStatus) {
        online = newStatus;
      }
      getDates();
    });
  }

  getDates() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        dates = await ApiService.instance.getTop10Meals();
        //await DatabaseHelper.updateMealData(dates);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Error connection, try to open wifi or mobile datas", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }

  void getTotalCaloriesForMeals() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    if (online) {
      try {
        // Call the function to get total calories for each meal
        Map<String, int> totalCalories = await ApiService.instance.getTotalCaloriesForEachMeal();
        
        // Display the result using a dialog or any other UI element
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Total Calories for Each Meal Type'),
              content: Column(
                children: totalCalories.entries.map((entry) {
                  return Text('${entry.key}: ${entry.value} calories');
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Error connection, try to open wifi or mobile datas", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record section'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  ListView.builder(
                      itemBuilder: ((context, index) {
                        return ListTile(
                          title: Text(dates[index].id?.toString() ?? 'N/A'),
                          subtitle: Text(
                            'Name: ${dates[index].name}, Type: ${dates[index].type}, Calories: ${dates[index].calories}, Date: ${dates[index].date}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                            },
                            color: Colors.red,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        );
                      }),
                      itemCount: dates.length,
                      padding: const EdgeInsets.all(10),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                    ),
                    ElevatedButton(
                    onPressed: () {
                      // Call the function to get total calories for each meal
                      getTotalCaloriesForMeals();
                    },
                    child: const Text('Get Total Calories'),
                  ),
                
                ],
              )),
              
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
