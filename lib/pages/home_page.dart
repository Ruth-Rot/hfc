import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hfc/common/custom_shape.dart';
import 'package:hfc/pages/chat_page.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/widget/Header_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __HomePageState();
  }
}

class __HomePageState extends State<HomePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home Page",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      //   elevation: 0.5,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   flexibleSpace:Container(
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //             colors: <Color>[ Color.fromARGB(156, 156, 204, 101), Theme.of(context).colorScheme.secondary,]
      //         )
      //     ),
      //   ),
      // ),
      appBar: AppBar(
          toolbarHeight: 200,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          flexibleSpace: ClipPath(
              clipper: CustomShape(),
              child: Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      const SizedBox(height: 20.0),
                      Center(
                        child: CircularPercentIndicator(
                            radius: 40,
                            lineWidth: 8.0,
                            backgroundColor: Colors.white,
                            percent: 0.60,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor:
                                Theme.of(context).colorScheme.secondary,
                            animation: true,
                            center: Column(
                              children: const [
                                SizedBox(height: 15.0),
                                Text(
                                  "865",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "kcal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  "Remaining",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          const SizedBox(width: 50.0),
                          Container(
                              child: Column(
                            children: const [
                              SizedBox(height: 15.0),
                              Text(
                                "1238",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "kcal Consumed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              
                            ],
                          )),
                          const SizedBox(width: 120.0),
                          Container(
                              child: Column(
                            children: const [
                              SizedBox(height: 15.0),
                              Text(
                                "2103",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Daily kcal Goal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 50.0),

                            ],
                          ))
                        
                        ],
                      )
                    ],
                  )))),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => { Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage()))},
        child: const ClipOval(
                child: Image(image: AssetImage('./assets/images/splash_bot.png')),
      ),
      ),
    );
  }
}
