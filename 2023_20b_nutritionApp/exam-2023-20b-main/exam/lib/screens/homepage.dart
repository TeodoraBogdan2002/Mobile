import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam/screens/profile_section.dart';
import 'package:exam/screens/record_section.dart';
import 'package:exam/screens/reports_section.dart';
import 'package:exam/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/network.dart';
import '../widgets/message.dart';
import 'manage_section.dart';

class Homepage extends StatefulWidget {
  final String _title;
  const Homepage(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:2320'));
  var logger = Logger();
  bool online = true;
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
      logger.log(Level.info, _source);
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
      logger.log(Level.info, "Connection status: $online, $newStatus");
      if (online != newStatus) {
        online = newStatus;
        if (newStatus) {
          message(context, "Connection restored", "Info");
        } else {
          message(context, "Connection lost", "Info");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RecordSection()));
                },
                child: const Text('Record section')),
            ElevatedButton(
                onPressed: () {
                  if (!online) {
                    message(context, "No internet connection", "Info");
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageSection()));
                },
                child: const Text('Manage section')),
                ElevatedButton(
                onPressed: () {
                  if (!online) {
                    message(context, "No internet connection", "Info");
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportsSection()));
                },
                child: const Text('Reports section')),
                 ElevatedButton(
              onPressed: () {
                if (!online) {
                  message(context, "No internet connection", "Info");
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSection()), // Navigate to Profile Section
                );
              },
              child: const Text('Profile section'),
            ),
            online ? DataNotification() : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}
