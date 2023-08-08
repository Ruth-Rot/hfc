import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hfc/models/recipe.dart';
import 'package:hfc/models/user.dart';

class RecipeReposiontry{
 
final _db = FirebaseFirestore.instance;

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