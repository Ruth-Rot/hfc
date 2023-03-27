import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/profile_page.dart';
import 'package:hfc/pages/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}

class Login extends StatelessWidget {

// green: Color.fromARGB(156, 156, 204, 101);
// pink: Color.fromARGB(255, 225, 171, 145);

  // Color _primaryColor = Colors.teal;
  // Color _accentColor = Colors.tealAccent;
  //Color _primaryColor= HexColor('#D44CF6');
  final Color _accentColor= const Color.fromARGB(255, 225, 171, 145);
  // final Color _primaryColor =  const Color.fromARGB(156, 156, 204, 101);
  final MaterialColor _primaryColor = const MaterialColor(0x9CCC65, <int, Color>
  {
         50: Color(0x9CCC65),
         100: Color(0x9CCC65),
         200: Color(0x9CCC65),
         300: Color(0x9CCC65),
         400: Color(0x9CCC65),
         500: Color(0x9CCC65),
         600: Color(0x9CCC65),
         700: Color(0x9CCC65),
         800: Color(0x9CCC65),
         900: Color(0x9CCC65),
  }
  );



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
       primaryColor: _primaryColor,
       scaffoldBackgroundColor: Colors.grey.shade100,
       colorScheme: ColorScheme.fromSwatch(primarySwatch:_primaryColor).copyWith(secondary: _accentColor),
      ),
      home:
       const SplashScreen(title: 'HFC Login'),
     
    );
  }
}
