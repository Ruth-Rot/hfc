import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../headers/circle_header.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      circleHeader(
          context,
          const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "About as",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              ]))
              //text
                  ])));
  }
}
