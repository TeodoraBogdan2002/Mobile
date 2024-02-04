import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Story.dart';

class AddStoryScreen extends StatefulWidget{
  AddStoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => AddStoryScreenState();
}

class AddStoryScreenState extends State<AddStoryScreen>{
  final _formKey = GlobalKey<FormState>();

  String dateValue = "";
  String foodPrValue = "";
  int caloriesvalue = 0;
  int sugarQValue = 0;
  String addInfoValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(115, 241, 143, 28),
        body: Container(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                        child: const Text('Create food note',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SomeFam')),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 27, 0, 0),
                        child: SizedBox(
                          width: 140,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty){
                                return "Please add some text";
                              }
                              else {
                                return null;
                              }
                            },
                            onChanged: (value) => dateValue = value,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Color.fromRGBO(181, 236, 219, 100),
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SomeFam'),
                              hintText: 'Date...',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      height: 190,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "Please fill up all the fields!";
                          }
                          else {
                            return null;
                          }
                        },
                        onChanged: (value) =>  foodPrValue = value,
                        maxLines: 200,
                        decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromRGBO(181, 236, 219, 100),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomeFam'),
                          hintText: 'Food Products...',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "Please fill up all the fields!";
                          }
                          else {
                            return null;
                          }
                        },
                        onChanged: (value) => caloriesvalue = value as int,
                        decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromRGBO(181, 236, 219, 100),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomeFam'),
                          hintText: 'Nr of calories...',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "Please fill up all the fields!";
                          }
                          else {
                            return null;
                          }
                        },
                        onChanged: (value) => sugarQValue = value as int,
                        decoration: const InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromRGBO(181, 236, 219, 100),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomeFam'),
                          hintText: 'Sugar quantity...',
                        ),
                      ),
                    ),
                  ),                  
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: SizedBox(
                        width: 370,
                        height: 190,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return "Please fill up all the fields!";
                            }
                            else {
                              return null;
                            }
                          },
                          onChanged: (value) => addInfoValue = value,
                          maxLines: 200,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromRGBO(181, 236, 219, 100),
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SomeFam'),
                            hintText: 'Additional Info...',
                          ),
                        ),
                      ),
                  ),
                  Row(children: <Widget>[
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                          child: SizedBox(
                              width: 120,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () =>
                                {
                                  if(_formKey.currentState!.validate()){
                                    Navigator.pop(context,FoodStory(dateValue,foodPrValue, caloriesvalue, sugarQValue, addInfoValue))
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(69, 181, 94, 100)),
                                child: const Text("Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SomeFam')),
                              )),
                        )),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(80, 10, 0, 0),
                          child: SizedBox(
                              width: 120,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () => {Navigator.pop(context)},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(69, 181, 94, 100)),
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SomeFam')),
                              )),
                        ))
                  ])
                ])))));
  }
}