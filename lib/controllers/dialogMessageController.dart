import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../reposiontrys/user_reposiontry.dart';


class DialogMessageController  {
  Key? key;
  late bool isWaitedMessages = false;
  late bool isWaitedRecipe = false;
  late var recipeMessage;
  late bool startSendMeal = false;
  late bool sentPlanMeal = false;
 // late int counterMeal = 0;
  late Map<String,dynamic> meal_plan ={};
  late String meal_plan_text = "";



  DialogMessageController();

  listenToServer() async {
    var mes;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      mes = message.data;
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      else{
        if( message.data['request'] == 'recipe'){
          recipeMessage = message.data;
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
