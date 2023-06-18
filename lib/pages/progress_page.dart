import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hfc/models/recipe.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import '../common/circle_header.dart';
import '../models/day.dart';
import '../models/user.dart';
import '../reposiontrys/rate_reposiontry.dart';
import '../reposiontrys/user_reposiontry.dart';

class ProgressPage extends StatefulWidget {
  final UserModel userModel;
  final UserReposiontry userReposiontry;

  ProgressPage(
      {Key? key,
      required this.userModel,
      required UserReposiontry this.userReposiontry})
      : super(key: key);

  @override
  __ProgressPageState createState() {
    return __ProgressPageState();
  }
}

class __ProgressPageState extends State<ProgressPage> {
  List<CkalConsumptionData> _consumChartData = [];
  List<CkalConsumptionData> _dailyChartData = [];
  List<DailyPieChartData> _pieChartData = [];

  Map<String, int> goals = {
    "Maintain weight": 1,
    "Mild weight loss": 2,
    "Weight loss": 3,
    "Extreme weight loss": 4,
    "Mild weight gain": 5,
    "Weight gain": 6,
    "Extreme weight gain": 7
  };

  late TooltipBehavior _tooltipBehavior;
  @override
  initState() {
    if (widget.userModel.fillDetails == true) {
      _consumChartData = getCounsumChartData();
      _dailyChartData = getdailyChartData();
      _tooltipBehavior = TooltipBehavior(enable: true);
      _pieChartData = getDailyPie();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userModel.fillDetails == false) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You haven't fill your personal details yet",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
                height: 300,
                child:
                    Image(image: AssetImage('./assets/images/splash_bot.png'))),
            SizedBox(
              height: 30,
            ),
            Text("Fill your details in the chat bot",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
          ],
        ),
      );
    } else {
      return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    circleHeader(
                        context,
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Progress",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ])),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 20,
                      ),
                      Column(children: [
                        card(
                            iconCard(widget.userModel.weight.toString(),
                                FontAwesomeIcons.weightScale, "Weight"),
                            90,
                            100),
                        SizedBox(
                          height: 10,
                        ),
                        card(
                            iconCard(
                                widget.userModel.activity_level
                                    .replaceAll("level_", ""),
                                FontAwesomeIcons.personRunning,
                                "Active level"),
                            90,
                            100),
                        SizedBox(
                          height: 10,
                        ),
                        card(
                            iconCard(goals[widget.userModel.purpose].toString(),
                                FontAwesomeIcons.bullseye, "Goal level"),
                            90,
                            100),
                      ]),
                      SizedBox(
                        width: 10,
                      ),
                      card(
                          SfCircularChart(
                              title: ChartTitle(
                                  text: "Today ckal consumption",
                                  
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              legend: Legend(
                                  isVisible: true,
        
                                  toggleSeriesVisibility: true,
                                  position: LegendPosition.bottom),
                                                            tooltipBehavior: _tooltipBehavior,

                              series: <CircularSeries>[
                                PieSeries<DailyPieChartData, String>(
                                  dataSource: _pieChartData,
                                  xValueMapper: (data, _) => data.label,
                                  yValueMapper: (data, _) => data.num,
                                  explode: true,
                                  // All the segments will be exploded
                                  explodeAll: true,
                                )
                              ]),
                          290,
                          265),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    card(
                        SfCartesianChart(
                          title: ChartTitle(
                            text:
                                "Daily ckal consumption in this month",
                                                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          //backgroundColor: Colors.yellow,
                          legend: Legend(
                              isVisible: true, position: LegendPosition.bottom),
                          tooltipBehavior: _tooltipBehavior,
                          series: <ChartSeries>[
                            LineSeries(
                                name: "Daily ckal consumption",
                                dataSource: _consumChartData,
                                xValueMapper: (data, _) => data.day,
                                yValueMapper: (data, _) => data.ckal,
                                enableTooltip: true,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    alignment: ChartAlignment.near)),
                            LineSeries(
                              name: "Recommended daily ckal",
                              dataSource: _dailyChartData,
                              xValueMapper: (data, _) => data.day,
                              yValueMapper: (data, _) => data.ckal,
                              enableTooltip: true,
                              // dataLabelSettings:  DataLabelSettings(isVisible: true, alignment: ChartAlignment.near)
                            )
                          ],
                          primaryXAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                        ),
                        300,
                        380),
                      ]))));
    }
  }

  iconCard(String num, IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              "${num}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Container card(Widget content, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: content,
    );
  }

  List<CkalConsumptionData> getCounsumChartData() {
    final List<CkalConsumptionData> charData = [];
    for (String date in widget.userModel.diary.keys) {
      Day day = widget.userModel.diary[date]!;
      DateTime time = DateFormat.yMMMMd('en_US').parse(date);
      charData.add(CkalConsumptionData(time.day,
          day.getDailyConsumptionCkal(widget.userModel.dailyCalories)));
    }
    charData.sort((a, b) => a.day.compareTo(b.day));

    return charData;
  }

  List<CkalConsumptionData> getdailyChartData() {
    final List<CkalConsumptionData> charData = [];
    for (String date in widget.userModel.diary.keys) {
      Day day = widget.userModel.diary[date]!;
      //check it belong to this month!!!!!
      DateTime time = DateFormat.yMMMMd('en_US').parse(date);
      charData
          .add(CkalConsumptionData(time.day, widget.userModel.dailyCalories));
    }
    charData.sort((a, b) => a.day.compareTo(b.day));

    return charData;
  }

  getDailyPie() {
    String date = DateFormat.yMMMMd('en_US').format(DateTime.now());
    double breakfast = widget.userModel.diary[date]?.meals[0].getCalories();
    return [
      DailyPieChartData(breakfast, "Breakfast"),
      DailyPieChartData(
        widget.userModel.diary[date]?.meals[1].getCalories(),
        "Lunch",
      ),
      DailyPieChartData(
        widget.userModel.diary[date]?.meals[2].getCalories(),
        "Dinner",
      ),
      DailyPieChartData(
        widget.userModel.diary[date]?.meals[3].getCalories(),
        "Snacks",
      ),
    ];
  }
}

class CkalConsumptionData {
  CkalConsumptionData(this.day, this.ckal);
  final int day;
  final double ckal;
}

class DailyPieChartData {
  DailyPieChartData(this.num, this.label);
  final double num;
  final String label;
}
