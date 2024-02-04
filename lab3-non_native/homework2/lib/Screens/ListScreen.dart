import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:homework2/Screens/AddStoryScreen.dart';
import 'package:homework2/Screens/UpdateStoryScreen.dart';
import '../Story.dart';

class ListScreen extends StatefulWidget{
  const ListScreen({super.key});

  @override
  State<StatefulWidget> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen>{
  final List<FoodStory> stories = FoodStory.init();

  FoodStory? getStoryById(int id) {
    for (FoodStory s in stories) {
      if (s.id == id) return s;
    }
  }

  void update(FoodStory newFoodStory){
    for(int i=0;i<stories.length;i++){
      if(stories[i].id==newFoodStory.id){
        stories[i]=newFoodStory;
      }
    }
  }

  void removeFromList(int id){
    stories.removeWhere((element) => element.id == id);
  }

  _showDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("CupertinoAlertDialog"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    setState(() {
                      removeFromList(id);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Food Notes",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(181, 236, 219, 100),
      ),
      body: Center(
        child: Container(
            color: const Color.fromRGBO(115, 241, 143, 28),
            child: ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  return templateStory(stories[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            FoodStory foodstory = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStoryScreen()));
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Added!"),
              ));
              stories.add(foodstory);
            });
          },
          backgroundColor: Colors.black45,
          child: const Icon(Icons.add)),
    );
  }

  Widget templateStory(story) {
    return Card(
        elevation: 0,
        // margin: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
            color: const Color.fromRGBO(115, 241, 143, 28),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 181, 94, 100),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                         " ${story.foodstory_date}  ${story.food_products}  ${story.nrCalories}  ${story.sugarQuantity}  ${story.addInfo}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                      child: IconButton(
                          onPressed: () => {_showDialog(context, story.id)},
                          icon: const Icon(
                            CupertinoIcons.delete,
                            size: 18,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                          onPressed: ()  async {
                            FoodStory story2 = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => UpdateStoryScreen(story: story!)));
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Updated!"),
                              ));
                              update(story2);
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.pen,
                            size: 25,
                          )),
                    )
                  ])
                ],
              ),
            )));
  }
}