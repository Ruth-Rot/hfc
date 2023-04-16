import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hfc/common/theme_helper.dart';
import 'package:hfc/pages/profile_page.dart';
import 'package:hfc/pages/register_page.dart';

import 'forgot_password_page.dart';
import 'home_page.dart';
import 'widget/Header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              //login form
              child: Column(children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign in into your account',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30.0),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextField(
                          decoration: ThemeHelper().textInputDecoration(
                              "UserName", "Enter your user name"),
                          controller: emailController,
                        ),
                        const SizedBox(height: 30.0),
                        TextField(
                          obscureText: true,
                          decoration: ThemeHelper().textInputDecoration(
                              "Password", "Enter your password"),
                              controller: passwordController,
                        ),
                        const SizedBox(height: 15.0),
                         Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                },
                                child: const Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                ),
                              ),
                            ),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Sign In".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () => {
                              FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()),
                              //if the login sucsses - redirct to profile page
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()))
                              //print(emailController.text.trim())
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text.rich(TextSpan(children: [
                            const TextSpan(text: "Don\'t have account? "),
                            TextSpan(
                                text: "Create",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                  style:  TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary))
                          ])),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ])));
  }
}
