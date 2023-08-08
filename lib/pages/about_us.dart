import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../headers/circle_header.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});
  @override
  State<StatefulWidget> createState() {
    return __AboutUsState();
  }
}

class __AboutUsState extends State<AboutUs> {
  String first = "";
  String introduction = "";
  String activityLevel = "";
  String dietLevel = "";
  String details = "";
  String diary = "";
  String recipe = "";
  String plan = "";
  String info = "";
  String statistics = "";
  String favorite = "";
  String healthLabels = "";
  String dietLabels = "";
  String dishTypes = "";

  @override
  Widget build(BuildContext context) {
    SizedBox paragraph = const SizedBox(
      height: 15.0,
    );
    SizedBox space = const SizedBox(
      height: 5.0,
    );
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
            titleCenter(first),
            space,
            textField(introduction),
            paragraph,
            title("Activity Level:"),
            space,
            textField(activityLevel),
           paragraph,
            title("Diet Goal:"),
            space,
            textField(dietLevel),
            paragraph,
            textField(details),
            paragraph,
            title("Nutritional diary:"),
            space,
            textField(diary),
            paragraph,
            title("Recipe request:"),
            space,
            textField(recipe),
           paragraph,
            title("Meal plan:"),
            space,
            textField(plan),
            paragraph,
            title("Nutritional information:"),
            space,
            textField(info),
            paragraph,
            title("Statistics screen:"),
            space,
            textField(statistics),
            paragraph,
            title("Favorite recipes:"),
            space,
            textField(favorite),
          paragraph,
            title("Health Labels supported by the app:"),
           space,
            textField(healthLabels),
           paragraph,
            title("Diet Labels supported by the app:"),
           space,
            textField(dietLabels),
            paragraph,
            title("Dish Types supported by the app:"),
            space,
            textField(dishTypes),
            const SizedBox(
              height: 75,
            ),
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
    final String responseFi =
        await rootBundle.loadString('assets/files/First Sentence.txt');
    setState(() {
      first = responseFi;
    });
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
        await rootBundle.loadString('assets/files/Meal plan.txt');
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

    final String responseHealth =
        await rootBundle.loadString('assets/files/Health Labels.txt');
    setState(() {
      healthLabels = responseHealth;
    });
    final String responseDiet =
        await rootBundle.loadString('assets/files/Diet Labels.txt');
    setState(() {
      dietLabels = responseDiet;
    });
    final String responseDish =
        await rootBundle.loadString('assets/files/Dish types.txt');
    setState(() {
      dishTypes = responseDish;
    });
  }

  Text title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    );
  }

  Text titleCenter(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
