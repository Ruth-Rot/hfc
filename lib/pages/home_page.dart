import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/recipe.dart';
import 'package:hfc/pages/about_us.dart';
import 'package:hfc/pages/chat_page.dart';
import 'package:hfc/pages/diary_page.dart';
import 'package:hfc/pages/login_page.dart';
import 'package:hfc/pages/my_recipe_page.dart';
import 'package:hfc/pages/progress_page.dart';
import '../controllers/dialog_message_controller.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';

class HomePage extends StatefulWidget {
  late int _askPermission = 0;
  late List<RecipeModel> recipes = [];

  HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return __HomePageState();
  }
}

class __HomePageState extends State<HomePage> {
  bool isUser = false;
  Image bot = const Image(image: AssetImage('./assets/images/splash_bot.png'));
  late UserModel user;
  late ImageProvider profile;
  late String name = "";
  late String email = "";
  late AnimationController controller;
  var currentPage = DrawerSections.diary;
  late Widget pageWidget;
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

        if (widget._askPermission == 0) {
          widget._askPermission = 1;
          dialogMessageController.updateMessagingToken(
              userReposiontry, user.email);
          rateRep
              .allLikedRecipes(user.email)
              .then((list) => widget.recipes = list);
        }

        if (mounted) {
          setState(() {
            // dialogMessageController.listenToServer();
            //update user init:
            email = user.email;
            name = user.fullName;
            profile = NetworkImage(user.urlImage);
            //connect the widgets to home page
            if (currentPage == DrawerSections.diary) {
              pageWidget =
                  DiaryPage(userModel: user, userReposiontry: userReposiontry);
            } else if (currentPage == DrawerSections.progress) {
              pageWidget = ProgressPage(
                  userModel: user, userReposiontry: userReposiontry);
            } else if (currentPage == DrawerSections.savedRecipes) {
              pageWidget = MyRecipePage(
                recipes: widget.recipes,
              );
            } else if (currentPage == DrawerSections.aboutAs) {
              pageWidget =const AboutUs();
            }
          isUser = true;

          });
        }
      });
    });
    return buildPageWidget(context);
  }

  Scaffold buildPageWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isUser == true? pageWidget: Container(),
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(children: [mydrawerHeader(), myDrawerList()])),
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
                : const SizedBox()
          ])),
    );
  }

//a bell that "ring" when the bot have a message!
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

// side menu list:
  Widget myDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(children: [
        menuItem(1, "Diary", FontAwesomeIcons.calendar,
            currentPage == DrawerSections.diary ? true : false),
        menuItem(2, "Progress", FontAwesomeIcons.chartLine,
            currentPage == DrawerSections.progress ? true : false),
        menuItem(3, "Saved Recipes", FontAwesomeIcons.bowlFood,
            currentPage == DrawerSections.savedRecipes ? true : false),
        const Divider(),
        menuItem(4, "About As", FontAwesomeIcons.circleInfo,
            currentPage == DrawerSections.aboutAs ? true : false),
        logOut(5, "Log Out", FontAwesomeIcons.doorOpen,
            currentPage == DrawerSections.logout ? true : false),
      ]),
    );
  }

//log out menu option:
  logOut(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)))
              ],
            ),
          )),
    );
  }

//handle choose page from menu:
  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (mounted) {
              setState(() {
                if (id == 1) {
                  currentPage = DrawerSections.diary;
                } else if (id == 2) {
                  currentPage = DrawerSections.progress;
                } else if (id == 3) {
                  currentPage = DrawerSections.savedRecipes;
                } else if (id == 4) {
                  currentPage = DrawerSections.aboutAs;
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
                        style: const TextStyle(color: Colors.black, fontSize: 16)))
              ],
            ),
          )),
    );
  }

// header of menu list with user details
  mydrawerHeader() {
    return Container(
      color: Colors.indigo,
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        profileCircle(),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
        Text(
          email,
          style: TextStyle(color: Colors.grey[200], fontSize: 16),
        ),
      ]),
    );
  }

//oval profile image 
  Container profileCircle() {
    if (isUser == true) {
      return Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 100,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: profile,
            backgroundColor: Colors.white,
          ));
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 80,
        child:const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}

enum DrawerSections {diary, progress, savedRecipes, aboutAs, logout}
