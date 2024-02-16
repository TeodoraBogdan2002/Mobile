import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../api/network.dart';
import '../services/database_helper.dart';
import '../widgets/message.dart';

class PetDataPage extends StatefulWidget {
  final int _type;
  const PetDataPage(this._type, {super.key});

  @override
  State<StatefulWidget> createState() => _PetDataPageState();
}

class _PetDataPageState extends State<PetDataPage> {
  var logger = Logger();
  bool online = true;
  late List<PetData> pets;
  late PetData data;  // Change the type to PetData
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
        data = await ApiService.instance.getPetById(widget._type);
        pets = await ApiService.instance.getPets();
        //await DatabaseHelper.updateMealDataForType(widget._type, data);
      } else {
        data = await DatabaseHelper.getPetDataById(widget._type);
        pets = await DatabaseHelper.getPets();
        message(context, "Operation not available", "Error");
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retrieving data from the server", "Error");
      data = await DatabaseHelper.getPetDataById(widget._type);
    }
    setState(() {
      isLoading = false;
    });
  }

void deleteData(PetData petData) async {
  if (!mounted) return;
  setState(() {
    isLoading = true;
  });
  try {
    if (online) {
      setState(() {
        ApiService.instance.deletePetData(petData.id!);
        DatabaseHelper.deletePetData(petData.id!);
        pets.remove(petData);
        Navigator.popUntil(context, (route) => route.isFirst); // Pop the current page
      });
    } else {
      message(context, "Operation not available", "Info");
    }
  } catch (e) {
    logger.e(e);
    message(context, "Error when deleting data from the server", "Error");
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
              deleteData(data);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      )),
    );
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
                title: Text(data.name),
                subtitle: Text(
                  'Breed: ${data.breed}, Age: ${data.age}, Owner: ${data.owner}, Location: ${data.location}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),

                  onPressed: () {
                    if(online)
                    {
                      removeData(context, data.id!);
                    }
                    else{
                      message(context, "Operation not available", "Info");
                    }
                    
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
              ),
            ),
    );
  }
}

