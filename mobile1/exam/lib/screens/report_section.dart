import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:exam/screens/add_data.dart';
import 'package:exam/screens/details_page.dart';
import 'package:exam/screens/vehicle_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class ReportSection extends StatefulWidget {
  @override
  _ReportSectionState createState() => _ReportSectionState();
}

class _ReportSectionState extends State<ReportSection> {
  var logger = Logger();
  bool online = true;
  late List<String> dates = [];
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

  Future<List<VehicleData>> getTop10Vehicles() async {
  if (!mounted) return [];
  setState(() {
    isLoading = true;
  });
  if (online) {
    try {
      // Use the new function to get the top 10 vehicles by capacity
      List<VehicleData> topVehicles = await ApiService.instance.getTop10VehiclesByCapacity();

      // Update the list of dates with the top 10 vehicles' names
      // dates = topVehicles.map((vehicle) => vehicle.name).toList();
      
      return topVehicles; // Return the top vehicles
    } catch (e) {
      logger.e(e);
      message(context, "Error connecting to the server", "Error");
    }
  } else {
    message(context, "Operation not available", "Error");
  }

  setState(() {
    isLoading = false;
  });

  return []; // Return an empty list in case of an error or offline
}


  getDates() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        dates = await ApiService.instance.getManufacturers();
        DatabaseHelper.updateManufacturers(dates);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Operation not available", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report section'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  ListView.builder(
                    itemBuilder: ((context, index) {
                      return Card(
                          color: Colors.white,
                          shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: ListTile(
                            title: Text(dates[index]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleDataPage(dates[index])));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ));
                    }),
                    itemCount: dates.length,
                    padding: const EdgeInsets.all(10),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  ),
                  // Section for displaying top 10 vehicles
                const SizedBox(height: 20),
                const Text(
                  'Top 10 Vehicles:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<VehicleData>>(
                  future: getTop10Vehicles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No data available.');
                    } else {
                      // Display the top 10 vehicles
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            // Customize the Card widget for top vehicles as needed
                            child: ListTile(
                              title: Text(snapshot.data![index].manufacturer),
                              // Add other details as needed
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.all(10),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                      );
                    }
                  },
                ),
              
                ],
              )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (!online) {
      //       message(context, "Operation not available", "Error");
      //       return;
      //     }
      //     Navigator.push(
      //             context, MaterialPageRoute(builder: ((context) => AddData())))
      //         .then((value) {
      //       if (value != null) {
      //         setState(() {
      //           saveFitnessData(value);
      //         });
      //       }
      //     });
      //   },
      //   tooltip: 'Add data',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
