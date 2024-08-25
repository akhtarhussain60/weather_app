import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/hourly_weather_model.dart';

class HourlyWeatherController extends GetxController {
  var hourly_weather;

  @override
  void onInit() {
    super.onInit();
    hourly_weather = fetchHourlyWeather();
  }

  fetchHourlyWeather() async {
    var link =
        "https://api.openweathermap.org/data/2.5/forecast?lat=40.776676&lon=-73.971321&appid=1867f0f7ecaa0ab05fed7a8544857345";
    var res = await http.get(Uri.parse(link));
    if (res.statusCode == 200) {
      print("================ Hourly Weather Response ================");
      var data = hourlyWeatherFromJson(res.body.toString());
      print(
          "================ Hourly Weather Parsed Successfully ================");
      return data;
    } else {
      print(
          "-----------------Error Response: Hourly Weather---------------------");
    }
  }
}
