// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wildcard_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WildcardPage _$WildcardPageFromJson(Map<String, dynamic> json) => WildcardPage(
  children: (json['children'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, StacWidget.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$WildcardPageToJson(WildcardPage instance) =>
    <String, dynamic>{
      'children': instance.children.map((k, e) => MapEntry(k, e.toJson())),
      'type': instance.type,
    };
