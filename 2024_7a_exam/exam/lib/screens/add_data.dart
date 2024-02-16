import 'package:exam/models/fitness_data.dart';
import 'package:exam/widgets/text_box.dart';
import 'package:flutter/material.dart';

import '../widgets/message.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<StatefulWidget> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late TextEditingController nameController;
    late TextEditingController dateController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController participantsController;
  late TextEditingController typeController;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dateController = TextEditingController();
    detailsController  = TextEditingController();
    statusController  = TextEditingController();
    participantsController = TextEditingController();
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
            TextBox(dateController, "Date"),
            TextBox(detailsController, "Details"),
            TextBox(statusController, "Status"),
            TextBox(participantsController, "Participants"),
            TextBox(typeController, "Type"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String date = dateController.text;
                  String details =detailsController.text;
                  String status = statusController.text;
                  int? participants = int.tryParse(participantsController.text);
                  String type = typeController.text;
                  if (name.isNotEmpty &&
                      details.isNotEmpty &&
                      participants != null &&
                      isDateValid(date) &&
                      status.isNotEmpty &&
                      type.isNotEmpty) {
                    Navigator.pop(
                        context,
                        ActivityData(
                            name: name,
                            date: date,
                            details: details,
                            status: status,
                            participants: participants,
                            type: type));
                  } else {
                    if (!isDateValid(date)) {
                      message(context, "Date is not valid", "Error");
                    } else if (type.isEmpty) {
                      message(context, "Type is empty", "Error");
                    } else if (participants == null) {
                      message(context, "Participants is not valid", "Error");
                    } else if (name.isEmpty) {
                      message(context, "Name is not valid", "Error");
                    }else if (status.isEmpty) {
                      message(context, "Status is not valid", "Error");
                    }
                    else if (details.isEmpty) {
                      message(context, "Details is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
