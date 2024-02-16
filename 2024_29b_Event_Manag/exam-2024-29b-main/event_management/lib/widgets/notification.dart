import 'dart:convert';

import 'package:event_management/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'message.dart';

class DataNotification extends StatelessWidget {
  final channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:2429'));

  DataNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        builder: (context, snapshot) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasData) {
              var data =
                  EventData.fromJson(jsonDecode(snapshot.data.toString()));
              message(context, data.toString(), "Data added");
            }
          });
          return const Text('');
        },
        stream: channel.stream.asBroadcastStream());
  }
}
