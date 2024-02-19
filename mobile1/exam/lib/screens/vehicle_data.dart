import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class VehicleDataPage extends StatefulWidget {
  final String _date;
  const VehicleDataPage(this._date, {super.key});

  @override
  State<StatefulWidget> createState() => _VehicleDataPageState();
}

class _VehicleDataPageState extends State<VehicleDataPage> {
  var logger = Logger();
  bool online = true;
  late List<VehicleData> data = [];
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
        data = await ApiService.instance.getCarDataByType(widget._date);
        //await DatabaseHelper.updateManufacturers(widget._date, data);
      } else {
        data = await DatabaseHelper.getVehicleDataByManufacturer(widget._date);
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retreiving data from server", "Error");
      data = await DatabaseHelper.getVehicleDataByManufacturer(widget._date);
    }
    setState(() {
      isLoading = false;
    });
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
                      title: Text(data[index].model),
                      subtitle: Text(
                          'Status: ${data[index].status}, Capacity: ${data[index].capacity}, Owner: ${data[index].owner}, Manufacturer: ${data[index].manufacturer}, Cargo: ${data[index].cargo}'),
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
