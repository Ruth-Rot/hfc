import 'package:hfc/models/dish.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/meal.dart';

Future<DishData> fetchDishData (String type, String amount, String measurement) async {
  
  String ask = type + " " + amount + " " + measurement;
  ask = ask.replaceAll(" ", "%20");

  final response = await http.get(Uri.parse(
      'https://api.edamam.com/api/nutrition-data?app_id=5cb3740f&app_key=a9e3c561a5d66e6b507a809b9b28e07b&nutrition-type=cooking&ingr=${ask}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return DishData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class DishData {
  final double calories;
  final double protein;
  final double crabs;
  final double fat;

  const DishData({
    required this.calories,
    required this.protein,
    required this.crabs,
    required this.fat,
  });

  factory DishData.fromJson(Map<String, dynamic> json) {
    double pro= 0.0;
    if(json['totalDaily'].length>0){
      pro = json['totalDaily']['PROCNT']['quantity'].toDouble();
    }
    double cra= 0.0;
    if(json['totalDaily'].length>0){
      cra = json['totalDaily']['CHOCDF']['quantity'].toDouble();
    }
    double fat= 0.0;
    if(json['totalDaily'].length>0 ){
      fat = json['totalDaily']['FAT']['quantity'].toDouble();
    }
    return DishData(
      calories: json['calories'].toDouble(),
      protein: pro,
      crabs: cra,
      fat: fat,
    );
  }

 double getCalories() {
    return calories;
  }
}

//void main() => runApp(const MyApp());

class TotalCalories extends StatefulWidget {
  List<MealModel> meals;
  TotalCalories({super.key, required this.meals});

  @override
  State<TotalCalories> createState() => _TotalCaloriesState();
}

class _TotalCaloriesState extends State<TotalCalories> {
  late Future<DishData> futureDish;

  @override
  void initState() {
    super.initState();
    // futureDish = fetchDishData(DishModel(type: "pizza", amount: "2", measurement: "slices"));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<DishData>(
        future: futureDish,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.calories.toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
