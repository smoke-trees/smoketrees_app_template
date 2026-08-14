import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextFutureBuilder<T> extends StatelessWidget {
  const TextFutureBuilder({
    Key? key,
    required this.future,
    this.builder,
    this.showLoading = true,
  }) : super(key: key);

  final Future<T> future;
  final Function(BuildContext context, T data)? builder;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 60, height: 12, color: Colors.grey),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        return builder!(context, snapshot.data as T);
      },
    );
  }
}
