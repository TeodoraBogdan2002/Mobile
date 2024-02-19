import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class ActivityDataPage extends StatefulWidget {
  final int _type;
  const ActivityDataPage(this._type, {super.key});

  @override
  State<StatefulWidget> createState() => _ActivityDataPageState();
}

class _ActivityDataPageState extends State<ActivityDataPage> {
  var logger = Logger();
  bool online = true;
  late VehicleData data;  // Change the type to PetData
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
    data = VehicleData(id: 0,
  model: '',
  status: '',
  capacity: 0,
  owner: '',
  manufacturer: '',
  cargo: 0,);
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
        data = await ApiService.instance.getCarById(widget._type);
        //await DatabaseHelper.updateMealDataForType(widget._type, data);
      } else {
        data = await DatabaseHelper.getCarDataById(widget._type);
        message(context, "Operation not available", "Error");
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retrieving data from the server", "Error");
      data = await DatabaseHelper.getCarDataById(widget._type);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._type.toString()),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ListTile(
                title: Text(data.model),
                subtitle: Text(
                  'Date: ${data.status}, Details: ${data.capacity}, Status: ${data.owner}, Participants: ${data.manufacturer}, Type: ${data.cargo}',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
    );
  }
}
