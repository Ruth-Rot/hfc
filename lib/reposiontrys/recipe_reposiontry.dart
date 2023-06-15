import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfc/models/recipe.dart';
import 'package:hfc/models/user.dart';

class RecipeReposiontry extends GetxController{
static RecipeReposiontry get instance => Get.find();

final _db = FirebaseFirestore.instance;

// createRecipe(RecipeModel recipe) async{
//   //check if the not recipe exist:

//   // add recipe:
//   await _db.collection("Recipes").add(recipe.toJson())
//  // .whenComplete(() =>
//   //  Get.snackbar("Success", "Your accont has been created.",
//   // snackPosition: SnackPosition.BOTTOM,
//   // backgroundColor: Colors.green.withOpacity(0.1),
//   // colorText:Colors.green),
//   //)
//   .catchError((error,stackTrace){
//   //  Get.snackbar("Error", "Something get wrong. Try again.",
//   // snackPosition: SnackPosition.BOTTOM,
//   // backgroundColor: Colors.redAccent.withOpacity(0.1),
//   // colorText:Colors.red);
//   print(error.toString());
//   });
// }


Future<RecipeModel> getRecipeDetails(String title) async{
  final snapshot= await _db.collection("Recipes").where("title",isEqualTo: title).get();
  final recipeData= snapshot.docs.map((e) => RecipeModel.fromSnapshot(e)).single;
  return recipeData;
}
Future<List<UserModel>> allRecipes(String email) async{
  final snapshot= await _db.collection("Users").get();
  final recipessData= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  return recipessData;
}
}