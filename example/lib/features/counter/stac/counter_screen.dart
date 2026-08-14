import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'counter_screen.g.dart';

@JsonSerializable()
class CounterScreen extends StacWidget {
  final String title;
  final String description;
  final int initialCount;

  const CounterScreen({
    required this.title,
    required this.description,
    required this.initialCount,
  });

  @override
  String get type => 'counter_screen';

  factory CounterScreen.fromJson(Map<String, dynamic> json) =>
      _$CounterScreenFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CounterScreenToJson(this);
}
