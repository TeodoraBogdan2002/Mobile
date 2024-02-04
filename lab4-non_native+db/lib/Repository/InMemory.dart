import '../Story.dart';

class InMemory {

  List<FoodStory> stories = FoodStory.init();

  FoodStory? getStoryById(int id) {
    for (FoodStory s in stories) {
      if (s.id == id) return s;
    }
    return null;
  }

  void update(FoodStory newStory){
    for(int i = 0; i < stories.length; i++){
      if(stories[i].id == newStory.id) {
        stories[i] = newStory;
      }
    }
  }

  void add(FoodStory s){
    stories.add(s);
  }

  void removeFromList(int id) {
    stories.removeWhere((element) => element.id == id);
  }

}