// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_page_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StPageView _$StPageViewFromJson(Map<String, dynamic> json) => StPageView(
      children: (json['children'] as List<dynamic>)
          .map((e) => StacWidget.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageSnapping: json['pageSnapping'] as bool?,
      reverse: json['reverse'] as bool?,
    );

Map<String, dynamic> _$StPageViewToJson(StPageView instance) =>
    <String, dynamic>{
      'children': instance.children.map((e) => e.toJson()).toList(),
      'pageSnapping': instance.pageSnapping,
      'reverse': instance.reverse,
      'type': instance.type,
    };
