import 'dart:convert';
import 'dart:math';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/reposiontrys/dialog_reposiontry.dart';
import '../models/rate.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/recipe_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';
import 'messages.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return __ChatPageState();
  }
}

class __ChatPageState extends State<ChatPage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  //final userFire = FirebaseAuth.instance.currentUser!;
  late UserModel user;
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> previous_messages = [];

  bool isUser = false;

  var isOnce = true;

  @override
  void initState() {
    UserReposiontry()
        .getUserDetails(FirebaseAuth.instance.currentUser!.email!)
        .then((instance) {
      user = instance;
      DialogReposiontry().createDialogRep().then((ins) {
        dialogFlowtter = ins;
        UserReposiontry()
            .updateSessionId(dialogFlowtter.sessionId, user.email)
            .then((instance) {
          if (this.mounted) {
            setState(() {
              isUser = true;
              buildPreviousMessages(user.conversation);

              // previous_messages = buildPreviousMessages(user.convresation);
            });
          }
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkStart();


// final channel = IOWebSocketChannel.connect('https://293b-46-117-106-176.ngrok-free.app');

// // Receive messages from the server
// channel.stream.listen((message) {
//   print('Received message from server: $message');
//});
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
            Expanded(
                child: Messages(
              messages: messages,
              previous_messages: previous_messages,
            )),
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
            offset: Offset(100, 40),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white70,
              child: CircleAvatar(
                  radius: 60,
                  child:
                      Image(image: AssetImage("assets/images/splash_bot.png"))),
            ));
  }

  IconButton returnBack(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white70,
      ),
      onPressed: () {
        UserReposiontry().saveMessages(previous_messages+messages, user.email);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      if (this.mounted) {
        setState(() {
          var mes = Message(text: DialogText(text: [text]));
          addMessage(mes, true);
        });
      }

      var query = QueryInput(text: TextInput(text: text));
      DetectIntentResponse response =
          await dialogFlowtter.detectIntent(queryInput: query);
      if (response.message == null) return;
      if (this.mounted) {
        setState(() {
          addMessage(response.message!);
        });
      }
    }
  }

  fillDetails() async {
    var query = QueryInput(text: TextInput(text: 'personal details'));
    DetectIntentResponse response =
        await dialogFlowtter.detectIntent(queryInput: query);
    if (this.mounted) {
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
    //}
  }


  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
    try {
      String text = message.text!.text![0];
      var dec = jsonDecode(text.toString());
      if (dec is Map<String, dynamic>) {
        RecipeModel req = RecipeModel.fromJson(dec);
        if (req.requset == "recipe") {
          updateFireBase(req);
        }
      }
    } on FormatException catch (e) //if not json:
    {
    } on Exception catch (e) {}
  }

  Future<void> updateFireBase(RecipeModel req) async {
    //add recipe for firebase:
    RecipeReposiontry().createRecipe(req);
    //add recommenstion suggest to user:
    RecipeModel recipeM = await RecipeReposiontry().getRecipeDetails(req.title);
    var rate =
        RateModel(like: true, userId: user.getId(), recipeId: recipeM.getId());
    RateReposiontry().createRate(rate);
  }

  checkStart() async {
    if (isUser == true) {
      if (user.fillDetails == false && isOnce == true) {
        fillDetails();
        isOnce = false;
      }
    }
  }

  buildPreviousMessages(var convresation) {
    if (convresation != "") {
      // List valueMap = jsonDecode(convresation).toList();
      for (var value in convresation) {
        // Map valueMap = jsonDecode(value);
        // value = value.replaceAll("{", "");
        // value = value.replaceAll("}", "");
        // var dataSp = value.split(',');
        // Map<String, String> mapData = Map();
        // dataSp.forEach((element) => mapData[element.split(':')[0].trim()] =
        //     element.split(':')[1].trim());
        // print(value);
        previous_messages.add({
          'message': value['text'],
          'isUserMessage': value['isUser']
        });
      }
    }
  }
}
