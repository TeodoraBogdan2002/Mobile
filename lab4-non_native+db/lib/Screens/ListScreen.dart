import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:homework2/Repository/RepositoryDatabase.dart';
// import 'package:intl/intl.dart';
import 'package:homework2/Screens/AddStoryScreen.dart';
import 'package:homework2/Screens/UpdateStoryScreen.dart';
import '../Story.dart';

class ListScreen extends StatefulWidget{
  const ListScreen({super.key});

  @override
  State<StatefulWidget> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen>{
  late List<FoodStory> stories = FoodStory.init();
  DatabaseRepo databaseRepo = DatabaseRepo.dbInstance;

  FoodStory? getStoryById(int id) {
    for (FoodStory s in stories) {
      if (s.id == id) return s;
    }
    return null;
  }

  void getStoriesFromFuture() async {
    stories = await databaseRepo.getStories();
  }

  // void update(FoodStory newFoodStory){
  //   for(int i=0;i<stories.length;i++){
  //     if(stories[i].id==newFoodStory.id){
  //       stories[i]=newFoodStory;
  //     }
  //   }
  // }

  // void removeFromList(int id){
  //   stories.removeWhere((element) => element.id == id);
  // }

  _showDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("DeleteAlertDialog"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () async{
                    await databaseRepo.removeFromList(id);
                    setState(() {
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
          "Food Journal",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0x9CB5ECDB),
      ),
      body: Center(
        child: Container(
            color: const Color(0xE273F18F),
            child: _buildListOfStories()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            FoodStory foodstory = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStoryScreen()));
            await databaseRepo.add(foodstory);
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Added!"),
              ));
            });
          },
          backgroundColor: Colors.black45,
          child: const Icon(Icons.add)),
    );
  }

  //the future builder waits for the result to be completed and only
  //then it calls the build
  //if it's not ready it returns an empty container
  Widget _buildListOfStories(){
    return FutureBuilder(
        builder: (context, story) {
          if(story.connectionState == ConnectionState.none && story.connectionState == null){
            return Container();
        } else if(!story.hasData){
            return Container();
          }
        return ListView.builder( itemCount: story.data!.length,
            itemBuilder: (context, index) {
            return templateStory(story.data![index]);
       }
       );
    },
    future: databaseRepo.getStories(),
    );
  }

  Widget templateStory(story) {
    return Card(
        elevation: 0,
        // margin: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
            color: const Color(0xE273F18F),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0x9C45B55E),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Date: ${story.foodstory_date}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Food Products: ${story.food_products}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Calories: ${story.nrCalories}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Sugar Quantity: ${story.sugarQuantity}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Additional Info: ${story.addInfo}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
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
                            await databaseRepo.update(story2);
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Updated!"),
                              ));
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