import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hfc/pages/splash_screen.dart';


void main() async{// Needed to enable background API in the killed state.
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationController.initializeLocalNotifications();

  await Firebase.initializeApp(); 
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
  final MaterialColor _primaryColor =Colors.cyan;
   final Color _accentColor= Colors.indigoAccent;

   const Login({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return 
    // ChangeNotifierProvider(
    //   create: (context) => GoogleSignInProvider(),
    //   child: 
    
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login',
        theme: ThemeData(
         primaryColor: _primaryColor,
         scaffoldBackgroundColor: Colors.grey.shade100,
         colorScheme: ColorScheme.fromSwatch(primarySwatch:_primaryColor).copyWith(secondary: _accentColor),
        ),
        home:
         const SplashScreen(title: 'HFC Login'),
        //HomePage(),
      )
   // )
    ;
  }
}
