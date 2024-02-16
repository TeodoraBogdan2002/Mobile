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
  late List<ActivityData> dates = [];
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';
  late Map<String, int> sumParticipantsPerMonth = {};

  @override
  void initState() {
    super.initState();
    connection();
    getSumParticipantsPerMonth();
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
        dates = await ApiService.instance.getActivitiesSortedByMonth();
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

   void getSumParticipantsPerMonth() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    if (online) {
      try {
        // Call the function to get the sum of participants per month
        sumParticipantsPerMonth = await ApiService.instance.getSumParticipantsPerMonth();
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Error connection, try to open wifi or mobile data", "Error");
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
                            'TYPE: ${dates[index].type}, Name: ${dates[index].name}, Date: ${dates[index].date}, Participants: ${dates[index].participants}',
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
                      // getTotalCaloriesForMeals();
                    },
                    child: const Text(''),
                  ),
                 // Display the result of sumParticipantsPerMonth
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sumParticipantsPerMonth.entries.map((entry) {
                        return Text('${entry.key}: ${entry.value} participants');
                      }).toList(),
                    ),
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
