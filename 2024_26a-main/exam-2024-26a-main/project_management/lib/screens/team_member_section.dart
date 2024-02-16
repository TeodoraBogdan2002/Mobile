import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:project_management/models/project.dart';
import 'package:project_management/screens/project_details.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class TeamMemberSection extends StatefulWidget {
  @override
  _TeamMemberSectionState createState() => _TeamMemberSectionState();
}

class _TeamMemberSectionState extends State<TeamMemberSection> {
  var logger = Logger();
  bool online = true;
  late List<ProjectData> inprogressProjects = [];
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
      getInProgressProjects();
    });
  }

  getInProgressProjects() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'getInProgressProjects');
    try {
      if (online) {
        inprogressProjects =
            await ApiService.instance.getInProgressProjects();
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error loading items from server", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Price section'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ListView(children: [
                const Text(''),
                ListView.builder(
                      itemBuilder: ((context, index) {
                        return ListTile(
                          title: Text(inprogressProjects[index].id?.toString() ?? 'N/A'),
                          subtitle: Text(
                            'Name: ${inprogressProjects[index].name}, Team: ${inprogressProjects[index].team}, Type: ${inprogressProjects[index].type}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetailsPage(project: inprogressProjects[index]),
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
                      itemCount: inprogressProjects.length,
                      padding: const EdgeInsets.all(10),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                    ),
                
              ])));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
