// reserved_events_page.dart

import 'package:event_management/models/project.dart';
import 'package:flutter/material.dart';

class ReservedEventsPage extends StatelessWidget {
  final List<EventData> reservedEvents;

  ReservedEventsPage({required this.reservedEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserved Events'),
      ),
      body: ListView(
        children: reservedEvents.map((event) {
          return ListTile(
            title: Text(event.id?.toString() ?? 'N/A'),
            subtitle: Text(
              'Name: ${event.name}, Organizer: ${event.organizer}, Category: ${event.category}, Registered: ${event.registered}',
            ),
          );
        }).toList(),
      ),
    );
  }
}