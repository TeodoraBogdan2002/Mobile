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
  late TextEditingController modelController;
    late TextEditingController statusController;
  late TextEditingController capacityController;
  late TextEditingController ownerController;
  late TextEditingController manufacturerController;
  late TextEditingController cargoController;


  @override
  void initState() {
    super.initState();
    modelController = TextEditingController();
    statusController = TextEditingController();
    capacityController  = TextEditingController();
    ownerController  = TextEditingController();
    manufacturerController = TextEditingController();
    cargoController = TextEditingController();

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
            TextBox(modelController, "Model"),
            TextBox(statusController, "Status"),
            TextBox(capacityController, "Capacity"),
            TextBox(ownerController, "Owner"),
            TextBox(manufacturerController, "Manufacturer"),
            TextBox(cargoController, "Cargo"),
            ElevatedButton(
                onPressed: () {
                  String model = modelController.text;
                  String status = statusController.text;
                  int? capacity =int.tryParse(capacityController.text);
                  String owner = ownerController.text;
                  String manufacturer = manufacturerController.text;
                  int? cargo = int.tryParse(cargoController.text);
                  if (model.isNotEmpty &&
                      capacity!= null &&
                      manufacturer.isNotEmpty &&
                      status.isNotEmpty &&
                      owner.isNotEmpty &&
                      cargo != null) {
                    Navigator.pop(
                        context,
                        VehicleData(
                            model: model,
                            status: status,
                            capacity: capacity,
                            owner: owner,
                            manufacturer: manufacturer,
                            cargo: cargo));
                  } else {
                    if (status.isEmpty) {
                      message(context, "Status is not valid", "Error");
                    } else if (cargo==null) {
                      message(context, "Cargo is empty", "Error");
                    } else if (manufacturer.isEmpty) {
                      message(context, "Manufacturer is not valid", "Error");
                    } else if (model.isEmpty) {
                      message(context, "Model is not valid", "Error");
                    }else if (owner.isEmpty) {
                      message(context, "Owner is not valid", "Error");
                    }
                    else if (capacity==null) {
                      message(context, "Capacity is not valid", "Error");
                    }
                  }
                },
                child: const Text("Save"))
          ],
        ));
  }
}
