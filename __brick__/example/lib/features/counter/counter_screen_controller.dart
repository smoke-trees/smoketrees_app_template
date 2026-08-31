import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterScreenController extends GetxController {
  final count = 0.obs;

  void increment() => count++;
  void decrement() => count--;
  void reset() => count.value = 0;
}
