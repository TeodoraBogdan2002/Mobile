import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_management/models/project.dart';
import 'package:project_management/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_management/screens/project_details.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class MainSection extends StatefulWidget {
  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  var logger = Logger();
  bool online = true;
  late List<ProjectData> dates = [];
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
        dates = await ApiService.instance.getProjects();
        await DatabaseHelper.updateProjectData(dates);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      dates = await DatabaseHelper.getProjects();
    }

    setState(() {
      isLoading = false;
    });
  }

  saveFitnessData(ProjectData fitnessData) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        final ProjectData received =
            await ApiService.instance.addProjectData(fitnessData);
        DatabaseHelper.addProjectData(received);
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
        title: const Text('Main section'),
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
                            'Name: ${dates[index].name}, Team: ${dates[index].team}, Type: ${dates[index].type}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetailsPage(project: dates[index]),
                                ),
                              );
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

                ],
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!online) {
            message(context, "Operation not available", "Error");
            return;
          }
          Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => AddData())))
              .then((value) {
            if (value != null) {
              setState(() {
                saveFitnessData(value);
              });
            }
          });
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
