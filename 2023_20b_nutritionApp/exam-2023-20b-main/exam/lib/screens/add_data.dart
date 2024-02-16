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
  late TextEditingController typeController;
  late TextEditingController caloriesController;
  late TextEditingController dateController;
  late TextEditingController notesController;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    typeController = TextEditingController();
    caloriesController = TextEditingController();
    dateController = TextEditingController();
    notesController = TextEditingController();

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
            TextBox(typeController, "Type"),
            TextBox(caloriesController, "Calories"),
            TextBox(dateController, "Date"),
            TextBox(dateController, "Notes"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String type = typeController.text;
                  int? calories = int.tryParse(caloriesController.text);
                  String date = dateController.text;
                  String notes = dateController.text;
                  if (name.isNotEmpty &&
                      type.isNotEmpty &&
                      calories != null &&
                      isDateValid(date) &&
                      notes.isNotEmpty) {
                    Navigator.pop(
                        context,
                        MealData(
                            name: name,
                            type: type,
                            calories: calories,
                            date: date,
                            notes: notes));
                  } else {
                    if (!isDateValid(date)) {
                      message(context, "Date is not valid", "Error");
                    } else if (type.isEmpty) {
                      message(context, "Type is empty", "Error");
                    } else if (calories == null) {
                      message(context, "Calories is not valid", "Error");
                    } else if (name.isEmpty) {
                      message(context, "Name is not valid", "Error");
                    }else if (notes.isEmpty) {
                      message(context, "Notes is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
