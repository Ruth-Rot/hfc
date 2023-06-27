import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/headers/circle_header.dart';
import 'package:hfc/common/recipe_card.dart';
import 'package:hfc/models/recipe_widget_controller.dart';
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
    for (RecipeModel r in widget.recipes) {
      recipeControllers.add(RecipeWidgetController(recipe: r));
    }
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        circleHeader(
            context,
            const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.bowlFood,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "My Recipes",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )
                ])),
        SizedBox(
          height: 700,
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: widget.recipes.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: SizedBox(
                      height: recipeControllers[index].getHeight() + 20.0,
                      child: RecipeCard(
                        recipeController: recipeControllers[index],
                      )),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: 5,
                  )),
        ),
      ],
    )));
  }
}
