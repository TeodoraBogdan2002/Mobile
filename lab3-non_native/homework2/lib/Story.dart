import 'package:intl/intl.dart';

class FoodStory{
  static int currentId=0;
  late int id;
  String foodstory_date;
  String food_products;
  int nrCalories;
  int sugarQuantity;
  String addInfo;

  FoodStory(this.foodstory_date,this.food_products,this.nrCalories,this.sugarQuantity,this.addInfo){
    id = currentId++;
  }

  FoodStory.fromFoodStory(this.id, this.foodstory_date,this.food_products,this.nrCalories,this.sugarQuantity,this.addInfo);

  static List<FoodStory> init(){
    List<FoodStory> food_Stories = [
      FoodStory("20.10.2023", "Two muffins, chicken soup, two coffees, one chicken salads", 1500, 29, ""),
      FoodStory("21.10.2023","One cappuccino, 200 gr brownie,150 gr tomatoes, 200 gr roast chicken", 1600, 30, "i walked 6 kilometers"),
      FoodStory("22.10.2023", "One cappuccino,  300 gr porridge, one banana, 250 ml chicken soup, 300 gr tomato salad, one piadina", 1550, 23, "i walked 4 kilometers")
    ];

    return food_Stories;
  }

}