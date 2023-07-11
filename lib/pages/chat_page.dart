import 'dart:convert';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hfc/controllers/dialog_message_controller.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/reposiontrys/dialog_reposiontry.dart';
import '../controllers/message_chat_controller.dart';
import '../models/user.dart';
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
  List<Map<String, dynamic>> previousMessages = [];
  Map<dynamic, MessageChatController> controllers = {};
  Message loadMessage = Message(text: DialogText(text: const ["#load"]));
  var isOnce = true;
  bool isDialog = false;

  @override
  void initState() {
    DialogReposiontry().createDialogRep().then((ins) {
      dialogFlowtter = ins;
      UserReposiontry()
          .updateSessionId(dialogFlowtter.sessionId, widget.user.email)
          .then((instance) {
        if (mounted) {
          setState(() {
            isDialog = true;
            buildPreviousMessages(widget.user.conversation);
          });
        }
      });
    });

    super.initState();
  }

  listenToServerChat(DialogMessageController controller) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      String request = message.data['request'];
      switch (request) {
        case "note":
          {
            // add data and handle controller:
            if (mounted) {
              setState(() {
                controller.insertNotification(message.data['text']);
              });
            }
          }

          break;

        case "start_meal_plan":
          {
            //  handle controller
            if (mounted) {
              setState(() {
                controller.starwaitForMealPlan(message.data['text']);
              });
            }
          }
          break;
        case "start_recipe_search":
          {
            //  handle controller
            if (mounted) {
              setState(() {
                controller.starwaitForRecipe(message.data['text']);
              });
            }
          }
          break;

        case "Meal_plan_details_1":
          {
            // start to wait for meal plan card:
            // add  first meal:

            if (mounted) {
              setState(() {
                controller.mealPlanTextStart = message.data["text"];
              });
            }
          }
          break;
          case "Meal_plan_details_2":
          {
            // start to wait for meal plan card:
            // add  first meal:

            if (mounted) {
              setState(() {
                controller.mealPlanTextEnd = message.data["text"];
              });
            }
          }
          break;

        case "meal_plan":
          {
            // add  meal:
            if (mounted) {
            setState(() {
              controller.mealPlan[message.data['currentMessage']] =
                  message.data['card'];
            // check if last and handle:
              if (controller.mealPlan.length.toString() ==
                  message.data['messagesNumber'].toString()) {
                controller.sentPlanMeal = true;
              }
            });
          }
          }
          break;

        case "meal_plan_failed":
          {
             // update controller
            if (mounted) {
              setState(() {
                controller.mealPlanFailed(message.data);
              });
            }
          }
          break;

        case "recipe":
          {
            // update controller with recipe
            if (mounted) {
              setState(() {
                controller.addRecipe(message.data);
              });
            }
          }
          break;

        case "recipe_failed":
          {
            // update controller
            if (mounted) {
              setState(() {
                controller.recipeFailed(message.data);
              });
            }
          }
          break;
        default:
          {
            //statements;
          }
          break;
      }
      
      //  else {
      //   if (message.data['request'] == 'recipe') {
      //     if (mounted) {
      //       setState(() {
      //         controller.recipeMessage = message.data;
      //         controller.isWaitedRecipe = true;
      //       });
      //     }
      //   }
      //     else      if (message.data['request'] == 'daily sentence') {
      //             // change firebase field
      //             //add message to mess!
      //           }
      //  else if (message.data['request'] == 'text') {
      //     print("text");
      //     if (mounted) {
      //       setState(() {
      //         controller.startSendMeal = true;
      //         controller.mealPlan = {};
      //         controller.mealPlanText = message.data["text"];
      //       });
      //     }
      //   }
      //  else if (message.data['request'] == 'meal_plan') {
      //     if (mounted) {
      //       setState(() {
      //         print(message.data);
      //         controller.mealPlan[message.data['currentMessage']] =
      //             message.data['card'];
      //         if (controller.mealPlan.length.toString() ==
      //             message.data['messagesNumber'].toString()) {
      //           controller.sentPlanMeal = true;
      //         }
      //       });
      //     }
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkStart();
    listenToServerChat(widget.dialogController);
    //  checkWaitedRecipe();

    for (var m in previousMessages) {
      controllers[m] = MessageChatController();
    }
    for (var m in messages) {
      controllers[m] = MessageChatController();
    }
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
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
                    previousMessages: previousMessages,
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
        offset: const Offset(100, 40),
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
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white70,
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      if (mounted) {
        setState(() {
          var mes = Message(text: DialogText(text: [text]));
          addMessage(mes, true);
        });
      }

      var query = QueryInput(text: TextInput(text: text));
      DetectIntentResponse response =
          await dialogFlowtter.detectIntent(queryInput: query);
      if (response.message == null) return;

      if (mounted) {
        setState(() {
          addMessage(response.message!);
        });
      }
      //save messages in firebase:
      UserReposiontry()
          .saveMessages(previousMessages + messages, widget.user.email);
    }
  }

  fillDetails() async {
    var query = QueryInput(text: TextInput(text: 'personal details'));

    DetectIntentResponse response =
        await dialogFlowtter.detectIntent(queryInput: query);
    if (mounted) {
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });

      //save messages in firebase:
      UserReposiontry()
          .saveMessages(previousMessages + messages, widget.user.email);
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

  handleWaitNote() {
    // turn off have_notification flag in user:
    widget.userReposiontry.updateGetNotification(widget.user.email);
    // add message:
    if (mounted) {
      setState(() {
        addMessage(Message(
            text: DialogText(
                text: [widget.dialogController.notificationMessage])));
      });
      //save messages in firebase:
      UserReposiontry()
          .saveMessages(previousMessages + messages, widget.user.email);
    }
    // update controller:
    widget.dialogController.notifiactionReset();
  }

  checkStart() async {
    // check if there a notification:
    if (widget.dialogController.isWaitedNotification == true) {
      handleWaitNote();
    }
    //check if there is a need to fill details:
    if (isDialog == true) {
      if (widget.user.fillDetails == false && isOnce == true) {
        fillDetails();
        isOnce = false;
      }
    }
    //check if there a mealPlan start:
    if (widget.dialogController.waitForMeal == true) {
      if (mounted) {
        setState(() {
          addMessage(Message(
              text: DialogText(
                  text: [widget.dialogController.waitForMealMessage])));
          Future.delayed(const Duration(seconds: 1), () {
            addMessage(loadMessage);
          });
          widget.dialogController.waitForMeal == false;
        });
      }
    }
    //check if there a recipe start:
    if (widget.dialogController.waitForRecipe == true) {
      if (mounted) {
        setState(() {
          addMessage(Message(
              text: DialogText(
                  text: [widget.dialogController.waitForRecipeMessage])));
          Future.delayed(const Duration(seconds: 1), () {
            addMessage(loadMessage);
          });
          widget.dialogController.waitForRecipe = false;
        });
      }
    }
    //check if get a recipe:
    if (widget.dialogController.isWaitedRecipe == true) {
      if (mounted) {
        setState(() {
          messages[messages.length - 1]['message'] = Message(
              text: DialogText(
                  text: [widget.dialogController.recipeMessage['card']]));
          addMessage(Message(
              text: DialogText(
                  text: [widget.dialogController.recipeMessage['text']])));
        });
        //save messages in firebase:
        UserReposiontry()
            .saveMessages(previousMessages + messages, widget.user.email);
      }
      widget.dialogController.isWaitedRecipe = false;
    }
    //check if recipe fail:
    if (widget.dialogController.isfailrecipe == true) {
      if (mounted) {
        setState(() {
          messages[messages.length - 1]['message'] = Message(
              text: DialogText(
                  text: [widget.dialogController.failureTextRecipe]));
          widget.dialogController.isfailrecipe = false;
        });
      }
    }

    //check if get a meal plan:
    if (widget.dialogController.sentPlanMeal == true) {
      String req =
          jsonEncode(addMealPlanToMessages(widget.dialogController.mealPlan));
      if (mounted) {
        setState(() {
          messages[messages.length - 1]['message'] = Message(
              text: DialogText(text: [widget.dialogController.mealPlanTextStart]));
          addMessage(Message(text: DialogText(text: [req])));
          addMessage(Message(text: DialogText(text: [widget.dialogController.mealPlanTextEnd])));
          //save messages in firebase:
          UserReposiontry()
              .saveMessages(previousMessages + messages, widget.user.email);
          widget.dialogController.sentPlanMeal = false;
          widget.dialogController.mealPlan = {};

        });
      }
    }

    //check if meal plan fail:
    if (widget.dialogController.isfailPlan == true) {
      if (mounted) {
        setState(() {
          messages[messages.length - 1]['message'] = Message(
              text: DialogText(
                  text: [widget.dialogController.failureTextPlan]));
          widget.dialogController.isfailrecipe = false;
widget.dialogController.mealPlan = {};

        });
      }
    }
  }

  buildPreviousMessages(var convresation) {
    if (convresation != "") {
      for (var value in convresation) {
        previousMessages
            .add({'message': value['text'], 'isUserMessage': value['isUser']});
      }
    }
  }

  void checkWaitedRecipe() {
    // if (widget.dialogController.isWaitedRecipe == true) {
    //   if (mounted) {
    //     setState(() {
    //       messages[messages.length - 1]['message'] = Message(
    //           text: DialogText(
    //               text: [widget.dialogController.recipeMessage['card']]));
    //       addMessage(Message(
    //           text: DialogText(
    //               text: [widget.dialogController.recipeMessage['text']])));
    //     });
    //     //save messages in firebase:
    //     UserReposiontry()
    //         .saveMessages(previousMessages + messages, widget.user.email);
    //   }
    //   widget.dialogController.isWaitedRecipe = false;
    // }
    // if (widget.dialogController.sentPlanMeal == true) {
    //   String req =
    //       jsonEncode(addMealPlanToMessages(widget.dialogController.mealPlan));
    //   if (mounted) {
    //     setState(() {
    //       messages[messages.length - 1]['message'] = Message(
    //           text: DialogText(text: [widget.dialogController.mealPlanText]));
    //       addMessage(Message(text: DialogText(text: [req])));
    //       //save messages in firebase:
    //       UserReposiontry()
    //           .saveMessages(previousMessages + messages, widget.user.email);
    //       widget.dialogController.sentPlanMeal = false;
    //     });
    //   }
    // }
  }

  addMealPlanToMessages(Map mealPlan) {
    Map<String, dynamic> days = {};
    Map<String, dynamic> meals;
    int day = 1;
    for (var index = 1; index < mealPlan.length; index = index + 3) {
      meals = {};
      int place = 1;
      for (var inerIndex = index; inerIndex < index + 3; inerIndex++) {
        //  int modolu = (inerIndex / 3).floor()+1;
        meals[place.toString()] = mealPlan[(inerIndex).toString()];
        place++;
      }
      days[day.toString()] = jsonEncode(meals);
      day++;
    }
    days["request"] = "meal_plan";
    return days;
  }
}
