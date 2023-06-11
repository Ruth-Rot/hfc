import 'package:flutter/material.dart';

class Activity {
  final String label;
  final double duration;
  final double calories;

   Activity({
    required this.calories,
    required this.duration,
    required this.label
  });

  factory Activity.fromJson(List<dynamic> json) {
    return Activity(
     
      calories:  double.parse(json[0]["total_calories"].toString()) ,
      duration:double.parse( json[0]["duration_minutes"].toString()),
      label: json[0]["name"],
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
