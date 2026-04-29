import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:testlive/HomePage/HomeViewController.dart';
import 'package:testlive/main.dart';

void main() {


  setUp(() {
    Get.testMode = true;

    // Get.lazyPut(() => HomeController());
    // Get.put(APIService()); // if used
    // Add other dependencies used in ChannelGrid
  });

  tearDown(() {
    Get.reset(); // clean up after each test
  });

}
