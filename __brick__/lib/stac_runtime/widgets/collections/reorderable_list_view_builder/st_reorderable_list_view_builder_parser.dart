import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../../core/controllers/st_data_refresh_controller.dart';
import '../../../../core/network/dio_controllers/backend_dio.dart';
import 'st_reorderable_list_view_builder.dart';

/// Replaces [ReorderableListView]'s default drag decorator, which wraps the
/// dragged item in an *opaque* [Material] sized to the item's full bounding
/// box â€” including any trailing separator/spacing widget appended inside
/// that same item (see [StReorderableListViewBuilderParser._buildItem]).
/// That opaque fill is what makes the separator's blank space look like
/// extra white card area while reordering. Using a transparent [Material]
/// keeps the elevation/shadow lift without painting over the gap.
Widget _dragProxyDecorator(
  Widget child,
  int index,
  Animation<double> animation,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      final double t = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(0, 6, t)!;
      return Material(
        elevation: elevation,
        color: Colors.transparent,
        shadowColor: Colors.black26,
        child: child,
      );
    },
    child: child,
  );
}

class StReorderableListViewBuilderParser
    extends StacParser<StReorderableListViewBuilder> {
  final Dio dio;

  StReorderableListViewBuilderParser({Dio? dio}) : dio = dio ?? backendDio.dio;

  @override
  String get type => 'reorderable_list_view_builder';

  @override
  StReorderableListViewBuilder getModel(Map<String, dynamic> json) =>
      StReorderableListViewBuilder.fromJson(json);

  @override
  Widget parse(BuildContext context, StReorderableListViewBuilder model) {
    // Inline data: build directly.
    if (model.endpoint == null || model.endpoint!.isEmpty) {
      return _buildList(context, model, model.items ?? const []);
    }

    return _PagedListView(dio: dio, model: model);
  }

  Widget _buildList(
    BuildContext context,
    StReorderableListViewBuilder model,
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

    final itemCount = items.length + (footer != null ? 1 : 0);

    Widget itemFor(int index) {
      if (index < items.length) {
        final hasNextSibling = index < itemCount - 1;
        return _buildItem(
          context,
          model,
          items,
          index,
          direction: scrollDirection,
          trailing: hasNextSibling
              ? _buildSeparator(context, model, scrollDirection)
              : null,
        );
      }
      return KeyedSubtree(
        key: const ValueKey('reorderable-list-footer'),
        child: footer!,
      );
    }

    return ReorderableListView.builder(
      scrollDirection: scrollDirection,
      reverse: model.reverse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding?.parse,
      onReorderItem: model.onReorder == null
          ? null
          : (oldIndex, newIndex) =>
                _handleReorder(context, model, items, oldIndex, newIndex),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemFor(index),
      proxyDecorator: _dragProxyDecorator,
    );
  }

  /// Invokes the model's [StReorderableListViewBuilder.onReorder] custom
  /// action, resolving `{{key}}` placeholders with the moved item's fields plus
  /// `{{oldIndex}}`, `{{newIndex}}` and `{{index}}` before calling the action.
  Future<void> _handleReorder(
    BuildContext context,
    StReorderableListViewBuilder model,
    List<Map<String, dynamic>> items,
    int oldIndex,
    int newIndex,
  ) async {
    final action = model.onReorder;
    if (action == null) return;
    final moved = oldIndex >= 0 && oldIndex < items.length
        ? items[oldIndex]
        : <String, dynamic>{};
    final placeholders = <String, dynamic>{
      ...moved,
      'index': oldIndex,
      'oldIndex': oldIndex,
      'newIndex': newIndex,
    };
    final resolvedJson = _injectData(action.toJson(), placeholders);
    await Stac.onCallFromJson(resolvedJson, context);
  }

  /// Builds a single item's [KeyedSubtree]. When [trailing] is provided
  /// (i.e. there's a following item or footer), it's rendered as a sibling
  /// after the item content, along the scroll [direction] â€” this is how
  /// spacing/separators are added without inflating `itemCount` and
  /// disturbing [ReorderableListView]'s drag/reorder indices.
  Widget _buildItem(
    BuildContext context,
    StReorderableListViewBuilder model,
    List<Map<String, dynamic>> items,
    int index, {
    Widget? trailing,
    Axis direction = Axis.vertical,
  }) {
    final item = items[index];
    final itemWithIndex = <String, dynamic>{...item, 'index': index};
    final resolvedJson = _injectData(
      model.itemTemplate.toJson(),
      itemWithIndex,
    );
    final child = Stac.fromJson(resolvedJson, context) ?? const SizedBox();

    final content = trailing == null
        ? child
        : direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: [child, trailing])
        : Column(mainAxisSize: MainAxisSize.min, children: [child, trailing]);

    // ReorderableListView requires a key on every direct child.
    return KeyedSubtree(
      key: ValueKey(item['id'] ?? 'item-$index'),
      child: content,
    );
  }

  /// Resolves [StReorderableListViewBuilder.separator] or
  /// [StReorderableListViewBuilder.spacing] into a gap widget for a single
  /// slot between items. Returns null when neither is configured. Built
  /// fresh per call (rather than cached) so a custom [separator] never ends
  /// up as the same Widget instance in multiple places in the tree.
  Widget? _buildSeparator(
    BuildContext context,
    StReorderableListViewBuilder model,
    Axis direction,
  ) {
    final separator = model.separator;
    if (separator != null) {
      return Stac.fromJson(separator.toJson(), context) ?? const SizedBox();
    }
    final spacing = model.spacing;
    if (spacing != null && spacing > 0) {
      return direction == Axis.horizontal
          ? SizedBox(width: spacing)
          : SizedBox(height: spacing);
    }
    return null;
  }

  /// Deep-copies a JSON tree replacing `{{key}}` placeholders with values
  /// from [data]. Scalar values are coerced to [String] so they can be safely
  /// injected into string fields (e.g. `StacText.data`).
  dynamic _injectData(dynamic node, Map<String, dynamic> data) {
    if (node is String) {
      final match = RegExp(r'^\{\{(\w+)\}\}$').firstMatch(node);
      if (match != null) {
        final value = data[match.group(1)];
        return value == null ? node : value.toString();
      }
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

/// Stateful page loader used when [StReorderableListViewBuilder.endpoint] is set.
///
/// Fetches pages using the project's `EntityDio.readMany` query contract
/// (`page`, `count`, `orderBy`, `order`) and auto-loads the next page as the
/// user scrolls to the bottom when [StReorderableListViewBuilder.enablePagination] is
/// true. The response is expected to be
/// `{"status": {...}, "message": "...", "result": [...], "count": N}` (a bare
/// array is also accepted).
class _PagedListView extends StatefulWidget {
  const _PagedListView({required this.dio, required this.model});

  final Dio dio;
  final StReorderableListViewBuilder model;

  @override
  State<_PagedListView> createState() => _PagedListViewState();
}

class _PagedListViewState extends State<_PagedListView> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];
  StreamSubscription<StDataChange>? _dataSubscription;

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
    _dataSubscription = StDataRefreshController.to.changes.listen(
      _onStDataChange,
    );
    _fetchPage();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Applies a local item-level change, keeping the UI in sync without a
  /// full re-fetch (no pagination jump / scroll hiccup).
  void _onStDataChange(StDataChange change) {
    if (!mounted) return;
    setState(() {
      switch (change) {
        case StDataItemUpdated(:final key, :final fields):
          _applyItemPatch(key, fields);
        case StDataItemDeleted(:final key):
          _items.removeWhere((e) => _itemKeyOf(e) == key);
        case StDataListReset():
          _refresh();
      }
    });
  }

  /// Merges [fields] into the cached item whose id matches [key].
  void _applyItemPatch(dynamic key, Map<String, dynamic> fields) {
    final index = _items.indexWhere((e) => _itemKeyOf(e) == key);
    if (index == -1)
      return; // item not in current page/filter â€” nothing to do
    _items[index] = {..._items[index], ...fields};
  }

  /// Extracts the stable identity field used to match items. Mirrors the
  /// `id` key used when assigning each child's `ValueKey`.
  static dynamic _itemKeyOf(Map<String, dynamic> item) => item['id'];

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
      final pageItems = _parsePage(raw);
      final totalCount = _parseTotalCount(raw);

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

  /// Refetches the first page and replaces the list, so the server's
  /// authoritative ordering is reflected after a reorder.
  Future<void> _refresh() async {
    final model = widget.model;
    final queryParameters = <String, dynamic>{
      'page': model.page,
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
      final pageItems = _parsePage(response.data);
      final totalCount = _parseTotalCount(response.data);

      if (!mounted) return;
      setState(() {
        _nextPage = model.page + 1;
        _items
          ..clear()
          ..addAll(pageItems);
        _isInitialLoading = false;
        _isLoadingMore = false;
        _error = null;
        _hasMore = totalCount != null
            ? _items.length < totalCount
            : pageItems.length >= model.count;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error ??= e);
    }
  }

  List<Map<String, dynamic>> _parsePage(dynamic raw) {
    final rawResult = raw is Map ? raw['result'] : raw;
    if (rawResult is List) {
      return rawResult
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (rawResult is Map && rawResult['data'] is List) {
      return (rawResult['data'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  int? _parseTotalCount(dynamic raw) =>
      raw is Map ? (raw['count'] as num?)?.toInt() : null;

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final parser = StReorderableListViewBuilderParser(dio: widget.dio);

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
    StReorderableListViewBuilder model,
    StReorderableListViewBuilderParser parser,
    Widget? footer,
  ) {
    final scrollDirection = model.scrollDirection == 'horizontal'
        ? Axis.horizontal
        : Axis.vertical;

    final itemCount = _items.length + (footer != null ? 1 : 0);

    Widget itemFor(int index) {
      if (index < _items.length) {
        final hasNextSibling = index < itemCount - 1;
        return parser._buildItem(
          context,
          model,
          _items,
          index,
          direction: scrollDirection,
          trailing: hasNextSibling
              ? parser._buildSeparator(context, model, scrollDirection)
              : null,
        );
      }
      return KeyedSubtree(
        key: const ValueKey('reorderable-list-footer'),
        child: footer!,
      );
    }

    return ReorderableListView.builder(
      scrollController: _scrollController,
      scrollDirection: scrollDirection,
      reverse: model.reverse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding?.parse,
      onReorderItem: model.onReorder == null
          ? null
          : (oldIndex, newIndex) async {
              await parser._handleReorder(
                context,
                model,
                _items,
                oldIndex,
                newIndex,
              );
              if (mounted) _refresh();
            },
      itemCount: itemCount,
      itemBuilder: (context, index) => itemFor(index),
      proxyDecorator: _dragProxyDecorator,
    );
  }
}
