import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfc/models/recipe.dart';
import 'package:hfc/models/user.dart';

import '../models/rate.dart';

class RateReposiontry extends GetxController {
  static RateReposiontry get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createRate(RateModel rate) async {
    var snapshot = await _db
        .collection("Rate")
        .where("recipeId", isEqualTo: rate.recipeId)
        .where("userId", isEqualTo: rate.userId)
        .get();
    if(snapshot.docs.isEmpty){
    await _db
        .collection("Rate")
        .add(rate.toJson())
      
        .catchError((error, stackTrace) {
     
      print(error.toString());
    });
    }
    else{
      updateRate(rate.like, rate.userId, rate.recipeId);
    }
  }
// Future<RateModel> getRateDetails(String title) async{
//   final snapshot= await _db.collection("Recipes").where("title",isEqualTo: title).get();
//   final rateData= snapshot.docs.map((e) => RateModel.fromSnapshot(e)).single;
//   return rateData;
// }
// Future<List<RateModel>> allUser(String email) async{
//   final snapshot= await _db.collection("Users").get();
//   final ratesData= snapshot.docs.map((e) => RateModel.fromSnapshot(e)).toList();
//   return ratesData;
// }

  Future<List<RecipeModel>> allLikedRecipes(String email) async {
    List<RecipeModel> recipes = [];
    final userSnapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    String userDoc = userSnapshot.docs[0].id;
    final rateSnapshot = await _db
        .collection("Rate")
        .where("userId", isEqualTo: userDoc)
        .where("like", isEqualTo: true)
        .get();

    final rateData =
        rateSnapshot.docs.map((e) => RateModel.fromSnapshot(e)).toList();
    for (RateModel rate in rateData) {
      final docRef = _db.collection("Recipes").doc(rate.recipeId);
      docRef.get().then((recipe) {
        RecipeModel recipeModel = RecipeModel.fromSnapshot(recipe);
        recipes.add(recipeModel);
      });
    }
    //return recipessData;
    return recipes;
  }

  updateRate(bool like, String userId, String recipeId) async {
// Get a new write batch
    final batch = _db.batch();

// Set the value of 'NYC'
    var snapshot = await _db
        .collection("Rate")
        .where("recipeId", isEqualTo: recipeId)
        .where("userId", isEqualTo: userId)
        .get();
    final rateData = snapshot.docs.map((e) => RateModel.fromSnapshot(e)).single;

    var rateRef = _db.collection("Rate").doc(rateData.id);
    batch.update(rateRef, {"like": like});

    batch.commit();
  }
}
