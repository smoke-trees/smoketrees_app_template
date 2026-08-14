import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';
import '../counter_screen_controller.dart';
import 'counter_screen.dart';

class CounterScreenParser extends StacParser<CounterScreen> {
  const CounterScreenParser();

  @override
  String get type => 'counter_screen';

  @override
  CounterScreen getModel(Map<String, dynamic> json) =>
      CounterScreen.fromJson(json);

  @override
  Widget parse(BuildContext context, CounterScreen model) {
    return _CounterScreenWidget(model: model);
  }
}

class _CounterScreenWidget extends StatefulWidget {
  const _CounterScreenWidget({required this.model});

  final CounterScreen model;

  @override
  State<_CounterScreenWidget> createState() => _CounterScreenWidgetState();
}

class _CounterScreenWidgetState extends State<_CounterScreenWidget> {
  late CounterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CounterController(widget.model.initialCount));
  }

  @override
  void dispose() {
    Get.delete<CounterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.model.description),
            Obx(
              () => Text(
                '${_controller.count.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _controller.decrement(1),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () => _controller.increment(1),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
