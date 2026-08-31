import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import '../counter_screen_controller.dart';
import 'counter_screen.dart';

class CounterScreenParser extends StacParser<CounterScreen> {
  @override
  String get type => 'counter_screen';

  @override
  CounterScreen getModel(Map<String, dynamic> json) =>
      CounterScreen.fromJson(json);

  @override
  Widget parse(BuildContext context, CounterScreen model) {
    final controller = Get.put(CounterScreenController());

    return Scaffold(
      appBar: AppBar(
        title: Text(model.title ?? 'Counter'),
      ),
      body: Center(
        child: Obx(
          () => Text(
            '${controller.count.value}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'increment',
            onPressed: controller.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: controller.decrement,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'reset',
            onPressed: controller.reset,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
