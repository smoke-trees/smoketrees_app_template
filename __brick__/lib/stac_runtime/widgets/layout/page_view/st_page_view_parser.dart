import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'st_page_view.dart';

class StPageViewParser extends StacParser<StPageView> {
  @override
  String get type => 'st_page_view';

  @override
  StPageView getModel(Map<String, dynamic> json) => StPageView.fromJson(json);

  @override
  Widget parse(BuildContext context, StPageView model) {
    return _NavigationPageViewWidget(model: model);
  }
}

class _NavigationPageViewWidget extends StatefulWidget {
  final StPageView model;
  const _NavigationPageViewWidget({required this.model});

  @override
  State<_NavigationPageViewWidget> createState() =>
      _NavigationPageViewWidgetState();
}

class _NavigationPageViewWidgetState extends State<_NavigationPageViewWidget> {
  PageController? _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = NavigationScope.of(context);
    _pageController ??= PageController(initialPage: scope?.index ?? 0);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = NavigationScope.of(context);

    if (scope != null && _pageController?.hasClients == true) {
      final target = scope.index;
      final current = _pageController!.page?.round();
      if (current != null && current != target) {
        _pageController!.jumpToPage(target);
      }
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.model.children.length,
      onPageChanged: (index) {
        if (scope != null && scope.controller.index != index) {
          scope.controller.index = index;
        }
      },
      pageSnapping: widget.model.pageSnapping ?? true,
      reverse: widget.model.reverse ?? false,
      itemBuilder: (context, index) =>
          widget.model.children[index].parse(context) ?? const SizedBox(),
    );
  }
}
