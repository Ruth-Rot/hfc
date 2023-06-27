import 'package:hfc/controllers/activity_controller.dart';

class Activity {
  final String label;
  final double duration;
  late double calories;
  late ActivityController controller;

  Activity(
      {required this.calories, required this.duration, required this.label,required this.controller});

  factory Activity.fromJson(List<dynamic> json) {
    return Activity(
      calories: double.parse(json[0]["total_calories"].toString()),
      duration: double.parse(json[0]["duration_minutes"].toString()),
      label: json[0]["name"],
      controller: ActivityController()
    );
  }

  double getCalories() {
    return calories;
  }

  toJson() {
    return {
      "calories": calories,
      "label": label,
      "duration": duration,
    };
  }
}
