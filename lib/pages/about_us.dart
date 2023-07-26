import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../headers/circle_header.dart';

class AboutUs extends StatefulWidget {
  AboutUs({super.key});
  @override
  State<StatefulWidget> createState() {
    return __AboutUsState();
  }
}

class __AboutUsState extends State<AboutUs> {
  String introduction = "";
  String activityLevel = "";
  String dietLevel = "";
  String details = "";
  String diary = "";
  String recipe = "";
  String plan = "";
  String info = "";
  String statistics = "";
  String favorite="";

  @override
  Widget build(BuildContext context) {
    readTexts();

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      circleHeader(
          context,
          const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "App's guide",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              ])),
      //text,
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        width: 390,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textField(introduction),
           
            const SizedBox(
              height: 15,
            ),
            title("Activity Level:"),
            const SizedBox(
              height: 5,
            ),
            textField(activityLevel),
            const SizedBox(
              height: 15,
            ),
            title("Diet Goal:"),
            const SizedBox(
              height: 5,
            ),
            textField(dietLevel),
            const SizedBox(
              height: 15,
            ),
            textField(details),
            const SizedBox(
              height: 15,
            ),
            title("Nutritional diary:"),
            const SizedBox(
              height: 5,
            ),
            textField(diary),
            const SizedBox(
              height: 15,
            ),
            title("Recipe request:"),
            const SizedBox(
              height: 5,
            ),
            textField(recipe),
            const SizedBox(
              height: 15,
            ),
            title("Meal plan:"),
            const SizedBox(
              height: 5,
            ),
            textField(plan),
            const SizedBox(
              height: 15,
            ),
            title("Nutritional information:"),
            const SizedBox(
              height: 5,
            ),
            textField(info),
            const SizedBox(
              height: 15,
            ),
             title("Statistics screen:"),
            const SizedBox(
              height: 5,
            ),
            textField(statistics),
              const SizedBox(
              height: 15,
            ),
             title("Favorite recipes:"),
            const SizedBox(
              height: 5,
            ),
            textField(favorite),
          ],
        ),
      )
    ])));
  }

  Text textField(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14.9),
      textAlign: TextAlign.justify,
    );
  }

  Future<void> readTexts() async {
    final String responseIn =
        await rootBundle.loadString('assets/files/Introduction.txt');
    setState(() {
      introduction = responseIn;
    });
    final String responseActivityLevel =
        await rootBundle.loadString('assets/files/Activity level.txt');
    setState(() {
      activityLevel = responseActivityLevel;
    });
    final String responseDietLevel =
        await rootBundle.loadString('assets/files/Diet level.txt');
    setState(() {
      dietLevel = responseDietLevel;
    });
    final String responseDetails =
        await rootBundle.loadString('assets/files/Details.txt');
    setState(() {
      details = responseDetails;
    });
    final String responseDiary =
        await rootBundle.loadString('assets/files/Nutritional diary.txt');
    setState(() {
      diary = responseDiary;
    });
    final String responseRecipe =
        await rootBundle.loadString('assets/files/Recipe request.txt');
    setState(() {
      recipe = responseRecipe;
    });
    final String responsePlan =
        await rootBundle.loadString('assets/files/Recipe request.txt');
    setState(() {
      plan = responsePlan;
    });
     final String responseInfo =
        await rootBundle.loadString('assets/files/Nutritional information.txt');
    setState(() {
      info = responseInfo;
    });
     final String responseStatistic =
        await rootBundle.loadString('assets/files/Statistics screen.txt');
    setState(() {
      statistics = responseStatistic;
    });
     final String responseFavorite =
        await rootBundle.loadString('assets/files/Favorite recipes.txt');
    setState(() {
      favorite = responseFavorite;
    });
  }

  Text title(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    );
  }
}
