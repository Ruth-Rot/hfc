import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/recipe.dart';
import 'package:hfc/pages/chat_page.dart';
import 'package:hfc/pages/diaryPage.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/myRecipePage.dart';
import 'package:hfc/pages/progressPage.dart';
import '../controllers/dialogMessageController.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';

class HomePage extends StatefulWidget {
  int Askpermission = 0;
  List<RecipeModel> recipes = [];

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
  var container;
  var _index = 0;
  UserReposiontry userReposiontry = UserReposiontry();
  DialogMessageController dialogMessageController = DialogMessageController();
  RateReposiontry rateRep = RateReposiontry();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      userReposiontry
          .getUserDetails(FirebaseAuth.instance.currentUser!.email!)
          .then((instance) {
        user = instance;

        if (widget.Askpermission == 0) {
          widget.Askpermission = 1;
          dialogMessageController.updateMessagingToken(
              userReposiontry, user.email);
          rateRep
              .allLikedRecipes(user.email)
              .then((list) => widget.recipes = list);
        }

        if (this.mounted) {
          setState(() {
            //   dialogMessageController.listenToServer();

            isUser = true;
            email = user.email;
            name = user.fullName;
            profile = NetworkImage(user.urlImage);
            if (currentPage == DrawerSections.diary) {
              container =
                  DiaryPage(userModel: user, userReposiontry: userReposiontry);
            } else if (currentPage == DrawerSections.progress) {
              container = ProgressPage(
                  userModel: user, userReposiontry: userReposiontry);
            } else if (currentPage == DrawerSections.saved_recipes) {
              container = MyRecipePage(
                recipes: widget.recipes,
              );
            } else if (currentPage == DrawerSections.about_as) {}
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
                if (isUser == true)
                  {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                user: user,
                                userReposiontry: userReposiontry,
                                dialogController: dialogMessageController)))
                  }
              },
          child: Stack(children: [
            ClipOval(
              child: bot,
            ),
            dialogMessageController.isWaitedMessages == true ||
                    (isUser == true && user.fillDetails == false)
                ? notificationBell()
                : SizedBox()
          ])),
    );
  }

  Positioned notificationBell() {
    return Positioned(
        bottom: 0,
        right: 0,
        height: 18,
        width: 18,
        child: ClipOval(
          child: Material(
            color: Colors.green[200],
            child: Center(
              child: ShakeAnimatedWidget(
                  //enabled: this._enabled,
                  duration: const Duration(milliseconds: 2000),
                  shakeAngle: Rotation.deg(z: 30),
                  curve: Curves.linear,
                  child: const FaIcon(
                    FontAwesomeIcons.bell,
                    color: Colors.white,
                    size: 12,
                  )),
            ),
          ),
        ));
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

        // Divider(),
        // menuItem(4, "Settings", FontAwesomeIcons.gear,
        //     currentPage == DrawerSections.settings ? true : false),
        // menuItem(5, "About As", FontAwesomeIcons.circleInfo,
        //     currentPage == DrawerSections.about_as ? true : false),
        Divider(),
        menuItem(4, "About As", FontAwesomeIcons.circleInfo,
            currentPage == DrawerSections.logout ? true : false),
        LogOut(5, "Log Out", FontAwesomeIcons.doorOpen,
            currentPage == DrawerSections.logout ? true : false),
      ]),
    );
  }

  LogOut(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
          onTap: () {
            Navigator.pop(context);

            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
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

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (id == 6) {
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
                  currentPage = DrawerSections.about_as;
                }
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

enum DrawerSections { diary, progress, saved_recipes, about_as, logout }
