import 'package:get/get.dart';

class CounterController extends GetxController {
  CounterController(int? initialCount) : count = (initialCount ?? 0).obs;

  final RxInt count;

  void increment(int value) => count.value += value;
  void decrement(int value) => count.value -= value;
}
