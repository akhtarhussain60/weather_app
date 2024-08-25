import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/controller/current_weather_controller.dart';
import 'package:weather_app/controller/hourly_weather_controller.dart';
import 'package:weather_app/controller/json_controller.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';
import 'package:weather_app/src/colors/colors.dart';
import 'package:weather_app/src/fonts/fonts.dart';
import 'package:weather_app/src/src.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String bg_image = "assets/images/bg.png";

  final time = DateFormat("jm").format(
    DateTime.now(),
  );
  final date = DateFormat("MMMMd").format(
    DateTime.now(),
  );

  final JsonController image_slider = Get.put(JsonController());
  final CurrentWeatherController currentWeatherController =
      Get.put(CurrentWeatherController());
  final HourlyWeatherController hourlyWeatherController =
      Get.put(HourlyWeatherController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(bg_image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.black.withOpacity(0.4),
                  BlendMode.darken,
                ))),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: currentWeatherController.current_weather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final CurrentWeather current =
                        snapshot.data as CurrentWeather;
                    List temperature = [
                      {
                        "Icon": "assets/icons/humidity.png",
                        "name": "HUMIDITY",
                        "value": "${current.main.humidity.toString()}%",
                      },
                      {
                        "Icon": "assets/icons/wind.png",
                        "name": "WIND",
                        "value": "${current.wind.speed.toString()} km/h",
                      },
                      {
                        "Icon": "assets/icons/pressure.png",
                        "name": "FEELS LIKE",
                        "value": "${current.main.feelsLike}$degree",
                      },
                    ];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 35,
                              color: AppColors.white,
                            ),
                            Text(
                              current.name.toString(),
                              style: TextStyle(
                                  fontFamily: Fonts.mod,
                                  color: AppColors.white,
                                  fontSize: 32),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Today, ",
                              style: TextStyle(
                                  fontFamily: Fonts.rob,
                                  color: AppColors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                date,
                                style: TextStyle(
                                    fontFamily: Fonts.rob,
                                    color: AppColors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Text(
                          time,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Lottie.asset(
                                image_slider.json_files[
                                    image_slider.currentIndex.value],
                                height: 130,
                                width: 130,
                              );
                            }),
                            Text(
                              "${current.main.temp.toString()}$degree",
                              style: TextStyle(
                                  fontSize: 60,
                                  color: AppColors.white,
                                  fontFamily: Fonts.mod),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          current.weather[0].description,
                          style: TextStyle(
                              fontFamily: Fonts.rob,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white),
                        ),
                        SizedBox(height: height * 0.04),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                                temperature.length,
                                (index) => Container(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            temperature[index]["Icon"],
                                            color: AppColors.white,
                                          ),
                                          Text(
                                            temperature[index]["name"],
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontFamily: Fonts.rob),
                                          ),
                                          Text(
                                            temperature[index]["value"],
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontFamily: Fonts.rob),
                                          )
                                        ],
                                      ),
                                    ))),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder(
                future: hourlyWeatherController.hourly_weather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final HourlyWeather hourly = snapshot.data as HourlyWeather;

                    return Container(
                      height: height * 0.23,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: hourly.list.length > 4
                            ? hourly.list.sublist(0, 4).map((weatherItem) {
                                var time = DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    weatherItem.dt.toInt() * 1000,
                                  ),
                                );

                                return Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        time.toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: AppColors.white,
                                          fontFamily: Fonts.rob,
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/weather/${weatherItem.weather[0].icon}.png",
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        "${weatherItem.main.temp.toString()}$degree",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.white,
                                          fontFamily: Fonts.rob,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()
                            : [],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
