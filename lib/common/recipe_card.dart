import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/recipe_widget_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeCard extends StatefulWidget{
  final RecipeWidgetController recipeController;
    const RecipeCard({Key? key, required this.recipeController}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
     return __RecipeCardState();
  }

}

class __RecipeCardState extends State<RecipeCard>{
  @override
  Widget build(BuildContext context) {
    double height = widget.recipeController.getHeight() + 20;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SizedBox(
              height: widget.recipeController.getHeight(),
              width: 380,
              child: recipeCard(widget.recipeController)),
          Positioned(
              bottom: 0,
              left: 170,
              child: ClipOval(
                  child: Material(
                                            color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Future.delayed(const Duration(milliseconds:10 ), () {
                            widget.recipeController.isOpen = !widget.recipeController.isOpen;});
                          });
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: FaIcon(
                              widget.recipeController.isOpen
                                  ? FontAwesomeIcons.chevronUp
                                  : FontAwesomeIcons.chevronDown,
                              size: 18,
                            ),
                          ),
                        ),
                      ))))
        ],
      ),
    );
  }
  
  recipeCard(RecipeWidgetController recipeController) {
    Widget openColumn = Container();
    if (recipeController.isOpen) {
      openColumn = Column(children: [
        showList("Diet Labels", recipeController.recipe.dietLabels,
           const Color.fromARGB(255, 77, 182, 172)),
        showList("Health Labels", recipeController.recipe.healthLabels,
            Colors.amberAccent),
        showList("Ingredients", recipeController.recipe.ingredients,
          const  Color.fromARGB(255, 218, 146, 146)),
     const   SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () async {
              String url = recipeController.recipe.url;
              if(url.contains('https') == false){
                url = url.replaceFirst("http", "https");
              }
              final uri = Uri.parse(url);
              
              if (!await launchUrl(uri)) {

                throw Exception('Could not launch $uri');
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(
                  "To view the complete recipe, ",
                  style: TextStyle(
                      color: Colors.black, fontStyle: FontStyle.italic),
                ),
                Text(
                  "click here",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ]);
    }
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(children: [recipeHeader(recipeController), openColumn]));
  }

  Column showList(String recipeName, List<String> list, Color color) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          recipeName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 350,
          height: 40,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return circleLabel(list[index], color);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
              itemCount: list.length),
        ),
      ],
    );
  }

  Container circleLabel(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.circular(15),
        //<-- SEE HERE
      ),
      margin: const EdgeInsets.all(2),
      child: Center(
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                label,
                style:const TextStyle(fontSize: 10),
              ))),
    );
  }

  recipeHeader(RecipeWidgetController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: controller.recipe.image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(), // Placeholder widget while loading
                  errorWidget: (context, url, error) =>  const Icon(
                      Icons.error), // Widget to display in case of an error
                ),
              ),
            ),
            SizedBox(
                height: 120,
                width: 200,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        controller.recipe.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Column(children: [
                            const FaIcon(FontAwesomeIcons.utensils),
                            const Text(
                              "Ckal",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              controller.recipe.calories.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            const FaIcon(FontAwesomeIcons.breadSlice),
                            const Text(
                              "Carbs",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              controller.recipe.carbs.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            const FaIcon(FontAwesomeIcons.dna),
                            const Text(
                              "Protein",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              controller.recipe.protein.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            const FaIcon(FontAwesomeIcons.droplet),
                            const Text(
                              "Fat",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              controller.recipe.fat.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                        )
                      ],
                    ),
                  ],
                ))
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}