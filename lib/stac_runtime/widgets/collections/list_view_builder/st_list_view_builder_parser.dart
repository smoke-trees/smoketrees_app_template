import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../../core/network/dio_controllers/backend_dio.dart';
import 'st_list_view_builder.dart';

class StListViewBuilderParser extends StacParser<StListViewBuilder> {
  final Dio dio;

  StListViewBuilderParser({Dio? dio}) : dio = dio ?? backendDio.dio;

  @override
  String get type => 'list_view_builder';

  @override
  StListViewBuilder getModel(Map<String, dynamic> json) =>
      StListViewBuilder.fromJson(json);

  @override
  Widget parse(BuildContext context, StListViewBuilder model) {
    // Inline data: build directly.
    if (model.endpoint == null || model.endpoint!.isEmpty) {
      return _buildList(context, model, model.items ?? const []);
    }

    return _PagedListView(dio: dio, model: model);
  }

  Widget _buildList(
    BuildContext context,
    StListViewBuilder model,
    List<Map<String, dynamic>> items, {
    Widget? footer,
  }) {
    if (items.isEmpty && footer == null) {
      return model.emptyWidget != null
          ? Stac.fromJson(model.emptyWidget, context) ?? const SizedBox()
          : const SizedBox();
    }

    final scrollDirection = model.scrollDirection == 'horizontal'
        ? Axis.horizontal
        : Axis.vertical;

    final separator = model.separator != null
        ? Stac.fromJson(model.separator, context) ?? const SizedBox()
        : null;

    final itemCount = items.length + (footer != null ? 1 : 0);

    Widget itemFor(int index) => index < items.length
        ? _buildItem(context, model, items, index)
        : footer!;

    if (separator != null) {
      return ListView.separated(
        scrollDirection: scrollDirection,
        reverse: model.reverse,
        shrinkWrap: model.shrinkWrap,
        padding: model.padding?.parse,
        itemCount: itemCount,
        separatorBuilder: (context, _) => separator,
        itemBuilder: (context, index) => itemFor(index),
      );
    }

    return ListView.builder(
      scrollDirection: scrollDirection,
      reverse: model.reverse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding?.parse,
      itemCount: itemCount,
      itemBuilder: (context, index) => itemFor(index),
    );
  }

  Widget _buildItem(
    BuildContext context,
    StListViewBuilder model,
    List<Map<String, dynamic>> items,
    int index,
  ) {
    final item = items[index];
    final itemWithIndex = <String, dynamic>{...item, 'index': index};
    final resolvedJson = _injectData(
      model.itemTemplate.toJson(),
      itemWithIndex,
    );
    return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
  }

  /// Deep-copies a JSON tree replacing `{{key}}` placeholders with values
  /// from [data].
  dynamic _injectData(dynamic node, Map<String, dynamic> data) {
    if (node is String) {
      final match = RegExp(r'^\{\{(\w+)\}\}$').firstMatch(node);
      if (match != null) return data[match.group(1)] ?? node;
      return node.replaceAllMapped(
        RegExp(r'\{\{(\w+)\}\}'),
        (m) => data[m.group(1)]?.toString() ?? m.group(0)!,
      );
    }
    if (node is Map<String, dynamic>) {
      return node.map((k, v) => MapEntry(k, _injectData(v, data)));
    }
    if (node is List) {
      return node.map((e) => _injectData(e, data)).toList();
    }
    return node;
  }
}

/// Stateful page loader used when [StListViewBuilder.endpoint] is set.
///
/// Fetches pages using the project's `EntityDio.readMany` query contract
/// (`page`, `count`, `orderBy`, `order`) and auto-loads the next page as the
/// user scrolls to the bottom when [StListViewBuilder.enablePagination] is
/// true. The response is expected to be
/// `{"status": {...}, "message": "...", "result": [...], "count": N}` (a bare
/// array is also accepted).
class _PagedListView extends StatefulWidget {
  const _PagedListView({required this.dio, required this.model});

  final Dio dio;
  final StListViewBuilder model;

  @override
  State<_PagedListView> createState() => _PagedListViewState();
}

class _PagedListViewState extends State<_PagedListView> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];

  late int _nextPage;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _nextPage = widget.model.page;
    _scrollController.addListener(_onScroll);
    _fetchPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!widget.model.enablePagination) return;
    if (_isInitialLoading || _isLoadingMore || !_hasMore) return;
    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    final model = widget.model;
    final pageToFetch = _nextPage;

    setState(() {
      if (_items.isEmpty && _error == null) {
        _isInitialLoading = true;
      } else {
        _isLoadingMore = true;
      }
    });

    final queryParameters = <String, dynamic>{
      'page': pageToFetch,
      'count': model.count,
      if (model.orderBy != null) 'orderBy': model.orderBy,
      'order': model.order,
      ...?model.queryParams,
    };

    try {
      final response = await widget.dio.get(
        model.endpoint!,
        queryParameters: queryParameters,
      );
      final raw = response.data;
      final rawResult = raw is Map ? raw['result'] : raw;

      final List<Map<String, dynamic>> pageItems;
      if (rawResult is List) {
        pageItems = rawResult
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else if (rawResult is Map && rawResult['data'] is List) {
        pageItems = (rawResult['data'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        pageItems = const [];
      }

      final totalCount = raw is Map ? (raw['count'] as num?)?.toInt() : null;

      if (!mounted) return;
      setState(() {
        _nextPage = pageToFetch + 1;
        _items.addAll(pageItems);
        _isInitialLoading = false;
        _isLoadingMore = false;
        _hasMore = totalCount != null
            ? _items.length < totalCount
            : pageItems.length >= model.count;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitialLoading = false;
        _isLoadingMore = false;
        _error ??= e;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final parser = StListViewBuilderParser(dio: widget.dio);

    if (_isInitialLoading) {
      return model.loadingWidget != null
          ? Stac.fromJson(model.loadingWidget, context) ?? const SizedBox()
          : const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return model.errorWidget != null
          ? Stac.fromJson(model.errorWidget, context) ?? const SizedBox()
          : const Center(child: Text('Failed to load'));
    }

    if (_items.isEmpty) {
      return model.emptyWidget != null
          ? Stac.fromJson(model.emptyWidget, context) ?? const SizedBox()
          : const SizedBox();
    }

    final footer = _isLoadingMore
        ? (model.footerLoadingWidget != null
              ? Stac.fromJson(model.footerLoadingWidget, context) ??
                    const SizedBox()
              : const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                ))
        : null;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 200) _loadMore();
        return false;
      },
      child: _buildScrollable(model, parser, footer),
    );
  }

  Widget _buildScrollable(
    StListViewBuilder model,
    StListViewBuilderParser parser,
    Widget? footer,
  ) {
    final scrollDirection = model.scrollDirection == 'horizontal'
        ? Axis.horizontal
        : Axis.vertical;

    final separator = model.separator != null
        ? Stac.fromJson(model.separator, context) ?? const SizedBox()
        : null;

    final itemCount = _items.length + (footer != null ? 1 : 0);

    Widget itemFor(int index) => index < _items.length
        ? parser._buildItem(context, model, _items, index)
        : footer!;

    if (separator != null) {
      return ListView.separated(
        controller: _scrollController,
        scrollDirection: scrollDirection,
        reverse: model.reverse,
        shrinkWrap: model.shrinkWrap,
        padding: model.padding?.parse,
        itemCount: itemCount,
        separatorBuilder: (context, _) => separator,
        itemBuilder: (context, index) => itemFor(index),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: scrollDirection,
      reverse: model.reverse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding?.parse,
      itemCount: itemCount,
      itemBuilder: (context, index) => itemFor(index),
    );
  }
}
