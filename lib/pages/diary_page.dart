import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/headers/circle_header.dart';
import 'package:hfc/models/activitys_list.dart';
import 'package:hfc/models/dish.dart';
import 'package:hfc/models/user.dart';
import 'package:hfc/reposiontrys/user_reposiontry.dart';
import 'package:intl/intl.dart';
import '../common/fill_your_details.dart';
import '../common/radial_progress.dart';
import '../common/stick_progress.dart';
import '../common/theme_helper.dart';
import '../models/activity.dart';
import '../models/day.dart';
import '../models/dish_data.dart';
import '../models/meal.dart';
import '../reposiontrys/activity_api_reposiontry.dart';
import '../reposiontrys/nutrition_api_reposiontry.dart';
import 'package:hfc/controllers/dish_controller.dart';

class DiaryPage extends StatefulWidget {
  final UserModel userModel;
  final UserReposiontry userReposiontry;
  const DiaryPage(
      {Key? key, required this.userModel, required this.userReposiontry})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __DiaryPageState();
  }
}

class __DiaryPageState extends State<DiaryPage> {
  var date = DateTime.now();
  Map<String, Day> days = {};
  Day currentDay = Day(
      date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
      meals: getDayMeals(),
      activitys: ActivityList(items: []));
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
  @override
  dispose() {
    widget.userReposiontry.updateDiary(days, widget.userModel.email);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateS = DateFormat.yMMMMd('en_US').format(date);
        if(widget.userModel.fillDetails == true){

    days = widget.userModel.diary;
    if (days.containsKey(dateS) == false) {
      days[dateS] = currentDay;
    } else {
      currentDay = days[dateS]!;
    }
    widget.userReposiontry.updateDiary(days, widget.userModel.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (widget.userModel.fillDetails == true) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              circleHeader(context, dateWidget()),
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
                          (currentDay.getRemainCalories(
                                  widget.userModel.dailyCalories) /
                              currentDay.getDailyCalories(
                                  widget.userModel.dailyCalories))),
                      remain: currentDay
                          .getRemainCalories(widget.userModel.dailyCalories),
                    ),
                    const SizedBox(
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
                        const SizedBox(
                          width: 15,
                        ),
                        StickProgress(
                          ingredient: "Carbs",
                          progress: currentDay.getDailyProtein() / 250.0,
                          progressColor: Colors.red,
                          height: 160,
                        ),
                        const SizedBox(
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
                height: 380,
                width: 400,
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: currentDay.meals.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < 4) {
                        return SizedBox(
                          height: currentDay.meals[index].getHeight() + 20.0,
                          child: mealContainer(currentDay.meals[index]),
                        );
                      } else {
                        return SizedBox(
                          height: currentDay.activitys.getHeight() + 20.0,
                          child: actvitiyContainer(currentDay.activitys),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                          height: 5,
                        )),
              ),
            ],
          ),
        ),
      );
    } else {
      return 
       Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              circleHeader(context, dateWidget()), const SizedBox(height: 30,),fillYourDetails()])
        )
       );
    }
  }

  Row dateWidget() {
    return Row(
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
                String dataString = DateFormat.yMMMMd('en_US').format(date);
                updateCurrentDay(dataString);
              },
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              )),
          const SizedBox(
            width: 30,
          ),
          Text(
            dateS,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(
            width: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              onPressed: () {
                //add a day
                if (date.day != DateTime.now().day) {
                  date = date.add(const Duration(days: 1));
                  String dataString = DateFormat.yMMMMd('en_US').format(date);
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
        ]);
  }

  mealContainer(MealModel meal) {
    double height = meal.getHeight();
    return SizedBox(
      height: height + 20.0,
      child: Stack(children: [
        Positioned(
            left: 10,
            child: SizedBox(height: height, width: 380, child: mealCard(meal))),
        meal.isOpen == true
            ? Positioned(bottom: 0, left: 180, child: addButtonMeal(meal))
            : Container()
      ]),
    );
  }

  Container mealCard(MealModel meal) {
    Widget openColumn = Container();
    if (meal.isOpen) {
      openColumn = Column(children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50.0 * meal.dishes.length,
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: meal.dishes.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: itemRow(meal.type, meal.dishes[index], index),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Container()),
        ),
        const SizedBox(
          height: 10,
        ),
        meal.isAdd == false ? Container() : addItemForm(meal),
        const Divider(),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Text("  total calories: "),
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
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              labelName(meal.type),
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

  Container activityCard(ActivityList activitys) {
    Widget openColumn = Container();
    if (activitys.isOpen) {
      openColumn = Column(children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50.0 * activitys.items.length,
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: activitys.items.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 50,
                  child: activityitemRow(activitys.items[index],index),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Container()),
        ),
        const SizedBox(
          height: 10,
        ),
        activitys.isAdd == false ? Container() : addActivityItemForm(activitys),
        const Divider(),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Text("  total calories: "),
              Text(activitys.getCalories().toString()),
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
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              labelName("Activity"),
              Positioned(
                  left: 10,
                  child: IconButton(
                    icon: FaIcon(
                      activitys.isOpen
                          ? FontAwesomeIcons.chevronUp
                          : FontAwesomeIcons.chevronDown,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        activitys.isOpen = !activitys.isOpen;
                      });
                    },
                  ))
            ],
          ),
          openColumn
        ]));
  }

  labelName(String meal) {
    Image image =
        const Image(image: AssetImage('./assets/images/breakfast.png'));

    if (meal == "Lunch") {
      image = const Image(image: AssetImage('./assets/images/lunch.png'));
    }

    if (meal == "Dinner") {
      image = const Image(image: AssetImage('./assets/images/dinner.png'));
    }
    if (meal == "Snacks") {
      image = const Image(image: AssetImage('./assets/images/snacks.png'));
    }
    if (meal == "Activity") {
      image = const Image(image: AssetImage('./assets/images/activty.png'));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          meal,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: ClipOval(
            child: image,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  ClipOval addButtonMeal(MealModel meal) {
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
                fetchDishData(meal.dishController.text.trim(),
                        meal.amountController.text.trim(), meal.measurement,)
                    .then((value) {
                  dishData = value;

                  DishModel newDish = DishModel(
                      type: meal.dishController.text.trim(),
                      measurement: meal.measurement,
                      amount: meal.amountController.text.trim(),
                      data: dishData,
                      controller: DishController());

                  meal.dishes.add(newDish);

                  if(widget.userModel.fillDetails == true){
                  //update firebase:
                  widget.userReposiontry
                      .updateDiary(days, widget.userModel.email);
                  }

                  meal.clear();
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

  ClipOval addButtonActivity(ActivityList activitys) {
    return ClipOval(
      child: Material(
        color:
            activitys.isAdd == false ? Colors.blue : Colors.red, // Button color
        child: InkWell(
          onTap: () {
            if (activitys.isAdd == true) {
              if (activitys.formKey.currentState!.validate()) {
                //ask api for nutrition date:

                Activity activity;

                fetchActivityData(
                        activitys.getActivite(),
                        widget.userModel.weight,
                        activitys.durationController.text.trim())
                    .then((value) {
                  activity = value;

                  activitys.items.add(activity);

                                    if(widget.userModel.fillDetails == true){

                  //update firebase
                  widget.userReposiontry
                      .updateDiary(days, widget.userModel.email);
                                    }

                  setState(() {
                    activitys.isAdd = !activitys.isAdd;
                    activitys.restart();
                  });
                });
              }
            } else {
              setState(() {
                activitys.isAdd = !activitys.isAdd;
              });
            }
          },
          child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(activitys.isAdd == false ? Icons.add : Icons.check)),
        ),
      ),
    );
  }

  Form addItemForm(MealModel meal) {
    return Form(
      key: meal.formKey,
      child: Row(children: [
        const SizedBox(
          width: 5,
        ),
        SizedBox(width: 150, child: foodfield(meal)),
        const SizedBox(
          width: 5,
        ),
        dropDownListChooseMeal(meal),
        const SizedBox(
          width: 5,
        ),
        SizedBox(width: 90, child: amountfield(meal))
      ]),
    );
  }

  SizedBox dropDownListChooseMeal(MealModel meal) {
    return SizedBox(
      width: 120,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Measurement",
          labelStyle: const TextStyle(fontSize: 12),
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
        value: meal.measurement,
        onChanged: (item) {
          setState(() =>   meal.measurement = item!);
        },
        items: measurements
            .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 12),
                )))
            .toList(),
      ),
    );
  }

  dropDownListChooseActivity(ActivityList activtys, String label, int level) {
    String value;
    List<String> items;
    Map<String, List<String>> apiList = activtys.getActivitesMap();
    if (level == 1) {
      value = activtys.type;
      items = apiList.keys.toList();
    } else {
      value = apiList[activtys.type]![0];
      items = apiList[activtys.type]!;
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
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
      value: value,
      onChanged: (item) {
        if (level == 1) {
          activtys.type = item!;
        } else {
          (activtys.subtype = item!);
        }
        setState(() {
          if (level == 1) {
            activtys.type = item;
          } else {
            activtys.subtype = item;
          }
        });
      },
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
          .toList(),
    );
  }

  Row itemRow(String meal, DishModel dish, int indexD) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 0),
        SizedBox(width: 100, child: Text(dish.type)),
        SizedBox(width: 60, child: Text("${dish.amount} ${dish.measurement}")),
        SizedBox(width: 90, child: Text(dish.data.getCalories().toString())),
        const SizedBox(width: 0),
        SizedBox(
            width: 25,
            child: IconButton(
                onPressed: () {
                  int index = currentDay.mealsIndex[meal]!;
                  setState(() {
                    //change all not just local currentDay
                    currentDay.meals[index].dishes.remove(dish);
                    days[currentDay.date] = currentDay;
                  });
                },
                icon: const FaIcon(
                  FontAwesomeIcons.trash,
                  size: 20,
                ))),
        SizedBox(
            width: 25,
            child: IconButton(
                onPressed: () {
                  int indexM = currentDay.mealsIndex[meal]!;
                  editNutritionDialogBuilder(context, dish, indexM, indexD);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.pencil,
                  size: 20,
                ))),
        const SizedBox(width: 5),
      ],
    );
  }

  TextFormField nutritonField(label, hint, controller) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: ThemeHelper().textInputDecorationFoodForm(
        label,
        hint,
      ),
      controller: controller,
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter amount";
        }
        bool amountValidator =
            RegExp(r"[+-]?([0-9]*[.])?[0-9]+").hasMatch(value);
        if (!amountValidator) {
          return "Enter number";
        }
        return null;
      },
    );
  }

  TextFormField foodfield(MealModel meal) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: ThemeHelper().textInputDecorationFoodForm(
          "Dish",
          "what you ate?",
          const Icon(
            FontAwesomeIcons.utensils,
            size: 15,
          )),
      controller: meal.dishController,
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "Enter a dish";
        }
        bool dishValidator = RegExp(r"^[a-zA-Z\s]*$").hasMatch(value.trim());
        if (!dishValidator) {
          return "Enter Valid dish";
        }
        return null;
      },
    );
  }

  TextFormField amountfield(MealModel meal) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: ThemeHelper().textInputDecorationFoodForm(
        "Amount",
        "How much?",
      ),
      controller: meal.amountController,
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter amount";
        }
        bool amountValidator =
            RegExp(r"[+-]?([0-9]*[.])?[0-9]+").hasMatch(value);
        if (!amountValidator) {
          return "Enter number";
        }
        return null;
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
        Day newDay = Day(
            date: dataString,
            meals: getDayMeals(),
            activitys: ActivityList(items: []));
        days[dataString] = newDay;
        currentDay = newDay;
      }
    });
  }

  void closeCurrentDayMealContainers() {
    for (MealModel meal in currentDay.meals) {
      meal.isAdd = false;
      meal.isOpen = false;
    }
  }

  actvitiyContainer(ActivityList activitys) {
    double height = activitys.getHeight();
    return SizedBox(
      height: height + 20.0,
      child: Stack(children: [
        Positioned(
            left: 10,
            child: SizedBox(
                height: height, width: 380, child: activityCard(activitys))),
        activitys.isOpen == true
            ? Positioned(
                bottom: 0, left: 180, child: addButtonActivity(activitys))
            : Container()
      ]),
    );
  }

  activityitemRow(Activity item,int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 0),
        SizedBox(width: 180, child: Text(item.label.replaceAll(", ", "\n"))),
        SizedBox(width: 50, child: Text(item.duration.toString())),
        SizedBox(width: 50, child: Text(item.getCalories().toString())),
        const SizedBox(width: 0),
        SizedBox(
            width: 25,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    //change all not just local currentDay
                    currentDay.activitys.items.remove(item);
                    days[currentDay.date] = currentDay;
                  });
                },
                icon: const FaIcon(
                  FontAwesomeIcons.trash,
                  size: 20,
                ))),
        SizedBox(
            width: 25,
            child: IconButton(
                onPressed: () {
                  editActivityDialogBuilder(context, item, index);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.pencil,
                  size: 20,
                ))),
        const SizedBox(width: 5),
      ],
    );
  }

  addActivityItemForm(activitys) {
    return Form(
      key: activitys.formKey,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(width: 150, child: durationfield(activitys)),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: 175,
              child: dropDownListChooseActivity(activitys, "Activity", 1)),
        ]),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 330,
          child: dropDownListChooseActivity(activitys, "Type of activity", 2),
        ),
        const SizedBox(
          width: 5,
        ),
      ]),
    );
  }

  durationfield(ActivityList activitys) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: ThemeHelper().textInputDecorationFoodForm(
          "Duration",
          "minutes",
          const Icon(
            FontAwesomeIcons.clock,
            size: 15,
          )),
      controller: activitys.durationController,
      style: const TextStyle(fontSize: 12),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter your duration activity";
        }
        return null;
      },
    );
  }

  Future<void> editNutritionDialogBuilder(
      BuildContext context, DishModel dishModel, mealI, dishI) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('Edit nutrition values:'),
          content: SizedBox(
            height: 350,
            width: 200,
            child: Form(
              key: dishModel.controller.formKey,
              child: Column(
                children: [
                  const Text(
                    'Here you can edit the nutriton values of this dish\n',
                    textAlign: TextAlign.center,
                  ),
                  nutritonField(
                      "Ckal", "How much?", dishModel.controller.ckalController),
                  const Spacer(),
                  nutritonField("Crabs", "How much?",
                      dishModel.controller.crabsController),
                  const Spacer(),
                  nutritonField("Protein", "How much?",
                      dishModel.controller.proteinController),
                  const Spacer(),
                  nutritonField(
                      "Fat", "How much?", dishModel.controller.fatsController)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Return'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Apply'),
              onPressed: () {
                if (dishModel.controller.formKey.currentState!.validate()) {
                  // change nutrition:
                  if (mounted) {
                    setState(() {
                      dishModel.data = DishData(
                          calories: double.parse(
                              dishModel.controller.ckalController.text.trim()),
                          protein: double.parse(dishModel
                              .controller.proteinController.text
                              .trim()),
                          crabs: double.parse(
                              dishModel.controller.crabsController.text.trim()),
                          fat: double.parse(
                              dishModel.controller.fatsController.text.trim()));
                      currentDay.meals[mealI].dishes[dishI] = dishModel;
                      days[currentDay.date] = currentDay;
                    });
                  }
                  dishModel.controller.clear();

                                    if(widget.userModel.fillDetails == true){

                  //save changes:
                  widget.userReposiontry
                      .updateDiary(days, widget.userModel.email);
                  Navigator.of(context).pop();
                }
                }
              },
            ),
          ],
        );
      },
    );
  }

    Future<void> editActivityDialogBuilder(
      BuildContext context, Activity activity, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('Edit activity Ckal values:'),
          content: SizedBox(
            height: 140,
            width: 200,
            child: Form(
              key: activity.controller.formKey,
              child: Column(
                children: [
                  const Text(
                    'Here you can edit the ckal you burn in this activity\n',
                    textAlign: TextAlign.center,
                  ),
                  nutritonField(
                      "Ckal", "How much?", activity.controller.ckalController),
                    ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Return'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Apply'),
              onPressed: () {
                if (activity.controller.formKey.currentState!.validate()) {
                  // change nutrition:
                  if (mounted) {
                    setState(() {
                      activity.calories =  double.parse(
                              activity.controller.ckalController.text.trim());
                 
                      currentDay.activitys.items[index] =activity ;
                      days[currentDay.date] = currentDay;
                    });
                  }
                  activity.controller.clear();
                  if(widget.userModel.fillDetails == true){

                  //save changes:
                  widget.userReposiontry
                      .updateDiary(days, widget.userModel.email);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
