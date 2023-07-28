import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../models/dish_data.dart';

Future<DishData> fetchDishData(
    String type, String amount, String measurement) async {
  String ask = "$type $amount $measurement";
 // String check = "$type 1 $measurement";

  ask = ask.replaceAll(" ", "%20");
//  check = check.replaceAll(" ", "%20");

  final response = await http.get(Uri.parse(
      'https://api.edamam.com/api/nutrition-data?app_id=5cb3740f&app_key=a9e3c561a5d66e6b507a809b9b28e07b&nutrition-type=cooking&ingr=$ask'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // if (amount != "1") {
    //   final responseCheck = await http.get(Uri.parse(
    //       'https://api.edamam.com/api/nutrition-data?app_id=5cb3740f&app_key=a9e3c561a5d66e6b507a809b9b28e07b&nutrition-type=cooking&ingr=$check'));
    //   if (responseCheck.statusCode == 200) {
    //     DishData res = DishData.fromJson(jsonDecode(response.body));
    //   //  DishData check = DishData.fromJson(jsonDecode(responseCheck.body));
    //     return res;
    //   } else {
    //     // If the server did not return a 200 OK response,
    //     // then throw an exception.
    //     throw Exception('Failed to load nutrion data');
    //   }
    // } else {
      return DishData.fromJson(jsonDecode(response.body));
    //}
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load nutrion data');
  }
}


//void main() => runApp(const MyApp());

// class TotalCalories extends StatefulWidget {
//   List<MealModel> meals;
//   TotalCalories({super.key, required this.meals});

//   @override
//   State<TotalCalories> createState() => _TotalCaloriesState();
// }

// class _TotalCaloriesState extends State<TotalCalories> {
//   late Future<DishData> futureDish;

//   @override
//   void initState() {
//     super.initState();
//     // futureDish = fetchDishData(DishModel(type: "pizza", amount: "2", measurement: "slices"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FutureBuilder<DishData>(
//         future: futureDish,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Text(snapshot.data!.calories.toString());
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           }

//           // By default, show a loading spinner.
//           return const CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }
