import 'package:flutter/widgets.dart';

typedef Position = (Offset offset, double height, double width);

class Clipper extends CustomClipper<Path> {
  final Offset offset;
  final double width;
  final double height;
  final double? radius;

  Clipper({
    super.reclip,
    required this.offset,
    required this.width,
    required this.height,
    this.radius,
  });

  @override
  Path getClip(Size size) {
    if (radius != null) {
      return Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(
              offset.dx,
              offset.dy,
              width,
              height,
            ),
            Radius.circular(radius!)))
        ..addRect(Offset.zero & size);
    }
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy,
          width,
          height,
        ),
      )
      ..addRect(Offset.zero & size);
  }

  @override
  bool shouldReclip(covariant Clipper oldClipper) {
    return oldClipper.offset != offset ||
        oldClipper.width != width ||
        oldClipper.height != height;
  }
}

Position getOffsetAndSize(BuildContext context) {
  final renderBox = context.findRenderObject() as RenderBox;
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
  final size = renderBox.size;

  return (offset, size.height, size.width);
}
