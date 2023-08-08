import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../models/dish_data.dart';

Future<DishData> fetchDishData(
    String type, String amount, String measurement) async {
  String ask = "$type $amount $measurement";

  ask = ask.replaceAll(" ", "%20");

  final response = await http.get(Uri.parse(
      'https://api.edamam.com/api/nutrition-data?app_id=5cb3740f&app_key=a9e3c561a5d66e6b507a809b9b28e07b&nutrition-type=cooking&ingr=$ask'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
   
      return DishData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load nutrion data');
  }
}

