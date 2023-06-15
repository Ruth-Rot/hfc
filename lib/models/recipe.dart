import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeModel {
  final String? id;
  final String request;
  final String title;
  final List<String> healthLabels;
  final List<String> dietLabels;
  final List<String> ingredients;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final String image;
  final String url;

  const RecipeModel(
      {this.id,
      required this.request,
      required this.title,
      required this.image,
      required this.url,
      required this.healthLabels,
      required this.dietLabels,
      required this.ingredients,
      required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein});
  toJson() {
    return {
      "title": title,
      "healthLabels": healthLabels,
      "dietLabels": dietLabels,
      "image": image,
      "url": url,
      "ingredients": ingredients,
      "calories": calories,
      "carbs": carbs,
      "fat": fat,
      "protein": protein
    };
  }

  getId() {
    return id;
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String> health=[];
    List<String> diet=[];
    List<String> ingredients = [];
    for(String s in json['healthLabels']){
      health.add(s);
    }
    for(String s in json['dietLabels']){
      diet.add(s);
    }
     for(String s in json['ingredients']){
      ingredients.add(s);
    }
    return RecipeModel(
        request: "recipe",
        title: json['title'] as String,
        healthLabels: health,
        dietLabels: diet,
        image: json['image'] as String,
        url: json['url'] as String,
        calories: json['calories'],
        ingredients: ingredients,
        carbs: json['carbs'],
        fat: json['fat'],
        protein: json['protein']);
  }
  factory RecipeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
         List<String> health=[];
    List<String> diet=[];
    List<String> ingredients = [];
    for(String s in document['healthLabels']){
      health.add(s);
    }
    for(String s in document['dietLabels']){
      diet.add(s);
    }
     for(String s in document['ingredients']){
      ingredients.add(s);
    }
    final data = document.data()!;
    return RecipeModel(
        id: document.id,
        request: "recipe",
        title: data['title'] as String,
        healthLabels: health,
        dietLabels: diet,
        image: data['image'] as String,
        url: data['url'] as String,
        calories: data['calories'],
        ingredients: ingredients,
        carbs: data['carbs'],
        fat: data['fat'],
        protein: data['protein']);
  }

  getLabels() {
    return new List.from(healthLabels)..addAll(dietLabels);
  }
}
