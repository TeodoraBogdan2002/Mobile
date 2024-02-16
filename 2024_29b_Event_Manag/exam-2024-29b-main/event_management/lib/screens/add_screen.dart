import 'package:event_management/models/project.dart';
import 'package:event_management/widgets/text_box.dart';
import 'package:flutter/material.dart';

import '../widgets/message.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<StatefulWidget> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late TextEditingController nameController;
  late TextEditingController organizerController;
  late TextEditingController categoryController;
  late TextEditingController capacityController;
  late TextEditingController registeredController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    organizerController = TextEditingController();
    categoryController = TextEditingController();
    capacityController = TextEditingController();
    registeredController = TextEditingController();
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
            TextBox(organizerController, "Organizer"),
            TextBox(categoryController, "Category"),
            TextBox(capacityController, "Capacity"),
            TextBox(registeredController, "Registered"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String organizer = organizerController.text;
                  String category = categoryController.text;
                  int? capacity = int.tryParse(capacityController.text);
                  int? registerd = int.tryParse(registeredController.text);
                  if (name.isNotEmpty &&
                      organizer.isNotEmpty &&
                      category.isNotEmpty &&
                      capacity != null &&
                      registerd != null) {
                    Navigator.pop(
                        context,
                        EventData(
                            name: name,
                            organizer: organizer,
                            category: category,
                            capacity: capacity,
                            registered: registerd));
                  } else {
                    if (name.isEmpty) {
                      message(context, "Name is not valid", "Error");
                    } else if (organizer.isEmpty) {
                      message(context, "Organizer is empty", "Error");
                    } else if (category.isEmpty) {
                      message(context, "Category is empty", "Error");
                    } else if (capacity == null) {
                      message(context, "Members is not valid", "Error");
                    } else if (registerd == null) {
                      message(context, "Type is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
