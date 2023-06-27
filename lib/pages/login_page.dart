import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hfc/common/theme_helper.dart';
import 'package:hfc/pages/register_page.dart';
import '../common/show_alert.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import '../headers/start_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 150;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passToggle = true;
  bool _errorS = false;

  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(children: [
          SizedBox(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, false, Icons.login_rounded),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                //login form
                child: Column(children: [
                  const SizedBox(height: 100),
                  botIcon(),
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
                          emailField(),
                          const SizedBox(height: 30.0),
                          passwordField(),
                          const SizedBox(height: 15.0),
                          forgotPassword(context),
                          logInButton(context),
                          registerLink(context),
                        ],
                      )),
                ]),
              ),
              showAlert(_errorS,_error)
            ],
          ),
        ])));
  }

  //hyperlink to register page
  Container registerLink(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text.rich(TextSpan(children: [
        const TextSpan(text: "Not a member? "),
        TextSpan(
            text: "Register now",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationPage()));
              },
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)),
      ])),
    );
  }

//log in button:
  Container logInButton(BuildContext context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            "Log In".toUpperCase(),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () {
          // check if the form valid:
          if (_formKey.currentState!.validate()) {
            // show process snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Processing Data'),
                  duration: Duration(milliseconds: 1200)),
            );
            // try login:
            login(emailController.text.trim(), passwordController.text.trim(),
                context);
          }
        },
      ),
    );
  }

//forgt Password hyperlink
  Container forgotPassword(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          );
        },
        child: const Text(
          "Forgot your password?",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

// password field
  TextFormField passwordField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: passToggle,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter password";
        }
        if (value.length < 6) {
          return "Password should be more then 6 characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: const Icon(Icons.fingerprint_outlined),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        suffixIcon: InkWell(
          onTap: () {
            if (mounted) {
              setState(() {
                passToggle = !passToggle;
              });
            }
          },
          child: Icon(
              passToggle ? Icons.visibility_outlined : Icons.visibility_off),
        ),
      ),
      controller: passwordController,
    );
  }

// email form field:
  TextFormField emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: ThemeHelper().textInputDecoration(
          "Email", "Enter your email", const Icon(Icons.email_outlined)),
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter email";
        }
        bool emailValidator =
            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
        if (!emailValidator) {
          return "Enter Valid email";
        }
        return null;
      },
    );
  }

//login button:
  login(email, password, context) async {
    try {
      //try connect:
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //if succseed:
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorS = true;
          _error = e.message!;
        });
      }
    }
  }


//bot icon:
  botIcon() {
    return const Stack(children: [
      Image(
    height: 150,
    image: AssetImage("assets/images/splash_bot.png"),
      ),
    ]);
  }
}
