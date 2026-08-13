// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_wildcard_page_nav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StWildcardPageNavAction _$StWildcardPageNavActionFromJson(
        Map<String, dynamic> json) =>
    StWildcardPageNavAction(
      navigationType: $enumDecodeNullable(
              _$WildcardPageNavTypeEnumMap, json['navigationType']) ??
          WildcardPageNavType.push,
      wildcardPage: json['wildcardPage'] as String,
      arguments: json['arguments'] as Map<String, dynamic>?,
      result: json['result'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StWildcardPageNavActionToJson(
        StWildcardPageNavAction instance) =>
    <String, dynamic>{
      'navigationType': _$WildcardPageNavTypeEnumMap[instance.navigationType]!,
      'wildcardPage': instance.wildcardPage,
      'arguments': instance.arguments,
      'result': instance.result,
      'actionType': instance.actionType,
    };

const _$WildcardPageNavTypeEnumMap = {
  WildcardPageNavType.push: 'push',
  WildcardPageNavType.pushReplacement: 'pushReplacement',
  WildcardPageNavType.pushAndRemoveAll: 'pushAndRemoveAll',
  WildcardPageNavType.pushNamed: 'pushNamed',
  WildcardPageNavType.pushNamedAndRemoveAll: 'pushNamedAndRemoveAll',
  WildcardPageNavType.pushReplacementNamed: 'pushReplacementNamed',
  WildcardPageNavType.pop: 'pop',
  WildcardPageNavType.popAll: 'popAll',
};
