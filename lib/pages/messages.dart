import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hfc/models/rate.dart';
import 'package:hfc/models/recipe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/user.dart';
import 'package:hfc/reposiontrys/rate_reposiontry.dart';
import 'package:hfc/reposiontrys/user_reposiontry.dart';
import 'package:url_launcher/url_launcher.dart';

import '../reposiontrys/recipe_reposiontry.dart';

class Messages extends StatefulWidget {
  final List messages;


  Messages({Key? key
  , required this.messages
  }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
        final user = FirebaseAuth.instance.currentUser!;

  bool like = true;
  final nutIcons = {
    'gluten-free': SvgPicture.asset(
      'assets/svgs/gluten-free.svg',
      width: 18,
      height: 20,
    ),
    'keto-friendly': SvgPicture.asset(
      'assets/svgs/keto-friendly.svg',
      width: 18,
      height: 20,
    ),
    'low-sugar': SvgPicture.asset(
      'assets/svgs/low-sugar.svg',
      width: 18,
      height: 20,
    ),
    'paleo': SvgPicture.asset(
      'assets/svgs/paleo.svg',
      width: 18,
      height: 20,
    ),
    'peanut-free': SvgPicture.asset(
      'assets/svgs/peanut-free.svg',
      width: 18,
      height: 20,
    ),
    'vegan': SvgPicture.asset(
      'assets/svgs/vegan.svg',
      width: 18,
      height: 20,
    ),
    'dairy-free': SvgPicture.asset(
      'assets/svgs/dairy-free.svg',
      width: 18,
      height: 20,
    ),
  };

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: widget.messages[index]['isUserMessage']
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(
                        10,
                      ),
                      bottomRight: const Radius.circular(10),
                      topRight: Radius.circular(
                          widget.messages[index]['isUserMessage'] ? 0 : 10),
                      topLeft: Radius.circular(
                          widget.messages[index]['isUserMessage'] ? 10 : 0),
                    ),
                    color: widget.messages[index]['isUserMessage']
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
                  constraints: BoxConstraints(maxWidth: w * 4 / 5),
                  child: buildMessage(
                      widget.messages[index]['message'].text.text[0],
                      widget.messages[index]['isUserMessage']),
                ),
                SizedBox(
                  child: widget.messages[index]['isUserMessage']
                      ? Container()
                      : rate(widget.messages[index]['message'].text.text[0]),
                )
              ],
            ),
          );
        },
        separatorBuilder: (_, i) =>
            const Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: widget.messages.length);
  }

  Widget rate(data) {
    try {
      final reqest = jsonDecode(data);
      RecipeModel req = RecipeModel.fromJson(reqest);

      if (req.requset == "recipe") {
        return IconButton(
            onPressed: () async {
              setState(() {
                 if (like == true ){
                like = false;
              }
              else{
              like = true;}
              });
             
              //update firebase:
              UserModel userM = await UserReposiontry().getUserDetails(user.email!);
     RecipeModel recipeM = await RecipeReposiontry().getRecipeDetails(req.title);
              await RateReposiontry().updateRate(like,userM.getId(),recipeM.getId());

            },
            icon: like == false
                ? Icon(FontAwesomeIcons.thumbsUp)
                : Icon(FontAwesomeIcons.thumbsDown));
      }
      return Container();
    } on FormatException catch (e) {
      return Container();
    }
  }

   buildMessage(data, bool isUser)  {
    try {
      final reqest = jsonDecode(data);
      RecipeModel req = RecipeModel.fromJson(reqest);

      if (req.requset == "recipe") {
        //add recipe for firebase:
       //  updateFireBase(req);

        return buildRecipeCard(req);
      } else {
        return Container(
            child: const Text("other", style: TextStyle(color: Colors.black)));
      }
//return buildRecipeCard();
    } on FormatException catch (e) //if not json:

    {
      return Container(
          child: Text(data,
              style: TextStyle(
                  color: isUser == true ? Colors.white : Colors.black)));
    }
  }

  

  Widget buildRecipeCard(RecipeModel recipe) {
    return Column(
      children: [
        recipe_image(recipe),
        const SizedBox(
          height: 10,
        ),
        recipe_title(recipe),
        const SizedBox(
          height: 10,
        ),
        //  Row(children: [
        nutritionListBuild(recipe.labels),
        const SizedBox(
          height: 20,
        ),

        //    ]),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 5, 5),
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () async {
              final uri = Uri.parse(recipe.url);
              if (!await launchUrl(uri)) {
                throw Exception('Could not launch $uri');
              }
            },
            child: const Text(
              "TO THE FULL RECIPE",
              style:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox recipe_image(RecipeModel recipe) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.indigo.shade100),
          borderRadius: BorderRadius.circular(8),
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

          //<-- SEE HERE
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            recipe.image,
          ),
        ),
      ),
    );
  }

  Text recipe_title(RecipeModel recipe) {
    return Text(
      recipe.title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  nutritionListBuild(List labels) {
    List<Widget> nut = [];
    for (var l in labels) {
      switch (l) {
        case 'Dairy-Free':
          {
            nut.add(
              buildNutritionInfo('dairy-free'),
            );
            //  nut.add(const SizedBox(
            //     width: 10,
            //  ));
          }
          break;
        case 'Gluten-Free':
          {
            nut.add(
              buildNutritionInfo('gluten-free'),
            );
            //   nut.add(const SizedBox(
            //  //   width: 10,
            //   ));
          }
          break;
        case 'Peanut-Free':
          {
            nut.add(
              buildNutritionInfo('peanut-free'),
            );
            //   nut.add(const SizedBox(
            // //    width: 10,
            //   ));
          }
          break;
        case 'Vegan':
          {
            nut.add(
              buildNutritionInfo('vegan'),
            );
            //   nut.add(const SizedBox(
            // //    width: 10,
            //   ));
          }
          break;
        case 'Paleo':
          {
            nut.add(
              buildNutritionInfo('paleo'),
            );
            //   nut.add(const SizedBox(
            //  //   width: 10,
            //   ));
          }
          break;
        case 'Low Sugar':
          {
            nut.add(
              buildNutritionInfo('low-sugar'),
            );
            // nut.add(const SizedBox(
            // //  width: 10,
            // ));
          }
          break;
        case 'Keto-Friendly':
          {
            nut.add(
              buildNutritionInfo('keto-friendly'),
            );
            // nut.add(const SizedBox(
            //  // width: 10,
            // ));
          }
          break;
        default:
          {
            //statements;
          }
          break;
      }
    }

    return SizedBox(
      height: 80,
      width: 300,
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisExtent: 40),
          children: nut),
    );
  }

  Widget buildNutritionInfo(String nut) {
    return Row(
      children: [
        SizedBox(
          //     height: 20,
          child: nutIcons[nut],
        ),
        Text(
          nut,
          style: const TextStyle(color: Colors.black, fontSize: 10),
        )
      ],
    );
  }

  openUri(recipe) async {
    final uri = Uri.parse(recipe.url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
  
  
  
}
