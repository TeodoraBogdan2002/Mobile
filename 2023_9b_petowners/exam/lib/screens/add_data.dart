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
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController ownerController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;




  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    breedController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    ownerController = TextEditingController();
    locationController = TextEditingController();
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
            TextBox(nameController, "Name"),
            TextBox(breedController, "Breed"),
            TextBox(ageController, "Age"),
            TextBox(weightController, "Weight"),
            TextBox(ownerController, "Owner"),
            TextBox(locationController, "Location"),
            TextBox(descriptionController, "Description"),
            ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String breed = breedController.text;
                  int? age = int.tryParse(ageController.text);
                  int? weight = int.tryParse(weightController.text);
                  String owner = ownerController.text;
                  String location = locationController.text;
                  String description = descriptionController.text;
                  if (name.isNotEmpty &&
                      breed.isNotEmpty &&
                      age != null &&
                      owner.isNotEmpty &&
                      location.isNotEmpty &&
                      weight != null &&
                      description.isNotEmpty) {
                    Navigator.pop(
                        context,
                        PetData(
                            name: name,
                            breed: breed,
                            age: age,
                            weight: weight,
                            owner: owner,
                            location: location,
                            description: description));
                  } else {
                    if (breed.isEmpty) {
                      message(context, "Breed is empty", "Error");
                    }else if (name.isEmpty) {
                      message(context, "Name is not valid", "Error");
                    }else if (weight == null) {
                      message(context, "Weight is not valid", "Error");
                    }
                     else if (age == null) {
                      message(context, "Age is not valid", "Error");
                    } else if (owner.isEmpty) {
                      message(context, "Owner is not valid", "Error");
                    }else if (location.isEmpty) {
                      message(context, "Location is not valid", "Error");
                    }else if (description.isEmpty) {
                      message(context, "Description is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
