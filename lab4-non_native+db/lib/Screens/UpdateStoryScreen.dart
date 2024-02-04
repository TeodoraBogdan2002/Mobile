import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

import '../Story.dart';

class UpdateStoryScreen extends StatefulWidget {
  const UpdateStoryScreen({super.key, required this.story});

  final FoodStory story;

  @override
  State<StatefulWidget> createState() => UpdateStoryScreenState();
}

class UpdateStoryScreenState extends State<UpdateStoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String dateValue = widget.story.foodstory_date;
    String foodproductsValue = widget.story.food_products;
    int caloriesValue = widget.story.nrCalories;
    int sugarQValue = widget.story.sugarQuantity;
    String textValue = widget.story.addInfo;

    return Scaffold(
        backgroundColor: const Color.fromRGBO(115, 241, 143, 28),
        body: Container(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                        child: const Text('Update note',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SomeFam')),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: Text(
                            "Date",
                            style: TextStyle(
                                fontFamily: "SomeFam",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 27, 0, 0),
                        child: SizedBox(
                          width: 140,
                          child: TextFormField(
                            initialValue: widget.story.foodstory_date,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please add some text";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) => dateValue = value,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
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
                  const Text(
                    "Food Products",
                    style: TextStyle(
                        fontFamily: "SomeFam",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      height: 180,
                      child: TextFormField(
                        initialValue: widget.story.food_products,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill up all the fields!";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => foodproductsValue = value,
                        maxLines: 100,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromRGBO(181, 236, 219, 100),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomeFam'),
                          hintText: 'Food products...',
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Calories Quantity",
                    style: TextStyle(
                        fontFamily: "SomeFam",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        initialValue: widget.story.nrCalories.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill up all the fields!";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => caloriesValue =
                            int.parse(value), // Parse input to int
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromRGBO(181, 236, 219, 100),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomeFam'),
                          hintText: 'Calories...',
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Sugar quantity",
                    style: TextStyle(
                        fontFamily: "SomeFam",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      child: TextFormField(
                        initialValue: widget.story.sugarQuantity.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill up all the fields!";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => sugarQValue = int.parse(value),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
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
                  const Text(
                    "Additional Info",
                    style: TextStyle(
                        fontFamily: "SomeFam",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 370,
                      height: 100,
                      child: TextFormField(
                        initialValue: widget.story.addInfo,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill up all the fields!";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => textValue = value,
                        maxLines: 100,
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
                          hintText: 'Text...',
                        ),
                      ),
                    ),
                  ),
                  Row(children: <Widget>[
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(80, 10, 0, 0),
                          child: SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () => {Navigator.pop(context)},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(69, 181, 94, 100)),
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SomeFam')),
                              )),
                        )),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                          child: SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      Navigator.pop(
                                          context,
                                          FoodStory(
                                              id: widget.story.id,
                                              foodstory_date: dateValue,
                                              food_products: foodproductsValue,
                                              nrCalories: caloriesValue,
                                              sugarQuantity:sugarQValue,
                                              addInfo: textValue))
                                    }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(69, 181, 94, 100)),
                                child: const Text("Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SomeFam')),
                              )),
                        ))
                  ])
                ])))));
  }
}
