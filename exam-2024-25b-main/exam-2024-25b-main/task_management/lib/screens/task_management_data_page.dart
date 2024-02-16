import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_management/models/task_management_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class TaskDataPage extends StatefulWidget {
  final String _date;
  const TaskDataPage(this._date, {super.key});

  @override
  State<StatefulWidget> createState() => _TaskDataPageState();
}

class _TaskDataPageState extends State<TaskDataPage> {
  var logger = Logger();
  bool online = true;
  late List<TaskManagementData> data = [];
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
      getDataByDate();
    });
  }

  getDataByDate() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, "Online - $online");
    try {
      if (online) {
        data = await ApiService.instance.getTaskDataByDate(widget._date);
        await DatabaseHelper.updateTMDataForDate(widget._date, data);
      } else {
        data = await DatabaseHelper.getTaskDataByDate(widget._date);
      }
    } catch (e) {
      logger.e(e);
      // ignore: use_build_context_synchronously
      message(context, "Error when retreiving data from server", "Error");
      data = await DatabaseHelper.getTaskDataByDate(widget._date);
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteData(TaskManagementData taskData) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (online) {
        setState(() {
          ApiService.instance.deleteTaskData(taskData.id!);
          DatabaseHelper.deleteTaskData(taskData.id!);
          data.remove(taskData);
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
                    deleteData(data.firstWhere((element) => element.id == id));
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
        title: Text(widget._date),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ListView(
              children: [
                ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(data[index].type),
                      subtitle: Text(
                          'Category: ${data[index].category}, Type: ${data[index].type}, Priority: ${data[index].priority}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          removeData(context, data[index].id!);
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
                  itemCount: data.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                ),
              ],
            )),
    );
  }
}
