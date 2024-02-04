import 'package:intl/intl.dart';

class FoodStory{
  static int currentId=0;
  int? id;
  String foodstory_date;
  String food_products;
  int nrCalories;
  int sugarQuantity;
  String addInfo;

  // FoodStory(this.foodstory_date,this.food_products,this.nrCalories,this.sugarQuantity,this.addInfo){
  //   id = currentId++;
  // }

  FoodStory({this.id, required this.foodstory_date, required this.food_products, required this.nrCalories, required this.sugarQuantity, required this.addInfo});


  factory FoodStory.fromMap(Map<String, dynamic> json) => FoodStory(
    id: json['_id'],
    foodstory_date: json['date'],
    food_products: json['products'],
    nrCalories: json['calories'],
    sugarQuantity: json['sugar'],
    addInfo: json['text']
  );

  Map<String, dynamic> toMap(){
    return {
      '_id': id,
      'date': foodstory_date,
      'products': food_products,
      'calories': nrCalories,
      'sugar': sugarQuantity,
      'text': addInfo
    };
  }

  FoodStory.fromFoodStory(this.id, this.foodstory_date,this.food_products,this.nrCalories,this.sugarQuantity,this.addInfo);

  static List<FoodStory> init(){
    List<FoodStory> food_Stories = [
      FoodStory(foodstory_date: "20.10.2023", food_products: "Two muffins, chicken soup, two coffees, one chicken salads", nrCalories: 1500, sugarQuantity: 29,addInfo: ""),
      FoodStory(foodstory_date: "21.10.2023",food_products: "One cappuccino, 200 gr brownie,150 gr tomatoes, 200 gr roast chicken", nrCalories: 1600, sugarQuantity:30, addInfo: "i walked 6 kilometers"),
      FoodStory(foodstory_date: "22.10.2023", food_products: "One cappuccino,  300 gr porridge, one banana, 250 ml chicken soup, 300 gr tomato salad, one piadina", nrCalories: 1550, sugarQuantity: 23, addInfo: "i walked 4 kilometers")
    ];

    return food_Stories;
  }

}