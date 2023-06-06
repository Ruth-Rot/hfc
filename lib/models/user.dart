import 'package:cloud_firestore/cloud_firestore.dart';

import 'day.dart';

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
      required this.diary
      });
    toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "gender": gender,
      "urlImage": urlImage,
      "fill_details": fillDetails,
      "conversation":conversation,
      "daily_calories":dailyCalories,
      "diary":diary
    };
   
  }

 getId(){
      return id;
    }
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    Map<String,Day> days = {};
    if(data["diary"] != {}){
      days = data["diary"] as Map<String,Day>;
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
        diary: days);
  }
}