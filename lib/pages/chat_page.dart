import 'dart:convert';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hfc/controllers/dialogMessageController.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/reposiontrys/dialog_reposiontry.dart';
import '../controllers/messageChatController.dart';
import '../models/rate.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/recipe_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';
import 'messages.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;
  final UserReposiontry userReposiontry;
  final DialogMessageController dialogController;
  const ChatPage(
      {super.key,
      required this.user,
      required this.userReposiontry,
      required this.dialogController});

  @override
  State<StatefulWidget> createState() {
    return __ChatPageState();
  }
}

class __ChatPageState extends State<ChatPage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  //final userFire = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> previous_messages = [];
  Map<dynamic, MessageChatController> controllers = {};
  Message loadMessage = Message(text: DialogText(text: ["#load"]));

  //bool isUser = false;

  var isOnce = true;
  
  bool isDialog =false;

  @override
  void initState() {
    DialogReposiontry().createDialogRep().then((ins) {
      dialogFlowtter = ins;
      UserReposiontry()
          .updateSessionId(dialogFlowtter.sessionId, widget.user.email)
          .then((instance) {
        if (this.mounted) {
          setState(() {
            isDialog = true;
            buildPreviousMessages(widget.user.conversation);

            // previous_messages = buildPreviousMessages(user.convresation);
          });
        }
      });
    });

    super.initState();
  }

  listenToServerChat(DialogMessageController controller) async {
    var mes;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      mes = message.data;
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      } else {
        if (message.data['request'] == 'recipe') {
          setState(() {
            controller.recipeMessage = message.data;
            controller.isWaitedRecipe = true;
          });
        }
         if (message.data['request'] == 'text') {
          print("text");
          setState(() {
        //    if (controller.startSendMeal == false) {

              controller.startSendMeal = true;
              controller.meal_plan = {};
            controller.meal_plan_text = message.data["text"];
       //     }
          });
        }
        if (message.data['request'] == 'meal_plan') {
          setState(() {
            print(message.data);
            // if (controller.startSendMeal == false) {
            //   controller.startSendMeal = true;
            //   controller.meal_plan = {};
            //   controller.meal_plan[message.data['currentMessage']] =
            //       message.data['card'];

            //   //controller.counterMeal++;
            // } else {
              controller.meal_plan[message.data['currentMessage']] =
                  message.data['card'];
              if (controller.meal_plan.length.toString() ==
                  message.data['messagesNumber'].toString()) {
                controller.sentPlanMeal = true;
             // }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkStart();
    listenToServerChat(widget.dialogController);
    checkWaitedRecipe();

    for (var m in previous_messages) {
      controllers[m] = MessageChatController();
    }
    for (var m in messages) {
      controllers[m] = MessageChatController();
    }
    //checkWaitedRecipe();

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
                    previousMessages: previous_messages,
                    controllers: controllers)),
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
                      decoration: const InputDecoration(
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
    return Transform.translate(
        offset: Offset(100, 40),
        child: const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white70,
          child: CircleAvatar(
              radius: 60,
              child: Image(image: AssetImage("assets/images/splash_bot.png"))),
        ));
  }

  IconButton returnBack(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white70,
      ),
      onPressed: () {
        UserReposiontry()
            .saveMessages(previous_messages + messages, widget.user.email);
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
      if (response.message!.text!.text![0]
          .contains("the server working on it.") || response.message!.text!.text![0]
          .contains("I'm making the plan for you, it may take some time.") ) {
        if (this.mounted) {
          setState(() {
            Future.delayed(Duration(milliseconds: 30), () {
            addMessage(loadMessage);
            });
          });
        }
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
    
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

  checkStart() async {
    if(isDialog == true){
    if (widget.user.fillDetails == false && isOnce == true) {
      fillDetails();
      isOnce = false;
    }
    }
  }

  buildPreviousMessages(var convresation) {
    if (convresation != "") {
      for (var value in convresation) {
        previous_messages
            .add({'message': value['text'], 'isUserMessage': value['isUser']});
      }
    }
  }

  void checkWaitedRecipe() {
    if (widget.dialogController.isWaitedRecipe == true) {
      setState(() {
        messages[messages.length - 1]['message'] = Message(
            text: DialogText(
                text: [widget.dialogController.recipeMessage['card']]));
        addMessage(Message(
            text: DialogText(
                text: [widget.dialogController.recipeMessage['text']])));
      });
      widget.dialogController.isWaitedRecipe = false;
    }
    if (widget.dialogController.sentPlanMeal == true) {
      
      String req =
          jsonEncode(addMealPlanToMessages(widget.dialogController.meal_plan));
      setState(() {
        messages[messages.length - 1]['message'] = 
        Message(text: DialogText(text: [widget.dialogController.meal_plan_text]));
       addMessage(Message(
            text: DialogText(
                text: [req])));
      widget.dialogController.sentPlanMeal = false;
      });
    }
  }

  addMealPlanToMessages(Map meal_plan) {
    Map<String, dynamic> days = {};
    Map<String, dynamic> meals;
    int day = 1;
    for (var index = 1; index < meal_plan.length; index = index + 3) {
      meals = {};
      int place = 1;
      for (var inerIndex = index; inerIndex < index + 3; inerIndex++) {
        //  int modolu = (inerIndex / 3).floor()+1;
        meals[place.toString()] = meal_plan[(inerIndex).toString()];
        place++;
      }
      days[day.toString()] = jsonEncode(meals);
      day++;
    }
    days["request"] = "meal_plan";
    return days;
  }
}
