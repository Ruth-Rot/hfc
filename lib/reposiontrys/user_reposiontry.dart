import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hfc/models/user.dart';

class UserReposiontry extends GetxController {
  static UserReposiontry get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser(String email) async {
    final snapshot = await _db.collection("Users").get();
    final usersData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return usersData;
  }

  updateSessionId(String sessionId, String email) async {
// Get a new write batch
    final batch = _db.batch();

// Set the value of 'NYC'
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"sessionId": sessionId});

    batch.commit();
  }

  void saveMessages(List<Map<String, dynamic>> messages, String email) async {
    // Get a new write batch
    final batch = _db.batch();

// Set the value of 'NYC'
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    var userRef = _db.collection("Users").doc(userData.id);
   // buildMessagesToSave(messages);
    batch.update(userRef, {"convresation": buildMessagesToSave(messages)});

    batch.commit();
  }
}

buildMessagesToSave(List<Map<String, dynamic>> messages) {
  List build = [];
  for (var mes in messages) {
    bool flag =  mes['isUserMessage'];
   // var t =  await mes['message'].text;
    String text =  mes['message'].text.text[0] as String;
    Map m = Map();
    m["isUser"] = flag;
    m["text"]= text;
    build.add(m.toString());
  }
  return build;
}
