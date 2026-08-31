import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_page_view.g.dart';

@JsonSerializable(explicitToJson: true)
class StPageView extends StacWidget {
  final List<StacWidget> children;
  final bool? pageSnapping;
  final bool? reverse;

  const StPageView({required this.children, this.pageSnapping, this.reverse});

  @override
  String get type => 'st_page_view';

  factory StPageView.fromJson(Map<String, dynamic> json) =>
      _$StPageViewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StPageViewToJson(this);
}
