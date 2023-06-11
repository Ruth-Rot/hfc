import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hfc/models/dish.dart';
import 'package:hfc/models/meal.dart';
import 'package:hfc/reposiontrys/nutritionApi_reposiontry.dart';

import 'day.dart';
import 'dishData.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String urlImage;
  final String gender;
  late bool fillDetails;
  late List conversation;
  late double dailyCalories;
  late double weight;
  late double height;
  late Map<String, Day> diary;

  UserModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.password,
      required this.urlImage,
      required this.gender,
      required this.fillDetails,
      required this.conversation,
      required this.dailyCalories,
      required this.diary,
      required this.weight,
      required this.height,
      });
  toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "gender": gender,
      "urlImage": urlImage,
      "fill_details": fillDetails,
      "conversation": conversation,
      "daily_calories": dailyCalories,
      "diary": diary,
      "weight":weight,
      "height":height
    };
  }

  getId() {
    return id;
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    Map<String, Day> days = {};
    var diaryData = data["diary"];

    if (diaryData.length > 0) {
      List<DishModel> dishes = [];
      List<MealModel> meals = [];

      for (var date in diaryData.keys) {
        meals = [];
        for (var meal in diaryData[date]["meals"]) {
          dishes = [];
          for (var dish in meal["dishes"]) {
            DishData data = DishData(
                calories: dish["data"]["calories"],
                protein: dish["data"]["protein"],
                crabs: dish["data"]["crabs"],
                fat: dish["data"]["fat"]);
            dishes.add(DishModel(
                type: dish["dish"],
                amount: dish["amount"],
                measurement: dish["measurement"],
                data: data
                ));
          }
          meals.add(MealModel(type: meal["type"], dishes: dishes));
        }
        days[date] = Day(date: date, meals: meals,activitys:diaryData[date]["activitys"]);
      }
    }
    return UserModel(
        id: document.id,
        fullName: data["fullName"],
        email: data["email"],
        password: data["password"],
        urlImage: data["urlImage"],
        gender: data["gender"],
        fillDetails: data["fill_details"],
        conversation: data["conversation"],
        dailyCalories: data["daily_calories"],
        diary: days,
        weight: double.parse(data["weight"]),
        height: double.parse(data["height"]));
  }
}
