

import 'package:hfc/models/dishData.dart';

class DishModel {
  final String? id;
  final String type;
  final String amount;
  final String measurement;
  final DishData data;

  const DishModel(
      {this.id,
      required this.type,
      required this.amount,
      required this.measurement,
      required this.data
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