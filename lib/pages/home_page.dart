import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:bottom_bar_matu/bottom_bar_label_slide/bottom_bar_label_slide.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hfc/common/custom_shape.dart';
import 'package:hfc/pages/MyRecipePage.dart';
import 'package:hfc/pages/chat_page.dart';
import 'package:hfc/pages/diaryPage.dart';
import 'package:hfc/pages/goalsPage.dart';
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
  var currentPage = DrawerSections.diary;

  var _index = 0;

  @override
  Widget build(BuildContext context) {
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
    var container;
    if (currentPage == DrawerSections.diary) {
      container = DiaryPage();
    } else if (currentPage == DrawerSections.progress) {
      container = GoalsPage();
    } else if (currentPage == DrawerSections.saved_recipes) {
      container = MyRecipePage();
    }
   
    return Scaffold(
      appBar: AppBar(
        //  toolbarHeight: 200,
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: container,
      drawer: Drawer(
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
        menuItem(1, "Diary", FontAwesomeIcons.calendar,
            currentPage == DrawerSections.diary ? true : false),
        menuItem(2, "Progress", FontAwesomeIcons.chartLine,
            currentPage == DrawerSections.progress ? true : false),
        menuItem(3, "Saved Recipes", FontAwesomeIcons.bowlFood,
            currentPage == DrawerSections.saved_recipes ? true : false),
        menuItem(4, "Saved Menus", FontAwesomeIcons.tableColumns,
            currentPage == DrawerSections.saved_menus ? true : false),
        // Divider(),
        // menuItem(4, "Settings", FontAwesomeIcons.gear,
        //     currentPage == DrawerSections.settings ? true : false),
        // menuItem(5, "About As", FontAwesomeIcons.circleInfo,
        //     currentPage == DrawerSections.about_as ? true : false),
        Divider(),
        menuItem(5, "Log Out", FontAwesomeIcons.doorOpen,
            currentPage == DrawerSections.logout ? true : false),
      ]),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected ) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
          onTap: 
          () {
            Navigator.pop(context);
               if (id == 5) {
                               FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                 // currentPage = DrawerSections.logout;
                }
            if (this.mounted) {
              setState(() {
                if (id == 1) {
                  currentPage = DrawerSections.diary;
                }
                if (id == 2) {
                  currentPage = DrawerSections.progress;
                } else if (id == 3) {
                  currentPage = DrawerSections.saved_recipes;
                } else if (id == 4) {
                  currentPage = DrawerSections.saved_menus;}
               });
          }
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

enum DrawerSections { diary, progress, saved_recipes, saved_menus, logout }
