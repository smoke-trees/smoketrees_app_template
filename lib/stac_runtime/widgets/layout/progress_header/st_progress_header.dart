import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_progress_header.g.dart';

/// A progress header showing circular progress with count and message.
@JsonSerializable(explicitToJson: true)
class StProgressHeader extends StacWidget {
  const StProgressHeader({
    required this.total,
    required this.completed,
    this.backgroundColor,
    this.progressColor,
    this.completedMessages,
    this.zeroMessages,
    this.partialMessages,
  });

  final int total;
  final int completed;
  final String? backgroundColor;
  final String? progressColor;
  final List<String>? completedMessages;
  final List<String>? zeroMessages;
  final List<String>? partialMessages;

  @override
  String get type => 'st_progress_header';

  factory StProgressHeader.fromJson(Map<String, dynamic> json) =>
      _$StProgressHeaderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StProgressHeaderToJson(this);
}
