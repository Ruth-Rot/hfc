import 'package:flutter/material.dart';

class MealData {
  
  final double calories;
  final double crabs;
  final double protein;
  final double fat;
  
MealData(
      {
      required this.calories,    
      required this.crabs,
      required this.protein,
      required this.fat 
    });  toJson(String date) {
    return {
      "calories": calories,
      "crabs": crabs,
      "protein":protein,
      "fat":fat
    };
  }
}