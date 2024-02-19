import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:exam/screens/add_data.dart';
import 'package:exam/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class RegistrationSection extends StatefulWidget {
  @override
  _RegistrationSectionState createState() => _RegistrationSectionState();
}

class _RegistrationSectionState extends State<RegistrationSection> {
  var logger = Logger();
  bool online = true;
  late List<VehicleData> dates = [];
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
        dates = await ApiService.instance.getVehicles();
        //await DatabaseHelper.updateCarData(dates);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      dates = await DatabaseHelper.getVehicles();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveVehicleData(VehicleData mealData) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        final VehicleData received =
            await ApiService.instance.addCarData(mealData);
        DatabaseHelper.addVehicleData(received);
       // Navigator.pop(context, received); 
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      DatabaseHelper.addVehicleData(mealData);
    }
    setState(() {
      isLoading = false;
    });
  }

    void deleteData(VehicleData vehicleData) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (online) {
        setState(() {
          ApiService.instance.deleteCarData(vehicleData.id!);
          DatabaseHelper.deleteCarData(vehicleData.id!);
          dates.remove(vehicleData);
          Navigator.pop(context);
        });
      } else {
        message(context, "Operation not available", "Info");
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when deleting data from server", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  removeData(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("Delete Data"),
              content: const Text("Are you sure you want to delete this data?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    deleteData(dates.firstWhere((element) => element.id == id));
                  },
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration section'),
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
                            'TYPE: Name: ${dates[index].model}, Date: ${dates[index].status}, Type: ${dates[index].cargo}, Status: ${dates[index].owner}',
                          ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActivityDataPage(dates[index].id ?? 0),
                                      ),
                                    );
                                  },
                                  color: Colors.red,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    removeData(context, dates[index].id!);
                                  },
                                  color: Colors.red,
                                ),
                              ],
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

                ],
              )),
              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final value = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddData()),
                              );
                    // Navigator.push(
                    //         context, MaterialPageRoute(builder: ((context) => const AddData())))
                    //     .then((value) {
                      if (value != null) {
                        setState(() {
                          saveVehicleData(value);
                        });
                      }
                  },
                  tooltip: 'Add data',
                  child: const Icon(Icons.add),
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}