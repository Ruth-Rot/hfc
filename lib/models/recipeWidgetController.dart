import 'package:flutter/cupertino.dart';
import 'package:hfc/models/recipe.dart';

class RecipeWidgetController {
  final String? id;
  late bool isOpen = false;
  final RecipeModel recipe;
  RecipeWidgetController({
    this.id,
    required this.recipe
  });
  


  double getHeight() {
    if(isOpen == false){
      return 150.0;
    }
    return 370;
  }

  }
