import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double radius = 50.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Stack(
          children: [
            Column(
                        mainAxisAlignment: MainAxisAlignment.center,

              children: [
               const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child:
                        Image(image: AssetImage("assets/images/splash_bot.png"))),

                         LoadingAnimationWidget.newtonCradle(
              size: 200,
              color: Colors.white,
            ),
              ],
            ),
           
            Positioned(
              bottom: 400,
              left: 50,
              child: AnimatedTextKit(
                
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Loading",
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    speed: const Duration(milliseconds: 800),
                  ),
                ],
                totalRepeatCount: 4,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Loader());
  }
}
