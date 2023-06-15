import 'package:flutter/material.dart';
import 'package:hfc/models/recipe.dart';

import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';

class ProgressPage extends StatefulWidget {
  final UserModel userModel;
  final UserReposiontry userReposiontry;

  ProgressPage(
      {Key? key,
      required this.userModel,
      required UserReposiontry this.userReposiontry})
      : super(key: key);

  @override
  __ProgressPageState createState() {
    return __ProgressPageState();
  }
}

class __ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    
    if (widget.userModel.fillDetails == false) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Text(
              "You haven't fill your personal details yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox( height: 300,child: Image(image: AssetImage('./assets/images/splash_bot.png'))),
            SizedBox(height: 30,),
            Text(
                  "Fill your details in the chat bot",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ))
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text("progress Page"),
        ),
      );
    }
  }
}
