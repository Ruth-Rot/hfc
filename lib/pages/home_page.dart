import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hfc/common/custom_shape.dart';
import 'package:hfc/pages/chat_page.dart';
import 'package:hfc/pages/loader.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/widget/Header_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../headers/drawerHeader.dart';
import '../models/user.dart';
import '../reposiontrys/user_reposiontry.dart';
import 'google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __HomePageState();
  }
}

class __HomePageState extends State<HomePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  bool isUser = false;
  Image bot = Image(image: AssetImage('./assets/images/splash_bot.png'));
  late UserModel user;
  late ImageProvider profile;
  late String name = "";
  late String email = "";
  bool _isInitialValue = true;
  late AnimationController controller;
  var currentPage = DrawerSections.home;

 
  @override
  Widget build(BuildContext context) {
    //your code goes here
    //  Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => Loader()));
    Future.delayed(Duration.zero, () {
      UserReposiontry()
          .getUserDetails(FirebaseAuth.instance.currentUser!.email!)
          .then((instance) {
        user = instance;
        if (this.mounted) {
          setState(() {
            isUser = true;
            email = user.email;
            name = user.fullName;
            profile = NetworkImage(user.urlImage);
            // if(user.isSetup == false){
            //    Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => ChatPage()));
            // }
            //          Navigator.pop(context);
          });
        }
      });
    });
    //final user = FirebaseAuth.instance.currentUser!;
    //return buildContainer(context);
    return buildContainer(context);
  }

  Scaffold buildContainer(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 200,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          // leading: Container(
          //     alignment: Alignment.topLeft,
          //     child: IconButton(
          //       onPressed: () {
          //                    FirebaseAuth.instance.signOut();
          //         Navigator.pushReplacement(context,
          //             MaterialPageRoute(builder: (context) => LoginPage()));
          //       },
          //       icon: const Icon(Icons.arrow_back),
          //       color: Colors.white,
          //     )),
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
      body: Column(
        children: [
          // CircleAvatar(
          //   radius: 40,
          //   backgroundImage: NetworkImage(user.photoURL!),
          // ),
          // const SizedBox(height: 20,),

          emailText(),
        ],
      ),
      drawer: Drawer(
        //backgroundColor: Colors.amber,

        child: SingleChildScrollView(
            child: Container(
          child: Column(children: [mydrawerHeader(), myDrawerList()]),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatPage()))
        },
        child: ClipOval(
          child: bot,
        ),
      ),
    );
  }

  ClipOval floatingActionDesign() {
    if (isUser == true) {
      if (user.fillDetails == false) {
        return ClipOval(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            color: _isInitialValue ? Colors.blue : Colors.red,
            child: bot,
          ),
        );
      } else {
        return ClipOval(
          child: bot,
        );
      }
    } else {
      return ClipOval();
    }
  }

  emailText() {
    if (isUser == true) {
      return Text("logged us " + user.email,
          style: TextStyle(color: Colors.black, fontSize: 16));
    } else {
      return Container();
    }
  }

  Widget myDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(children: [
        menuItem(0, "Home", FontAwesomeIcons.house,
              currentPage == DrawerSections.home ? true : false),
         menuItem(1, "Progress", FontAwesomeIcons.chartLine,
              currentPage == DrawerSections.progress ? true : false),
          menuItem(2, "Saved Recipes", FontAwesomeIcons.bowlFood,
              currentPage == DrawerSections.saved_recipes ? true : false),
          menuItem(3, "Saved Menus",FontAwesomeIcons.tableColumns,
              currentPage == DrawerSections.saved_menus ? true : false),
       
          Divider(),
          menuItem(4, "Settings", FontAwesomeIcons.gear,
              currentPage == DrawerSections.settings ? true : false),
          menuItem(5, "About As", FontAwesomeIcons.circleInfo,
              currentPage == DrawerSections.about_as ? true : false),
          Divider(),
          menuItem(6, "Log Out", FontAwesomeIcons.doorOpen,
              currentPage == DrawerSections.logout ? true : false),
             ]),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color:  selected ? Colors.grey[300]: Colors.transparent,
      child: InkWell(
          onTap: () {
          Navigator.pop(context);
          setState(() {
             if (id == 0) {
              currentPage = DrawerSections.home;
             }
            if (id == 1) {
              currentPage = DrawerSections.progress;
            } else if (id == 2) {
              currentPage = DrawerSections.saved_recipes;
            } else if (id == 3) {
              currentPage = DrawerSections.saved_menus;
            } else if (id == 4) {
              currentPage = DrawerSections.settings;
            } else if (id == 5) {
              currentPage = DrawerSections.about_as;
            } else if (id == 6) {
              currentPage = DrawerSections.logout;
            }
          });
        },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(title,
                        style: TextStyle(color: Colors.black, fontSize: 16)))
              ],
            ),
          )),
    );
  }

  mydrawerHeader() {
    return Container(
      color: Colors.indigo,
      width: double.infinity,
      height: 250,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        profileCircle(),
        Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        Text(
          email,
          style: TextStyle(color: Colors.grey[200], fontSize: 16),
        ),
      ]),
    );
  }

  Container profileCircle() {
    if (isUser == true) {
      return Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 100,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   image: DecorationImage(image: profile)
          // ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: profile,
            backgroundColor: Colors.white,
          ));
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 80,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}

enum DrawerSections {
  home,
  progress,
  saved_recipes,
  saved_menus,
  settings,
  about_as,
  logout
}
