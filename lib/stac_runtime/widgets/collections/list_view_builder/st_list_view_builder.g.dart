// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_list_view_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StListViewBuilder _$StListViewBuilderFromJson(Map<String, dynamic> json) =>
    StListViewBuilder(
      endpoint: json['endpoint'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      itemTemplate:
          StacWidget.fromJson(json['itemTemplate'] as Map<String, dynamic>),
      loadingWidget: json['loadingWidget'] as Map<String, dynamic>?,
      errorWidget: json['errorWidget'] as Map<String, dynamic>?,
      emptyWidget: json['emptyWidget'] as Map<String, dynamic>?,
      padding: json['padding'] == null
          ? null
          : StacEdgeInsets.fromJson(json['padding']),
      shrinkWrap: json['shrinkWrap'] as bool? ?? false,
      reverse: json['reverse'] as bool? ?? false,
      separator: json['separator'] as Map<String, dynamic>?,
      scrollDirection: json['scrollDirection'] as String?,
      enablePagination: json['enablePagination'] as bool? ?? false,
      page: (json['page'] as num?)?.toInt() ?? 1,
      count: (json['count'] as num?)?.toInt() ?? 20,
      orderBy: json['orderBy'] as String?,
      order: json['order'] as String? ?? 'ASC',
      queryParams: json['queryParams'] as Map<String, dynamic>?,
      footerLoadingWidget: json['footerLoadingWidget'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StListViewBuilderToJson(StListViewBuilder instance) =>
    <String, dynamic>{
      'endpoint': instance.endpoint,
      'items': instance.items,
      'itemTemplate': instance.itemTemplate.toJson(),
      'loadingWidget': instance.loadingWidget,
      'errorWidget': instance.errorWidget,
      'emptyWidget': instance.emptyWidget,
      'padding': instance.padding?.toJson(),
      'shrinkWrap': instance.shrinkWrap,
      'reverse': instance.reverse,
      'separator': instance.separator,
      'scrollDirection': instance.scrollDirection,
      'enablePagination': instance.enablePagination,
      'page': instance.page,
      'count': instance.count,
      'orderBy': instance.orderBy,
      'order': instance.order,
      'queryParams': instance.queryParams,
      'footerLoadingWidget': instance.footerLoadingWidget,
      'type': instance.type,
    };
