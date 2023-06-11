import 'package:flutter/cupertino.dart';
import 'package:hfc/models/activity.dart';
import 'package:hfc/models/dish.dart';

class ActivityList {
  late bool isAdd = false;
  late bool isOpen = false;
  late TextEditingController activeController =
      TextEditingController(); //TextEditingController();
  late TextEditingController durationController = TextEditingController();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<Activity> items = [];
  ActivityList({
    required this.items
  });
  toJson() {
    List build = [];
    for (var item in items) {
      build.add(item.toJson());
    }
    return {"items": build};
  }


  getHeight() {
    if(isOpen == false){
      return 70.0;
    }
    double basic = 100;
    if (isAdd == true) {
      basic += 70;
    }
    basic += 40 * items.length;
    return basic;
  }

  getCalories() {
    double sum = 0.0;
    for (Activity act in items) {
      sum += act.getCalories();
    }
    return sum;
  }

  
}
