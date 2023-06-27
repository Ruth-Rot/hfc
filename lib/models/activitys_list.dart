import 'package:flutter/cupertino.dart';
import 'package:hfc/models/activity.dart';

class ActivityList {
  late bool isAdd = false;
  late bool isOpen = false;
  late TextEditingController durationController = TextEditingController();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<Activity> items = [];
  late String type = "Running";
  late String subtype = "5 mph (12 minute mile)";
  ActivityList({required this.items});

  toJson() {
    List build = [];
    for (var item in items) {
      build.add(item.toJson());
    }
    return {"items": build};
  }

  restart() {
    type = "Running";
    subtype = "5 mph (12 minute mile)";
    durationController.clear();
  }

  getHeight() {
    if (isOpen == false) {
      return 70.0;
    }
    double basic = 100;
    if (isAdd == true) {
      basic += 140;
    }
    basic += 50 * items.length;
    return basic;
  }

  getCalories() {
    double sum = 0.0;
    for (Activity act in items) {
      sum += act.getCalories();
    }
    return sum;
  }

  Map<String, List<String>> getActivitesMap() {
    return {
      "Running": [
        "5 mph (12 minute mile)",
        "5.2 mph (11.5 minute mile)",
        "6 mph (10 min mile)",
        "6.7 mph (9 min mile)",
        "7 mph (8.5 min mile)",
        "8 mph (7.5 min mile)",
        "8.6 mph (7 min mile)",
        "9 mph (6.5 min mile)",
        "10 mph (6 min mile)"
      ],
      "Swimming": [
        "laps, freestyle, fast",
        "laps, freestyle, slow",
        "backstroke",
        "breaststroke",
        "butterfly",
        "leisurely, not laps",
        "sidestroke",
        "synchronized",
        "treading water, fast, vigorous",
        "treading water, moderate"
      ],
      "Ball games": [
        "Basketball game, competitive",
        "Playing basketball, non game",
        "Basketball, officiating",
        "Basketball, wheelchair",
        "Coaching: football, basketball, soccer…",
        "Football, competitive",
        "Football, touch, flag, general",
        "Football or baseball, playing catch",
        "Handball",
      ],
      "Walking": [
        "Golf, walking and carrying clubs",
        "Golf, walking and pulling clubs",
        "Horseback riding, walking",
        "Walking downstairs",
        "Pushing stroller or walking with children",
        "Race walking",
        "Walking using crutches",
        "Walking the dog",
        "Walking, under 2.0 mph, very slow",
        "Walking 2.0 mph, slow",
      ],
      "Cycling": [
        "Cycling, mountain bike, bmx",
        "Cycling, <10 mph, leisure bicycling",
        "Cycling, >20 mph, racing",
        "Cycling, 10-11.9 mph, light",
        "Cycling, 12-13.9 mph, moderate",
        "Cycling, 14-15.9 mph, vigorous",
        "Cycling, 16-19 mph, very fast, racing",
        "Unicycling",
        "Stationary cycling, very light",
        "Stationary cycling, light",
      ],
      "Skiing": [
        "Skiing, water skiing",
        "Cross country snow skiing, slow",
        "Cross country skiing, moderate",
        "Cross country skiing, vigorous",
        "Cross country skiing, racing",
        "Cross country skiing, uphill",
        "Snow skiing, downhill skiing, light",
        "Downhill snow skiing, moderate",
        "Downhill snow skiing, racing",
      ],
      "Yoga": ["Stretching, hatha yoga"],
      "Dancing": [
        "Ballroom dancing, slow",
        "Ballroom dancing, fast",
        "Ballet, twist, jazz, tap",
      ],
      "Climbing": [
        "Rock climbing, ascending rock",
        "Rock climbing, rappelling",
        "Climbing hills, carrying up to 9 lbs",
        "Climbing hills, carrying 10 to 20 lb",
        "Climbing hills, carrying 21 to 42 lb",
        "Climbing hills, carrying over 42 lb",
        "Rock climbing, mountain climbing",
      ],
    };
  }

  String getActivite() {
    return subtype.substring(1);
  }
}
