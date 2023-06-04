import 'package:flutter/cupertino.dart';
import 'package:hfc/models/dish.dart';

class MealModel {
  final String? id;
  final String type;
  late bool  isAdd = false;
 late  TextEditingController dishController = TextEditingController(); //TextEditingController();
 late  TextEditingController amountController=TextEditingController() ;
 late  TextEditingController measurementController=TextEditingController() ;
 late  GlobalKey<FormState> formKey= GlobalKey<FormState>();
 late List<DishModel> dishes=[];
  MealModel(
      {this.id,
      required this.type,     
    });
  toJson(String date) {
    return {
      "type": type,
      "dishes": dishes,
      "date":date
    };
  }

  getHeight(){
    double basic = 150;
    if (isAdd == true){
      basic += 50;
    }
    basic += 40* dishes.length;
    return basic;
  }

  getCalories(){
    return 0;
  }
}
