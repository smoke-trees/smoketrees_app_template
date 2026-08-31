import 'package:flutter/material.dart';

class CustomInfiniteCarousel<T> extends StatefulWidget {
  const CustomInfiniteCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemExtent,
    this.multiplier = 3,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double itemExtent;
  final int multiplier;

  @override
  State<CustomInfiniteCarousel<T>> createState() =>
      _CustomInfiniteCarouselState<T>();
}

class _CustomInfiniteCarouselState<T> extends State<CustomInfiniteCarousel<T>> {
  late final ScrollController _controller;
  late final List<T> _workingList;

  double get _singleListWidth => widget.items.length * widget.itemExtent;

  @override
  void initState() {
    super.initState();

    if (widget.items.isEmpty) return;

    _controller = ScrollController();

    _workingList = List.generate(
      widget.items.length == 1 ? 20 : widget.items.length * widget.multiplier,
      (index) => widget.items[index % widget.items.length],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.jumpTo(_singleListWidth);
      }
    });

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.items.isEmpty) return;

    final position = _controller.position.pixels;
    final max = _controller.position.maxScrollExtent;

    // Remove listener temporarily to avoid infinite recursion
    _controller.removeListener(_onScroll);

    if (position <= widget.itemExtent) {
      _controller.jumpTo(position + _singleListWidth);
    } else if (position >= max - widget.itemExtent) {
      _controller.jumpTo(position - _singleListWidth);
    }

    // Re-add listener after position change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.addListener(_onScroll);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: _workingList.length,
      itemExtent: widget.itemExtent,
      itemBuilder: (context, index) {
        return widget.itemBuilder(
          context,
          _workingList[index],
          index % widget.items.length,
        );
      },
    );
  }
}
