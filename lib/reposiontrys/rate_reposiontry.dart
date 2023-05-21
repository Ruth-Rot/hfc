import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfc/models/recipe.dart';
import 'package:hfc/models/user.dart';

import '../models/rate.dart';

class RateReposiontry extends GetxController{
static RateReposiontry get instance => Get.find();

final _db = FirebaseFirestore.instance;

createRate(RateModel rate) async{
  await _db.collection("Rate").add(rate.toJson())
 // .whenComplete(() =>
  //  Get.snackbar("Success", "Your accont has been created.",
  // snackPosition: SnackPosition.BOTTOM,
  // backgroundColor: Colors.green.withOpacity(0.1),
  // colorText:Colors.green),
  //)
  .catchError((error,stackTrace){
  //  Get.snackbar("Error", "Something get wrong. Try again.",
  // snackPosition: SnackPosition.BOTTOM,
  // backgroundColor: Colors.redAccent.withOpacity(0.1),
  // colorText:Colors.red);
  print(error.toString());
  });
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

updateRate(bool like,String userId,String recipeId)async{
// Get a new write batch
final batch = _db.batch();

// Set the value of 'NYC'
var snapshot =await _db.collection("Rate").where("recipeId",isEqualTo: recipeId).where("userId",isEqualTo: userId).get();
final rateData= snapshot.docs.map((e) => RateModel.fromSnapshot(e)).single;

var rateRef = _db.collection("Rate").doc(rateData.id);
batch.update(rateRef, {"like": like});

batch.commit();
}
}