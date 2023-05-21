import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeModel {
  final String? id;
  final requset;
  final String title;
  final List<dynamic> labels;
  final String image;
  final String url;
  const RecipeModel(
      {this.id,
      required this.requset,
      required this.title,
      required this.labels,
      required this.image,
      required this.url});
  toJson() {
    return {
      "title": title,
      "labels": labels,
      "image": image,
      "urlImage": url,
    };
  }
  getId(){
    return id;
  }


  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
        requset: json['request'] as String,
        title: json['title'] as String,
        labels: json['subtitle'],
        image: json['imageUri'] as String,
        url: json['Url'] as String);
  }
  factory RecipeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return RecipeModel(
        id: document.id,
        requset: "recipe",
        title: data["title"],
        labels: data["labels"],
        image: data["image"],
        url: data["urlImage"]);
  }
}
