import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../models/activity.dart';

Future<Activity> fetchActivityData(
    String activity, double weight, String duration) async {
  if (weight < 50) {
    weight = 50;
  }
  var querystring = {
    "activity": activity,
    "weight": weight.toString(),
    "duration": duration
  };

  final uri = Uri.https('calories-burned-by-api-ninjas.p.rapidapi.com',
      '/v1/caloriesburned', querystring);

  var headers = {
    "X-RapidAPI-Key": "fe8c47f227mshd760ad2995da85bp1a536djsnd48322f3c41e",
    "X-RapidAPI-Host": "calories-burned-by-api-ninjas.p.rapidapi.com"
  };


  final response = await http.get(
    uri,
    headers: headers,
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Activity.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load activity api answer');
  }
}
