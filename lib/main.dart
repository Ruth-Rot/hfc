import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hfc/pages/google_sign_in.dart';
import 'package:hfc/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken = await messaging.getToken();
  print('FCM Token: $fcmToken');
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(const Login());
}

class Login extends StatelessWidget {
// green: Color.fromARGB(156, 156, 204, 101);
// pink: Color.fromARGB(255, 225, 171, 145);

  // Color _primaryColor = Colors.teal;
  // Color _accentColor = Colors.tealAccent;
  //Color _primaryColor= HexColor('#D44CF6');
  // final Color _accentColor= const Color.fromARGB(255, 225, 171, 145);
  // final Color _primaryColor =  const Color.fromARGB(156, 156, 204, 101);
  final MaterialColor _primaryColor = Colors.cyan;
  final Color _accentColor = Colors.indigoAccent;

  const Login({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        // ChangeNotifierProvider(
        //   create: (context) => GoogleSignInProvider(),
        //   child:
        MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: _primaryColor)
            .copyWith(secondary: _accentColor),
      ),
      home: const SplashScreen(title: 'HFC Login'),
      //HomePage(),
    )
        // )
        ;
  }
}
