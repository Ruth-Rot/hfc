import 'package:hfc/models/meal.dart';
import 'package:hfc/models/activitysList.dart';

import 'activity.dart';

class Day {
  final String? id;
  final String date;
  late List<MealModel> meals;
  late ActivityList activitys;
  late Map<String, int> mealsIndex = {
    'Breakfast': 0,
    'Lunch': 1,
    'Dinner': 2,
    'Snacks': 3,
    //'Activity': 4
  };

  Day({this.id, required this.date,required this.meals, required this.activitys});
  toJson() {
    List build = [];
    for (MealModel meal in meals) {
      build.add(meal.toJson());
    }

    return {
      "date": date,
      "meals": build,
      "activitys": activitys.toJson()
    };
  }
  
  getDailyCalories(double daily) {
    double used = 0;
    for (var meal in meals) {
      used += meal.getCalories();
    }
    double result = daily - used;
    return result;
  }

  getDailyProtein() {
    double used = 0;
    for (var meal in meals) {
      used += meal.getProtein();
    }
    return used;
  }

  getDailyFat() {
    double used = 0;
    for (var meal in meals) {
      used += meal.getFat();
    }
    return used;
  }

  getDailyCrabs() {
    double used = 0;
    for (var meal in meals) {
      used += meal.getCarbs();
    }
    return used;
  }
}
getDayMeals(){return [
    MealModel(type: 'Breakfast',dishes: []),
    MealModel(type: 'Lunch',dishes: []),
    MealModel(type: 'Dinner',dishes:[]),
    MealModel(type: 'Snacks', dishes: []),
  //  MealModel(type: 'Activity',dishes: [])
  ];
  }
