import 'package:hfc/models/dish.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/dishData.dart';
import '../models/meal.dart';

Future<Activity> fetchActivityData (String activity, String weight, String duration) async {
    var querystring = {"activity":"ym","weight":"70","duration":"60"};
  //var querystring = {"activity":activity,"weight":weight,"duration":duration};


//https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned

  final uri =
    Uri.https('calories-burned-by-api-ninjas.p.rapidapi.com', '/v1/caloriesburned', querystring);



var headers = {
	"X-RapidAPI-Key": "fe8c47f227mshd760ad2995da85bp1a536djsnd48322f3c41e",
	"X-RapidAPI-Host": "calories-burned-by-api-ninjas.p.rapidapi.com"
};

//response = requests.get(url, headers=headers, params=querystring);
  
  final response = await http.get(uri,headers: headers, );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Activity.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load activity api answer');
  }
}





