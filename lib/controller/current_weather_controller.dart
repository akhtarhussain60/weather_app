import 'dart:convert';

import 'package:get/get.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:http/http.dart' as http;

class CurrentWeatherController extends GetxController {
  var current_weather;

  @override
  void onInit() {
    current_weather = getCurrentWeather();
    super.onInit();
  }

  Future getCurrentWeather() async {
    var link =
        "https://api.openweathermap.org/data/2.5/weather?lat=40.776676&lon=-73.971321&appid=1867f0f7ecaa0ab05fed7a8544857345&units=metric";

    var res = await http.get(Uri.parse(link));
    if (res.statusCode == 200) {
      var data = currentWeatherFromJson(res.body.toString());
      print("============ Current Weather Response ============");
      return data;
    } else {
      return "------------------Error Response: Current Weather-------------------";
    }
  }
}
