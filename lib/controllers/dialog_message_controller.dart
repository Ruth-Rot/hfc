import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../reposiontrys/user_reposiontry.dart';

class DialogMessageController {
  Key? key;

  //notifications:
  late bool isWaitedNotification = false;
  late String notificationMessage = "";

  //recipe:
  late bool waitForRecipe = false;
  late String waitForRecipeMessage = "";
  late bool isWaitedRecipe = false;
  late var recipeCard;
  late bool isfailrecipe = false;
  late String failureTextRecipe="";

  //meals plan:
  late bool waitForMeal = false;
  late String waitForMealMessage = "";
  late bool startSendMeal = false;
  late bool sentPlanMeal = false;
  late Map<String, dynamic> mealPlan = {};
  late String mealPlanTextStart = "";
  late String mealPlanTextEnd = "";
    late bool isfailPlan = false;
  late String failureTextPlan="";
  

  DialogMessageController();


 



  insertNotification(mes) {
    isWaitedNotification = true;
    notificationMessage = mes;
  }

  notifiactionReset() {
    isWaitedNotification = false;
    notificationMessage = "";
  }

 

  listenToServer() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      } else {
        if (message.data['request'] == 'recipe') {
          recipeCard = message.data;
          isWaitedRecipe = true;
        }
      }
    });
  }

  updateMessagingToken(UserReposiontry rep, String email) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcmToken = await messaging.getToken();
    print('FCM Token: $fcmToken');
    rep.updateFCMToken(fcmToken, email);
    //save token in firebase??

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
