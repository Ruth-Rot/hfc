import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hfc/common/recipe_card.dart';
import 'package:hfc/controllers/message_chat_controller.dart';
import 'package:hfc/models/recipe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/user.dart';
import 'package:hfc/reposiontrys/rate_reposiontry.dart';
import 'package:hfc/reposiontrys/user_reposiontry.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../models/rate.dart';
import '../models/recipe_widget_controller.dart';
import '../reposiontrys/recipe_reposiontry.dart';

class Messages extends StatefulWidget {
  final List previousMessages;
  final Map<dynamic, MessageChatController> controllers;
  final List messages;

  const Messages(
      {Key? key,
      required this.previousMessages,
      required this.messages,
      required this.controllers})
      : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final user = FirebaseAuth.instance.currentUser!;

  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        reverse: true,
        controller: _scrollController,
        child: Column(
          children: [
            messagesList(w, widget.previousMessages),
            // const SizedBox(
            //     height: 20,
            //     width: 400,
            //     child: Divider(
            //       height: 10,
            //     )),
        //    const Text("start convresation"),
            messagesList(w, widget.messages),
          ],
        ),
      ),
    );
  }

  ListView messagesList(double w, List messagesList) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: messagesList[index]['isUserMessage']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(
                              10,
                            ),
                            bottomRight: const Radius.circular(10),
                            topRight: Radius.circular(
                                messagesList[index]['isUserMessage'] ? 0 : 10),
                            topLeft: Radius.circular(
                                messagesList[index]['isUserMessage'] ? 10 : 0),
                          ),
                          color: messagesList[index]['isUserMessage']
                              ? Colors.indigo.shade800
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.shade200,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            const BoxShadow(
                              color: Colors.black,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        constraints: BoxConstraints(maxWidth: w * 6 / 7),
                        child:
                            messagesList[index]['message'].runtimeType == String
                                ? buildMessage(
                                    messagesList[index]['message'],
                                    messagesList[index]['isUserMessage'],
                                    messagesList[index])
                                : buildMessage(
                                    messagesList[index]['message'].text.text[0],
                                    messagesList[index]['isUserMessage'],
                                    messagesList[index])),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 50,
                  child: messagesList[index]['message'].runtimeType == String
                      ? rate(
                          messagesList[index]['message'], messagesList[index])
                      : rate(messagesList[index]['message'].text.text[0],
                          messagesList[index]))
            ],
          );
        },
        separatorBuilder: (_, i) =>
            const Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: messagesList.length);
  }

  Widget rate(data, message) {
    try {
      //.text.text[0]
      final reqest = jsonDecode(data);

      if (reqest.runtimeType != int && reqest["request"] != "meal_plan") {
        RecipeModel req = RecipeModel.fromJson(reqest);

        if (req.request == "recipe") {
          return Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.shade200,
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  const BoxShadow(
                    color: Colors.black,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                )),
            width: 100,
            height: 40,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (widget.controllers[message]?.first == true) {
                          UserModel userM = await UserReposiontry()
                              .getUserDetails(user.email!);
                          RecipeModel recipeM = await RecipeReposiontry()
                              .getRecipeDetails(req.title);

                          RateReposiontry().createRate(RateModel(
                              like: true,
                              userId: userM.getId(),
                              recipeId: recipeM.getId()));
                        } else if (widget.controllers[message]?.like == false) {
                          UserModel userM = await UserReposiontry()
                              .getUserDetails(user.email!);
                          RecipeModel recipeM = await RecipeReposiontry()
                              .getRecipeDetails(req.title);
                          await RateReposiontry()
                              .updateRate(true, userM.getId(), recipeM.getId());
                        }
                        setState(() {
                          if (widget.controllers[message]?.first == true) {
                            widget.controllers[message]?.first = false;
                          }
                          if (widget.controllers[message]?.like == false) {
                            widget.controllers[message]?.like = true;
                          }
                        });
                      },
                      icon: Icon(FontAwesomeIcons.thumbsUp,
                          size: widget.controllers[message]?.first == false &&
                                  widget.controllers[message]?.like == true
                              ? 20
                              : 15)),
                  IconButton(
                      onPressed: () async {
                        if (widget.controllers[message]?.first == true) {
                          UserModel userM = await UserReposiontry()
                              .getUserDetails(user.email!);
                          RecipeModel recipeM = await RecipeReposiontry()
                              .getRecipeDetails(req.title);

                          RateReposiontry().createRate(RateModel(
                              like: false,
                              userId: userM.getId(),
                              recipeId: recipeM.getId()));
                        }
                        if (widget.controllers[message]?.like == true) {
                          UserModel userM = await UserReposiontry()
                              .getUserDetails(user.email!);
                          RecipeModel recipeM = await RecipeReposiontry()
                              .getRecipeDetails(req.title);
                          await RateReposiontry().updateRate(
                              false, userM.getId(), recipeM.getId());
                        }
                        setState(() {
                          if (widget.controllers[message]?.first == true) {
                            widget.controllers[message]?.first = false;
                          }
                          if (widget.controllers[message]?.like == true) {
                            widget.controllers[message]?.like = false;
                          }
                        });
                      },
                      icon: Icon(
                        FontAwesomeIcons.thumbsDown,
                        size: widget.controllers[message]?.first == false &&
                                widget.controllers[message]?.like == false
                            ? 20
                            : 15,
                      )),
                ],
              ),
            ),
          );
        }
        return Container();
      } else {
        return Container();
      }
    } on FormatException {
      return Container();
    }
  }

  buildMessage(data, bool isUser, message) {
    try {
      final json = jsonDecode(data);
      if (json is Map<String, dynamic>) {
        //check if json
        if (json["request"] == "meal_plan") {
          return buildMealPlan(json, message);
        } else {
          RecipeModel req = RecipeModel.fromJson(json);
          if (req.request == "recipe") {
            return RecipeCard(
                recipeController: RecipeWidgetController(recipe: req));
          }
        }
      } else {
       // print("first: " + data);
        if (data == "#load") {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.indigo,
              size: 200,
            ),
          );
        } else {
          return Text(data,
              style: TextStyle(
                  color: isUser == true ? Colors.white : Colors.black));
        }
      }
    } on FormatException catch (e) //if not json:
    {
      //print("second: " + data);
      if (data == "#load") {
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.indigo,
        size: 150,
          ),
        );
      } else {
        return Text(data,
            style:
                TextStyle(color: isUser == true ? Colors.white : Colors.black));
      }
    }
  }

  buildMealPlan(Map<String, dynamic> json, message) {
    json.remove("request");
    return Column(
      children: [
        SizedBox(
            height: 670,
            width: 380,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.controllers[message]!.day == 1
                        ? const SizedBox(
                            width: 40,
                          )
                        : IconButton(
                            onPressed: () {
                              if (widget.controllers[message]!.day > 1) {
                                if (mounted) {
                                  setState(() {
                                    widget.controllers[message]!.day--;
                                  });
                                }
                              }
                            },
                            icon: const Icon(Icons.arrow_left, size: 40),
                          ),
                    Text(
                      "Day ${widget.controllers[message]!.day}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    widget.controllers[message]!.day == json.keys.length
                        ? const SizedBox(
                            width: 50,
                          )
                        : IconButton(
                            onPressed: () {
                              if (widget.controllers[message]!.day <
                                  json.keys.length) {
                                if (mounted) {
                                  setState(() {
                                    widget.controllers[message]!.day++;
                                  });
                                }
                              }
                            },
                            icon: const Icon(Icons.arrow_right, size: 40),
                          ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 610,
                  width: 350,
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      var js = jsonDecode(
                          json[(widget.controllers[message]!.day).toString()]);
                      RecipeModel recipe = RecipeModel.fromJson(
                          jsonDecode(js[(index + 1).toString()]));
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              index != 0
                                  ? index == 1
                                      ? "Lunch"
                                      : "Dinner"
                                  : "Breakfast",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          RecipeCard(
                              recipeController:
                                  RecipeWidgetController(recipe: recipe))
                        ],
                      );
                    },
                    itemCount: jsonDecode(
                            json[(widget.controllers[message]!.day).toString()])
                        .keys
                        .length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            )
            )
      ],
    );
  }
}
