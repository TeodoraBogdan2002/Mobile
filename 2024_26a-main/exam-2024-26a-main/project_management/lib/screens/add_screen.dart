import 'package:project_management/models/project.dart';
import 'package:project_management/widgets/text_box.dart';
import 'package:flutter/material.dart';

import '../widgets/message.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<StatefulWidget> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late TextEditingController nameController;
  late TextEditingController teamController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController membersController;
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    teamController = TextEditingController();
    detailsController = TextEditingController();
    statusController = TextEditingController();
    membersController = TextEditingController();
    typeController = TextEditingController();
  }

  bool isDateValid(String date) {
    // check if date is valid or not
    if (DateTime.tryParse(date) == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Data"),
        ),
        body: ListView(
          children: [
            TextBox(nameController, "Name"),
            TextBox(teamController, "Team"),
            TextBox(detailsController, "Details"),
            TextBox(statusController, "Status"),
            TextBox(membersController, "Members"),
            TextBox(typeController, "Type"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String team = teamController.text;
                  String details = detailsController.text;
                  String status = statusController.text;
                  int? members = int.tryParse(membersController.text);
                  String type = typeController.text;
                  if (name.isNotEmpty &&
                      team.isNotEmpty &&
                      details.isNotEmpty &&
                      status.isNotEmpty &&
                      members != null &&
                      type.isNotEmpty) {
                    Navigator.pop(
                        context,
                        ProjectData(
                            name: name,
                            team: team,
                            details: details,
                            status: status,
                            members: members,
                            type: type));
                  } else {
                    if (name.isEmpty) {
                      message(context, "Name is not valid", "Error");
                    } else if (team.isEmpty) {
                      message(context, "Team is empty", "Error");
                    } else if (details.isEmpty) {
                      message(context, "Details is empty", "Error");
                    } else if (status.isEmpty) {
                      message(context, "Statu is empty", "Error");
                    } else if (members == null) {
                      message(context, "Members is not valid", "Error");
                    } else if (type.isEmpty) {
                      message(context, "Type is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
