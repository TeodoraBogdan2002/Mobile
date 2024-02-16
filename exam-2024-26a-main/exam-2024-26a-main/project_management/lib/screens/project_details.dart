import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectDetailsPage extends StatelessWidget {
  final ProjectData project;

  ProjectDetailsPage({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${project.name}'),
            Text('Team: ${project.team}'),
            Text('Details: ${project.details}'),
            Text('Status: ${project.status}'),
            Text('Members: ${project.members}'),
            Text('Type: ${project.type}'),
            // Add more details if needed
          ],
        ),
      ),
    );
  }
}