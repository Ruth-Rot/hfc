import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/common/circleHeader.dart';
import 'package:hfc/common/recipeCard2.dart';
import 'package:hfc/models/recipeWidgetController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';

class MyRecipePage extends StatefulWidget {
  List<RecipeModel> recipes;

  MyRecipePage({Key? key, required this.recipes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __MyRecipePageState();
  }
}

class __MyRecipePageState extends State<MyRecipePage> {
  List<RecipeWidgetController> recipeControllers = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    for (RecipeModel r in widget.recipes) {
      recipeControllers.add(RecipeWidgetController(recipe: r));
    }

    if (widget.recipes.isEmpty == false) {
      return Column(
        children: [
          circleHeader(context, Text("Recipes:")),
           SizedBox(
            height: 500,
             child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.recipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: recipeControllers[index].getHeight() + 20.0,
                        child: recipeCard2(
                          recipeController: recipeControllers[index],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        height: 5,
                      )),
           ),
          
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "You haven't fill your personal details yet",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
                height: 300,
                child:
                    Image(image: AssetImage('./assets/images/splash_bot.png'))),
            SizedBox(
              height: 30,
            ),
            Text("Fill your details in the chat bot",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
          ],
        ),
      );
    }
  }
}
