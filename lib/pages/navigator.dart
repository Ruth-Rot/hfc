import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/register_page.dart';

class NavigatorAuth extends StatelessWidget {
    @override
    Widget build(BuildContext context)=>
    Scaffold(
      body:  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
          else if(snapshot.hasData){
            return HomePage();
          }
          else if(snapshot.hasError){
            return Center(child: Text('Something went wrong!'));
          }
          else{
            return LoginPage();
          }
        },
    ),
    );
}