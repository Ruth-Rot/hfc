import 'dart:convert';
import 'dart:math';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hfc/pages/home_page.dart';
import '../models/rate.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/recipe_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';
import 'messages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(User user, {super.key});

  @override
  State<StatefulWidget> createState() {
    return __ChatPageState();
  }
}

class __ChatPageState extends State<ChatPage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
        final user = FirebaseAuth.instance.currentUser!;


  List<Map<String, dynamic>> messages = [];


  @override
  Future<void> initState() async {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            title: const Text(
              "HFC Bot",
              style: TextStyle(color: Colors.white70, fontSize: 25),
            ),
            //centerTitle: true,
            backgroundColor: Colors.indigo.shade800,
            elevation: 0,
            // shadowColor: Colors.indigo.shade800,
            leading: returnBack(context),
            flexibleSpace: botAvatar(),
          ),
        ),
        body: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(reverse: false, flip: true),
              child: Container(
                height: 80,
                color: Colors.indigo.shade800,
              ),
            ),
            Expanded(child: Messages(messages: messages, )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              // color: Colors.indigo.shade800,
              child: Row(children: [
                Expanded(
                    child: Column(
                  children: [
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 5,
                      endIndent: 0,
                      color: Color.fromARGB(171, 158, 158, 158),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      controller: _controller,
                      style: const TextStyle(color: Colors.indigo),
                    ),
                  ],
                )),
                IconButton(
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.indigo.shade800,
                )
              ]),
            )
          ],
        ));
  }

   botAvatar() {
    return
  //    Align(
  //           alignment: Alignment.bottomRight,
  //           child: Row(
  //             children: [
  //               const SizedBox(
  //                 width: 270,
  //               ),
  //               Column(
  //                 children: [
  //                      const SizedBox(
  //                 height: 26,),
  //                   Container(
  //                     child: const CircleAvatar(
  //                       radius: 40,
  //                       backgroundColor: Colors.white70,
  //                       child: CircleAvatar(
  //                           radius: 50,
  //                           child: Image(
  //                               image:
  //                                   AssetImage("assets/images/splash_bot.png"))),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
   Transform.translate(
                offset:
                    Offset(100, 40),
                child:const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white70,
                        child: CircleAvatar(
                            radius: 60,
                            child: Image(
                                image:
                                    AssetImage("assets/images/splash_bot.png"))),
                      ));
   }

  IconButton returnBack(BuildContext context) {
    return IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
          );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        var mes =Message(text: DialogText(text: [text]));
        addMessage(mes, true);
      });
       
      var query = QueryInput(text: TextInput(text: text));
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: query);
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
    try{
      String text = message.text!.text![0];
      var dec = jsonDecode(text);
      RecipeModel req = RecipeModel.fromJson(dec);
      if (req.requset == "recipe") {
      print("hii");
       updateFireBase(req);
      }
     } on FormatException catch (e) //if not json:

    {
      }      
  }
   Future<void> updateFireBase(RecipeModel req) async {
      //add recipe for firebase:
     RecipeReposiontry().createRecipe(req);
     //add recommenstion suggest to user:
     UserModel userM = await UserReposiontry().getUserDetails(user.email!);
     RecipeModel recipeM = await RecipeReposiontry().getRecipeDetails(req.title);
     var rate = RateModel(like: true, userId: userM.getId(), recipeId: recipeM.getId());
    RateReposiontry().createRate(rate);
   }
}
