import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'wildcard_page.g.dart';

@JsonSerializable(explicitToJson: true)
class WildcardPage extends StacWidget {
  const WildcardPage({required this.children});

  final Map<String, StacWidget> children;

  @override
  String get type => 'st_wildcard_page';

  factory WildcardPage.fromJson(Map<String, dynamic> json) =>
      _$WildcardPageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WildcardPageToJson(this);
}
