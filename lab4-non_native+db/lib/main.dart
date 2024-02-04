import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:homework2/Screens/AddStoryScreen.dart';

import 'Screens/ListScreen.dart';

void main() {
  runApp(const MaterialApp(
      home: MyMainScreen()
  )
  );
}

class MyMainScreen extends StatefulWidget {
  const MyMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => MyMainScreenState();
}

class MyMainScreenState extends State<MyMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(115, 241, 143, 28),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 100, 40, 0),
            child: Image(
              image: AssetImage("assets/logo.png"),
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
          ),
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListScreen()))
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 153, 189, 154)
                  ),
                  child: const Text(
                    "Enter your food journal!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SomeFam'
                    )),
                )
          )
        ],
      ),
    );
  }
}