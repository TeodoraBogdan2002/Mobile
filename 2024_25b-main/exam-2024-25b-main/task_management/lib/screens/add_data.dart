import 'package:task_management/models/task_management_data.dart';
import 'package:task_management/widgets/text_box.dart';
import 'package:flutter/material.dart';

import '../widgets/message.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<StatefulWidget> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late TextEditingController dateController;
  late TextEditingController typeController;
  late TextEditingController durationController;
  late TextEditingController priorityController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    typeController = TextEditingController();
    durationController = TextEditingController();
    priorityController = TextEditingController();
    categoryController = TextEditingController();
    descriptionController = TextEditingController();
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
            TextBox(dateController, "Date"),
            TextBox(typeController, "Type"),
            TextBox(durationController, "Duration"),
            TextBox(priorityController, "Priority"),
            TextBox(categoryController, "Category"),
            TextBox(descriptionController, "Description"),
            ElevatedButton(
                onPressed: () {
                  String date = dateController.text;
                  String type = typeController.text;
                  double? duration = double.tryParse(durationController.text);
                  String priotity = priorityController.text;
                  String category = categoryController.text;
                  String description = descriptionController.text;
                  if (isDateValid(date) &&
                      type.isNotEmpty &&
                      duration != null &&
                      priotity.isNotEmpty &&
                      category.isNotEmpty &&
                      description.isNotEmpty) {
                    Navigator.pop(
                        context,
                        TaskManagementData(
                            date: date,
                            type: type,
                            duration: duration,
                            priority: priotity,
                            category: category,
                            description: description));
                  } else {
                    if (!isDateValid(date)) {
                      message(context, "Date is not valid", "Error");
                    } else if (type.isEmpty) {
                      message(context, "Type is empty", "Error");
                    } else if (duration == null) {
                      message(context, "Duration is not valid", "Error");
                    } else if (priotity.isEmpty) {
                      message(context, "Priority is not valid", "Error");
                    } else if (category.isEmpty) {
                      message(context, "Category is not valid", "Error");
                    } else if (description.isEmpty) {
                      message(context, "Description is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
