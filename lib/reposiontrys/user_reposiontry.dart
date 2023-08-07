import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hfc/models/day.dart';
import 'package:hfc/models/user.dart';

class UserReposiontry {

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    try{
   UserModel exist =  await getUserDetails(user.email);
   if(exist.email != "") {
     print("user exist");
    }
    }
    catch(e){
    await _db
        .collection("Users")
        .add(user.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
         throw Exception('Error in create user file');
    });
    }
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

    // get the user doc
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    //update the sessionId of user in this session
    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"sessionId": sessionId});

    batch.commit();
  }

  updateGetNotification(String email) async {
  // Get a new write batch
    final batch = _db.batch();

    // get the user doc
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    //update the sessionId of user in this session
    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"have_notification": false});

    batch.commit();
  }

  void saveMessages(List<Map<String, dynamic>> messages, String email) async {
    // Get a new write batch
    final batch = _db.batch();

    // get the user doc
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    //update the conversation of the user doc
    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"conversation": buildMessagesToSave(messages)});

    batch.commit();
  }

   void updateDiary(Map<String, Day> days, String email)async {
// Get a new write batch
    final batch = _db.batch();

    // get the user doc
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    //update the sessionId of user in this session
    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"diary": buildDaysToSave(days)});

    batch.commit();

}

buildMessagesToSave(List<Map<String, dynamic>> messages) {
  List build = [];
  for (var mes in messages) {
    bool flag = mes['isUserMessage'];
    var text="";
    if (mes['message'] is String) {
      text = mes['message'];
    } else {
      text = mes['message'].text.text[0];
    }
    var json = {"isUser": flag, "text": text};

    build.add(json);
  }
  return build;
}

buildDaysToSave (Map<String, Day> days){
Map build ={};
for(String key in days.keys){
build[key] = days[key]!.toJson();
}
return build;
}

  void updateFCMToken(String? fcmToken, String email) async{
    // Get a new write batch
    final batch = _db.batch();

    // get the user doc
    var snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    //update the sessionId of user in this session
    var userRef = _db.collection("Users").doc(userData.id);
    batch.update(userRef, {"token": fcmToken});

    batch.commit();
  }
}