import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/dish.dart';
import 'package:hfc/models/user.dart';
import 'package:hfc/reposiontrys/user_reposiontry.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../common/radialProgress.dart';
import '../common/stickProgress.dart';
import '../common/theme_helper.dart';
import '../models/day.dart';
import '../models/dishData.dart';
import '../models/meal.dart';
import '../reposiontrys/nutritionApi_reposiontry.dart';

class DiaryPage extends StatefulWidget {
  final UserModel userModel;
  final UserReposiontry userReposiontry;
  DiaryPage({Key? key, required this.userModel, required UserReposiontry this.userReposiontry}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __DiaryPageState();
  }
}

class __DiaryPageState extends State<DiaryPage> {
  var date = DateTime.now();
  Map<String, Day> days = {};
  Day currentDay = Day(date: DateFormat.yMMMMd('en_US').format(DateTime.now()),meals:getDayMeals());
  String dateS = "";
  List<String> measurements = [
    "Cup",
    "Tablespoon",
    "Slice",
    "Teaspoons",
    "Large",
    "Medium",
    "Small",
    "Gram",
    "Oz",
    "Unit",
    "Bowl"
  ];
  String? selectedMeaserment = "Cup";

  @override
  dispose() {
    widget.userReposiontry.
    updateDiary(days, widget.userModel.email);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateS = DateFormat.yMMMMd('en_US').format(date);
    days = widget.userModel.diary;
    if(days.containsKey(dateS) == false){
    days[dateS] = currentDay;
    }
    else{
      currentDay = days[dateS]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    

    if (widget.userModel.fillDetails == true) {
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
                                String dataString =
                                    DateFormat.yMMMMd('en_US').format(date);
                                updateCurrentDay(dataString);
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
                                  String dataString =
                                      DateFormat.yMMMMd('en_US').format(date);
                                  updateCurrentDay(dataString);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RadialProgress(
                      width: width * 0.4,
                      height: width * 0.4,
                      progress: (1.0 -
                          (currentDay.getDailyCalories(
                                  widget.userModel.dailyCalories) /
                              widget.userModel.dailyCalories)),
                      remain: currentDay
                          .getDailyCalories(widget.userModel.dailyCalories)
                          .toStringAsFixed(2)
                          .toString(),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StickProgress(
                          ingredient: "Protein",
                          progress: currentDay.getDailyCrabs() / 250.0,
                          progressColor: Colors.green,
                          height: 160,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        StickProgress(
                          ingredient: "Carbs",
                          progress: currentDay.getDailyProtein() / 250.0,
                          progressColor: Colors.red,
                          height: 160,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        StickProgress(
                          ingredient: "Fat",
                          progress: currentDay.getDailyFat() / 250.0,
                          progressColor: Colors.yellow,
                          height: 160,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 480,
                width: 400,
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: currentDay.meals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: currentDay.meals[index].getHeight() + 20.0,
                        child: mealContainer(currentDay.meals[index]),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          height: 5,
                        )),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(child: Text("Fill your details in the chat bot"));
    }
  }

  Container mealContainer(MealModel meal) {
    double height = meal.getHeight();
    return Container(
      height: height + 20.0,
      child: Stack(children: [
        Positioned(
            left: 10,
            child:
                Container(height: height, width: 380, child: mealCard(meal))),
        meal.isOpen == true
            ? Positioned(bottom: 0, left: 180, child: addButton(meal))
            : Container()
      ]),
    );
  }

  Container mealCard(MealModel meal) {
    Widget openColumn = Container();
    if (meal.isOpen) {
      openColumn = Column(children: [
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
                  child: itemRow(meal.type, meal.dishes[index]),
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
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text("  total calories: "),
              Text(meal.getCalories().toString()),
            ],
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
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              mealName(meal.type),
              Positioned(
                  left: 10,
                  child: IconButton(
                    icon: FaIcon(
                      meal.isOpen
                          ? FontAwesomeIcons.chevronUp
                          : FontAwesomeIcons.chevronDown,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        meal.isOpen = !meal.isOpen;
                      });
                    },
                  ))
            ],
          ),
          openColumn
        ]));
  }

  mealName(String meal) {
    Image image = Image(image: AssetImage('./assets/images/breakfast.png'));
    ;
    if (meal == "Lunch") {
      image = Image(image: AssetImage('./assets/images/lunch.png'));
    }

    if (meal == "Dinner") {
      image = Image(image: AssetImage('./assets/images/dinner.png'));
    }
    if (meal == "Snacks") {
      image = Image(image: AssetImage('./assets/images/snacks.png'));
    }
    if (meal == "Activity") {
      image = Image(image: AssetImage('./assets/images/activty.png'));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          meal,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: ClipOval(
            child: image,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
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
                //ask api for nutrition date:

                DishData dishData;
                fetchDishData(meal.dishController.text.trim(), meal.measurement,
                        meal.amountController.text.trim())
                    .then((value) {
                  dishData = value;

                  DishModel newDish = DishModel(
                      type: meal.dishController.text.trim(),
                      measurement: meal.measurement,
                      amount: meal.amountController.text.trim(),
                      data: dishData);

                  meal.dishes.add(newDish);

                  //update firebase:

                  meal.dishController.clear();
                  //meal.measurementController.clear();
                  meal.amountController.clear();
                  setState(() {
                    meal.isAdd = !meal.isAdd;
                  });
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
          width: 5,
        ),
        SizedBox(width: 150, child: foodfield(meal)),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 120,
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
            onChanged: (item) {
              meal.measurement = item!;
              setState(() => selectedMeaserment = item);
            },
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
        SizedBox(width: 80, child: amountfield(meal))
      ]),
    );
  }

  Row itemRow(String meal, DishModel dish) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 0),
        SizedBox(width: 100, child: Text(dish.type)),
        SizedBox(width: 100, child: Text(dish.amount + " " + dish.measurement)),
        SizedBox(width: 50, child: Text(dish.data.getCalories().toString())),
        SizedBox(width: 0),
        SizedBox(
            width: 10,
            child: IconButton(
                onPressed: () {
                  int index = currentDay.mealsIndex[meal]!;
                  setState(() {
                    currentDay.meals[index].dishes.remove(dish);
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.trash,
                  size: 15,
                ))),
        SizedBox(
            width: 10,
            child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.pencil,
                  size: 15,
                ))),
        SizedBox(width: 5),
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

  void updateCurrentDay(String dataString) {
    setState(() {
      dateS = dataString;

      //close the previos day meal Containers:
      closeCurrentDayMealContainers();

      //check if the day map contain this day:
      if (days.containsKey(dataString)) {
        currentDay = days[dataString]!;
      } else {
        Day newDay = Day(date: dataString,meals:getDayMeals() );
        days[dataString] = newDay;
        currentDay = newDay;
      }
    });
  }
  
  void closeCurrentDayMealContainers() {
    for (MealModel meal in currentDay.meals){
      meal.isAdd =false;
      meal.isOpen = false;
    }
  }

  
}

