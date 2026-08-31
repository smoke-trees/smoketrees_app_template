import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'counter_screen.g.dart';

@JsonSerializable()
class CounterScreen extends StacWidget {
  const CounterScreen({this.title});

  final String? title;

  @override
  String get type => 'counter_screen';

  factory CounterScreen.fromJson(Map<String, dynamic> json) =>
      _$CounterScreenFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CounterScreenToJson(this);
}
