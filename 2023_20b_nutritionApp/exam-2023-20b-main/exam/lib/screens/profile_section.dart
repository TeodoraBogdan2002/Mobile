import 'package:exam/api/network.dart';
import 'package:exam/models/user_data.dart';
import 'package:exam/screens/add_user_page.dart';
import 'package:exam/widgets/message.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/models/fitness_data.dart';
import 'package:logger/logger.dart';

class ProfileSection extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {

  var logger = Logger();
  bool online = true;
  late List<UserData> dates = [];
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
        dates = await DatabaseHelper.getUsers();
        //await DatabaseHelper.updateMealData(dates);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      dates = await DatabaseHelper.getUsers();
    }

    setState(() {
      isLoading = false;
    });
  }


  Future<void> saveMealData(UserData mealData) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    
      DatabaseHelper.addUserData(mealData);
    
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
                          title: Text(dates[index].name),
                          subtitle: Text(
                            'Age: ${dates[index].age}, Height: ${dates[index].height}',
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
                    
                
                ],
              )),
              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    final value = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddUserPage()),
                              );
                    // Navigator.push(
                    //         context, MaterialPageRoute(builder: ((context) => const AddData())))
                    //     .then((value) {
                      if (value != null) {
                        setState(() {
                          saveMealData(value);
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
