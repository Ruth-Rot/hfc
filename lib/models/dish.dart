

import 'package:hfc/models/dishData.dart';

import '../controllers/dish_controller.dart';

class DishModel {
  final String? id;
  final String type;
  final String amount;
  final String measurement;
  late DishData data;
  final DishController controller;

   DishModel(
      {this.id,
      required this.type,
      required this.amount,
      required this.measurement,
       required this.data,
      required this.controller
    });
  toJson() {
    return {
      "dish": type,
      "measurement": measurement,
      "amount": amount,   
      "data": data.toJson()   
    };
  }
}