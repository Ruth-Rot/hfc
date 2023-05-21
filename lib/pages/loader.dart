import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation_rotation;
  late Animation<double> animation_radius_in;
  late Animation<double> animation_radius_out;

  final double initial_radius = 70.0;
  double radius = 50.0;
  double dot_radius = 15;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    animation_radius_out = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticIn)));
    animation_rotation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));
    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animation_radius_in.value * initial_radius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animation_radius_out.value * initial_radius;
        }
      });
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 100.0,
    //   height: 100.0,
    //   color: Colors.white,
    //   child: Center(
    //       child: RotationTransition(
    //     turns: animation_rotation,
    //     child: Stack(
    //       children: [
    //         //Dot(radius: 30.0, color: Colors.black12),
    //         Center(
    //           child: CircleAvatar(
    //                       radius: 50,
    //                       backgroundColor: Colors.white70,
    //                       child: CircleAvatar(
    //                           radius: 60,
    //                           child: Image(
    //                               image:
    //                                   AssetImage("assets/images/splash_bot.png")))),
    //         ),
    //         Transform.translate(
    //             offset: Offset(radius * cos(1+pi / 4), radius * sin(1+pi / 4)),
    //             child: Dot(radius: dot_radius, color: Colors.orange)),
    //         Transform.translate(
    //             offset:
    //                 Offset(radius * cos(2+ pi / 4), radius * sin(2 + pi / 4)),
    //             child: Dot(radius: dot_radius, color: Colors.lightGreenAccent)),
    //         Transform.translate(
    //             offset:
    //                 Offset(radius * cos(3 + pi / 4), radius * sin(3 + pi / 4)),
    //             child: Dot(radius: dot_radius, color: Colors.blue)),
    //         Transform.translate(
    //             offset:
    //                 Offset(radius * cos(4 + pi / 4), radius * sin(4 + pi / 4)),
    //             child: Dot(radius: dot_radius, color: Colors.amberAccent)),
    //         Transform.translate(
    //             offset:
    //                 Offset(radius * cos(5 + pi / 4), radius * sin(5 + pi / 4)),
    //             child: Dot(radius:dot_radius, color: Colors.purple)),
    //         Transform.translate(
    //             offset:
    //                 Offset(radius * cos(6 + pi / 4), radius * sin(6 + pi / 4)),
    //             child: Dot(radius: dot_radius, color: Colors.blueAccent)),
    //         // Transform.translate(
    //         //     offset:
    //         //         Offset(radius * cos(7 + pi / 4), radius * sin(7 + pi / 4)),
    //         //     child: Dot(radius: 5.0, color: Colors.greenAccent)),
    //         // Transform.translate(
    //         //     offset:
    //         //         Offset(radius * cos(7.2 + pi / 4), radius * sin(7.2 + pi / 4)),
    //         //     child: Dot(radius: 5.0, color: Colors.redAccent)),
    //       ],
    //     ),
    //   )),
    // );
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //  CircleAvatar(
          //   backgroundColor: Colors.transparent,
          //                     radius: 60,
          //                     child: Image(
          //                         image:
          //                             AssetImage("assets/images/splash_bot.png"))),
           LoadingAnimationWidget.newtonCradle(
              size: 200,
              color: Colors.white,
            ),

            AnimatedTextKit(
  animatedTexts: [
    TypewriterAnimatedText(
      "Loading",textStyle: TextStyle( color: Colors.white,fontSize: 30,),
      speed: const Duration(milliseconds: 1000),
    ),
  ],
  
  totalRepeatCount: 4,
  pause: const Duration(milliseconds: 700),
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
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

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({required this.radius, required this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
      ),
    );
  }
}
