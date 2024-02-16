import 'package:exam/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:exam/models/fitness_data.dart'; // Import your data model
import '../services/database_helper.dart';
import 'package:exam/widgets/text_box.dart';

import '../widgets/message.dart';


class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController heightController;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();

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
            TextBox(ageController, "Age"),
            TextBox(heightController, "Height"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  int? age = int.tryParse(ageController.text);
                  int? height = int.tryParse(heightController.text);
                  if (name.isNotEmpty &&
                      height != null &&
                      age != null ) {
                    Navigator.pop(
                        context,
                        UserData(
                            name: name,
                            age: age,
                            height: height));
                  } else {
                    if (name.isEmpty) {
                      message(context, "Type is empty", "Error");
                    } else if (age == null) {
                      message(context, "Age is not valid", "Error");
                    } else if (height == null) {
                      message(context, "Height is not valid", "Error");
                    }
                  }
                },
                child: const Text("Add new user"))
          ],
        ));
  }
}

