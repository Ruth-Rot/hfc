
import 'package:hfc/models/meal.dart';

class Day {
  final String? id;
  final String date;
  late List<MealModel> meals = [
    MealModel(type: 'Breakfast'),
    MealModel(type: 'Lunch'),
    MealModel(type: 'Dinner'),
    MealModel(type: 'Snacks'),
    MealModel(type: 'Activity')
  ];
  late Map<String, int> mealsIndex = {
    'Breakfast': 0,
    'Lunch': 1,
    'Dinner': 2,
    'Snacks': 3,
    'Activity': 4
  };

  Day({this.id, required this.date});
  toJson() {
    return {
      "date": date,
      "meals": meals,
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
