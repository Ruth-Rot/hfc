import 'package:flutter/cupertino.dart';
import 'package:hfc/models/dish.dart';

class MealModel {
  final String? id;
  final String type;
  late bool isAdd = false;
  late bool isOpen = false;
  late TextEditingController dishController =
      TextEditingController(); //TextEditingController();
  late TextEditingController amountController = TextEditingController();
  late String measurement = "Cup";
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<DishModel> dishes = [];
  MealModel({
    this.id,
    required this.type,
    required this.dishes
  });
  toJson() {
    List build = [];
    for (DishModel dish in dishes) {
      build.add(dish.toJson());
    }
    return {"type": type, "dishes": build};
  }



  getHeight() {
    if(isOpen == false){
      return 70.0;
    }
    double basic = 100;
    if (isAdd == true) {
      basic += 50;
    }
    basic += 40 * dishes.length;
    return basic;
  }

  getCalories() {
    double sum = 0.0;
    for (DishModel dish in dishes) {
      sum += dish.data.calories;
    }
    return sum;
  }

  getCarbs() {
    double sum = 0.0;
    for (DishModel dish in dishes) {
      sum += dish.data.crabs;
    }
    return sum;
  }

  getProtein() {
    double sum = 0.0;
    for (DishModel dish in dishes) {
      sum += dish.data.protein;
    }
    return sum;
  }

  getFat() {
    double sum = 0.0;
    for (DishModel dish in dishes) {
      sum += dish.data.fat;
    }
    return sum;
  }
}
