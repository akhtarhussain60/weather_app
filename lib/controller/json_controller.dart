import 'dart:async';

import 'package:get/get.dart';

class JsonController extends GetxController {
  RxInt currentIndex = 0.obs;
  late Timer timer;

  List json_files = [
    "assets/json/numOne.json",
    "assets/json/numTwo.json",
    "assets/json/numThree.json",
    "assets/json/numFour.json",
    "assets/json/numFive.json",
  ];

  @override
  void onInit() {
    _startImages();
    super.onInit();
  }

  void _startImages() {
    timer = Timer.periodic(const Duration(seconds: 8), (contex) {
      _changeImage();
    });
  }

  void _changeImage() {
    if (currentIndex.value < json_files.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
    }
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
