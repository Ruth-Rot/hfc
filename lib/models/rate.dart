import 'package:cloud_firestore/cloud_firestore.dart';

class RateModel {
  final String? id;
  final bool like;
  final String userId;
  final String recipeId;

  const RateModel(
      {this.id,
      required this.like,
      required this.userId,
      required this.recipeId,
    });
  toJson() {
    return {
      "like": like,
      "userId": userId,
      "recipeId": recipeId,
    };
  }


  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
        like: json['like'] as bool,
        userId: json['userId'] as String,
        recipeId: json['recipeId']);
  }
  factory RateModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return RateModel(
        id: document.id,
        like: data["like"],
        userId: data["userId"],
        recipeId: data["recipeId"],
        );
  }
}