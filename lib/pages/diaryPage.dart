import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/dish.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';

import '../common/theme_helper.dart';
import '../models/meal.dart';

class DiaryPage extends StatefulWidget {
  DiaryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return __DiaryPageState();
  }
}

class __DiaryPageState extends State<DiaryPage> {
  var date = DateTime.now();
  late List<MealModel> meals=[
    MealModel(type: 'Breakfast'),
    MealModel(type: 'Lunch'),
    MealModel(type: 'Dinner'),
    MealModel(type: 'Snacks')    
    ];

  List<String> measurements = [
    "Cup",
    "Spoon",
    "Slice",
    "Teaspoons",
    "Large",
    "Medium",
    "Small",
    "Gram"
  ];
  String? selectedMeaserment = "Cup";
  @override
  Widget build(BuildContext context) {
    String dateS = DateFormat.yMMMMd('en_US').format(date); //  -> July 10, 1996
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.indigo,
                boxShadow: const [BoxShadow(blurRadius: 40.0)],
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Column(
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            onPressed: () {
                              //sub a day
                              date = date.subtract(const Duration(days: 1));
                              setState(() {
                                dateS = DateFormat.yMMMMd('en_US').format(date);
                              });
                            },
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 30,
                            )),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          dateS,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            onPressed: () {
                              //add a day
                              if (date.day != DateTime.now().day) {
                                date = date.add(const Duration(days: 1));
                                setState(() {
                                  dateS =
                                      DateFormat.yMMMMd('en_US').format(date);
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: date.day == DateTime.now().day
                                  ? Colors.transparent
                                  : Colors.white,
                              size: 30,
                            )),
                      ]),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 180,
              child: Container(
                color: Colors.amber,
                child: const Text("calories diagram"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 480,
              width: 400,
              //  ListView.separated(
              //     padding: const EdgeInsets.all(8),
              //     itemCount: dishes.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Container(
              //         height: 40,
              //         child:
              //             item(dishes[index].type, dishes[index].amount),
              //       );
              //     },
              //     separatorBuilder: (BuildContext context, int index) =>
              //         Container()),
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: meals.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: meals[index].getHeight()+20,
                      child: mealContainer(meals[index]),
                      
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 20,)),
            ),
          ],
        ),
      ),
    );
  }

  Container mealContainer(MealModel meal) {
    double height = meal.getHeight();
    print(height);
    return Container(
      height: height + 20.0,
      child: Stack(children: [
        Container(height: height ,child: mealCard(meal)),
        Positioned(bottom: 0, left: 180, child: addButton(meal))
      ]),
    );
  }

  Container mealCard(MealModel meal) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 232, 234, 246),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: mealName(meal.type),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40.0 * meal.dishes.length,
              child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: meal.dishes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 40,
                      child: item(meal.dishes[index].type, meal.dishes[index].amount),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container()),
            ),
            SizedBox(
              height: 10,
            ),
            meal.isAdd == false ? Container() : addItemForm(meal),
            Divider(),
            Row(
              children: [
                const Text("total calories:"),
                Text(meal.getCalories().toString())
              ],
            ),
          ],
        ));
  }

  Text mealName(String meal) {
    return Text(
      "  " + meal,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  ClipOval addButton(MealModel meal) {
    return ClipOval(
      child: Material(
        color: meal.isAdd == false ? Colors.blue : Colors.red, // Button color
        child: InkWell(
          //  splashColor: isAdd==false?Colors.red:Colors.blue, // Splash color
          onTap: () {
            if (meal.isAdd == true) {
              if (meal.formKey.currentState!.validate()) {
                meal.dishes.add(DishModel(
                    type: meal.dishController.text.trim(),
                    measurement: meal.measurementController.text.trim(),
                    amount: meal.amountController.text.trim()));
                //ask api for calories:

                //update firebase:

                meal.dishController.clear();
               meal.measurementController.clear();
                meal.amountController.clear();
                setState(() {
                  meal.isAdd = !meal.isAdd;
                });
              }
            } else {
              setState(() {
                meal.isAdd = !meal.isAdd;
              });
            }
          },
          child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(meal.isAdd == false ? Icons.add : Icons.check)),
        ),
      ),
    );
  }

  Form addItemForm(MealModel meal) {
    return Form(
      key: meal.formKey,
      child: Row(children: [
        SizedBox(
          width: 10,
        ),
        SizedBox(width: 150, child: foodfield(meal)),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 110,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Measerment",
              labelStyle: TextStyle(fontSize: 12),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
            value: selectedMeaserment,
            onChanged: (item) => setState(() => selectedMeaserment = item),
            items: measurements
                .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 12),
                    )))
                .toList(),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        SizedBox(width: 110, child: amountfield(meal))
      ]),
    );
  }

  Row item(food, amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 0),
        Text(food),
        Text(amount),
        Text("100"),
        SizedBox(width: 0),
      ],
    );
  }

  TextFormField foodfield(MealModel meal) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: ThemeHelper().textInputDecorationFoodForm(
          "Dish",
          "what you ate?",
          Icon(
            FontAwesomeIcons.utensils,
            size: 15,
          )),
      controller: meal.dishController,
      style: TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter email";
        }
        bool dishValidator = RegExp(r"^[a-zA-Z\s]*$").hasMatch(value);
        if (!dishValidator) {
          return "Enter Valid dish";
        }
      },
    );
  }

  TextFormField amountfield(MealModel meal) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: ThemeHelper().textInputDecorationFoodForm(
        "Amount",
        "How much?",
        // Icon(
        //   FontAwesomeIcons.weightScale,
        //   size: 15,
        // )),
      ),
      controller: meal.amountController,
      style: TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter amount";
        }
        // bool dishValidator = RegExp(r"^[^\W\d_]+$").hasMatch(value);
        // if (!dishValidator) {
        //   return "Enter Valid dish";
        // }
      },
    );
  }
}

enum MeasurementLabel {
  cup('Cup'),
  spoon('Spoon'),
  slice('Slice');

  const MeasurementLabel(this.label);
  final String label;
}
