import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hfc/controllers/activity_controller.dart';
import 'package:hfc/models/activity.dart';
import 'package:hfc/models/activitys_list.dart';
import 'package:hfc/models/dish.dart';
import 'package:hfc/controllers/dish_controller.dart';
import 'package:hfc/models/meal.dart';
import 'day.dart';
import 'dish_data.dart';

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
  late String purpose;
  late String activityLevel;

  UserModel({
    this.id,
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
    required this.purpose,
    required this.activityLevel
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
      "weight": weight,
      "height": height,
      "purpose": purpose,
      "activity_level":activityLevel
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
      ActivityList activityList = ActivityList(items: []);

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
                data: data,
                controller: DishController()));
          }
          meals.add(MealModel(type: meal["type"], dishes: dishes));
          activityList = ActivityList(items: []);
          for (var active in diaryData[date]["activitys"]["items"]) {
            Activity act = Activity(
                calories: active["calories"],
                duration: active["duration"],
                label: active["label"],
                controller: ActivityController());
            activityList.items.add(act);
          }
        }
        days[date] = Day(date: date, meals: meals, activitys: activityList);
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
        dailyCalories:  data["daily_calories"].runtimeType == double? data["daily_calories"]:data["daily_calories"].toDouble(),
        diary: days,
        weight: data["weight"].runtimeType == double? data["weight"]:double.parse(data["weight"]),
        height: data["height"].runtimeType == double? data["height"]:double.parse(data["height"]),
       purpose: data["purpose"],
        activityLevel:data["activity_level"]);
     

  }
}
