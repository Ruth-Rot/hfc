import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../headers/circle_header.dart';
import '../common/fill_your_details.dart';
import '../models/day.dart';
import '../models/user.dart';
import '../reposiontrys/user_reposiontry.dart';

class ProgressPage extends StatefulWidget {
  final UserModel userModel;
  final UserReposiontry userReposiontry;

  const ProgressPage(
      {Key? key, required this.userModel, required this.userReposiontry})
      : super(key: key);

  @override
  State<ProgressPage> createState() {
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

  final TextStyle _textStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  late TooltipBehavior _tooltipBehavior;
  @override
  initState() {
    if (widget.userModel.fillDetails == true) {
      _consumChartData = getCounsumChartData();
      _dailyChartData = getdailyChartData();
      _tooltipBehavior = TooltipBehavior(enable: true);
      _pieChartData = getMonthAveragePie();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userModel.fillDetails == false) {
      return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    progressHeader(context),
                    const SizedBox(
                      height: 30,
                    ),
                    fillYourDetails()
                  ]))));
    } else {
      return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    progressHeader(context),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Column(children: [
                        card(
                            iconCard(widget.userModel.weight.toString(),
                                FontAwesomeIcons.weightScale, "Weight"),
                            90,
                            100),
                        const SizedBox(
                          height: 10,
                        ),
                        card(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Active level",
                                  style: _textStyle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.userModel.activityLevel
                                      .replaceAll("level_", ""),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const Text(
                                  "out of 6",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            90,
                            100),
                        const SizedBox(
                          height: 10,
                        ),
                        card(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Goal",
                                  style: _textStyle,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        widget.userModel.purpose,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            90,
                            100),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      card(
                          SfCircularChart(
                              title: ChartTitle(
                                  text:
                                      "Distribution of average calorie intake",
                                  textStyle: _textStyle),
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
                    const SizedBox(
                      height: 20,
                    ),
                    card(
                        SfCartesianChart(
                          title: ChartTitle(
                            text: "Daily ckal consumption in this month",
                            textStyle: _textStyle,
                          ),
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

  Container progressHeader(BuildContext context) {
    return circleHeader(
        context,
        const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.chartLine,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Statistics",
                style: TextStyle(color: Colors.white, fontSize: 30),
              )
            ]));
  }

  iconCard(String num, IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: _textStyle,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              num,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //white container card
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

  // collect ckal recommended consum data of every day in this month:
  List<CkalConsumptionData> getCounsumChartData() {
    final List<CkalConsumptionData> charData = [];
    DateTime now = DateTime.now();

    for (String date in widget.userModel.diary.keys) {
      Day day = widget.userModel.diary[date]!;
      DateTime time = DateFormat.yMMMMd('en_US').parse(date);

      //check it belong to this month:
      if (now.month == time.month) {
        charData.add(CkalConsumptionData(time.day,
            day.getDailyConsumptionCkal(widget.userModel.dailyCalories)));
      }
    }
    charData.sort((a, b) => a.day.compareTo(b.day));

    return charData;
  }

  List<CkalConsumptionData> getdailyChartData() {
    final List<CkalConsumptionData> charData = [];
    DateTime now = DateTime.now();
    for (String date in widget.userModel.diary.keys) {
      Day day = widget.userModel.diary[date]!;
      //check the day belong to this month:
      DateTime time = DateFormat.yMMMMd('en_US').parse(date);
      if (now.month == time.month) {
        charData
            .add(CkalConsumptionData(time.day, widget.userModel.dailyCalories));
      }
    }
    charData.sort((a, b) => a.day.compareTo(b.day));

    return charData;
  }

  getMonthAveragePie() {
    double lunch = 0, breakfast = 0, dinner = 0, snacks = 0;
    int counter = 0;

    DateTime now = DateTime.now();
    for (String date in widget.userModel.diary.keys) {
      Day day = widget.userModel.diary[date]!;
      //check the day belong to this month:
      DateTime time = DateFormat.yMMMMd('en_US').parse(date);
      if (now.month == time.month) {
        counter++;
        breakfast += day.meals[0].getCalories();
        lunch += day.meals[1].getCalories();
        dinner += day.meals[2].getCalories();
        snacks += day.meals[3].getCalories();
      }
    }
    return [
      DailyPieChartData(
        breakfast / counter,
        "Breakfast",
      ),
      DailyPieChartData(
        lunch / counter,
        "Lunch",
      ),
      DailyPieChartData(
        dinner / counter,
        "Dinner",
      ),
      DailyPieChartData(
        snacks / counter,
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
