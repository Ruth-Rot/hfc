import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfc/models/user.dart';

class UserReposiontry extends GetxController{
static UserReposiontry get instance => Get.find();

final _db = FirebaseFirestore.instance;

createUser(UserModel user) async{
  await _db.collection("Users").add(user.toJson())
  //.whenComplete(() => 
  // Get.snackbar("Success", "Your accont has been created.",
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
Future<UserModel> getUserDetails(String email) async{
  final snapshot= await _db.collection("Users").where("email",isEqualTo: email).get();
  final userData= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
  return userData;
}
Future<List<UserModel>> allUser(String email) async{
  final snapshot= await _db.collection("Users").get();
  final usersData= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  return usersData;
}
}