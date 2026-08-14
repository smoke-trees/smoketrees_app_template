import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/shared/animations/make_scale_animation.dart';
import 'package:smoketrees_app_template/shared/pages/zoomable_image.dart';

import '../../utils/assets.dart';

showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    // barrierColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),

    builder: (context) {
      return ImageDialog(imageUrl: imageUrl);
    },
  );
}

class ImageDialog extends StatefulWidget {
  const ImageDialog({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    bool isAsset = !widget.imageUrl.isURL;

    return MakeScaleAnimation(
      duration: const Duration(milliseconds: 300),
      child: Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        insetPadding: const EdgeInsets.all(0),
        shadowColor: Colors.transparent,
        child: Container(
          // color: Colors.red,
          // constraints: BoxConstraints(
          //   maxHeight: Get.height * 0.5,
          // ),
          color: Colors.transparent,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  style: IconButton.styleFrom(iconSize: 35),
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Visibility(
                visible: !isAsset,
                replacement: Expanded(
                  child: ZoomableImage(
                    key: Key('easy_image_view_${widget.imageUrl}'),
                    imageProvider: AssetImage(
                      widget.imageUrl.isEmpty
                          ? AppAssets.noImage
                          : widget.imageUrl,
                    ),
                    doubleTapZoomable: true,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Expanded(
                  child: ZoomableImage(
                    key: Key('easy_image_view_${widget.imageUrl}'),
                    imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                    fit: BoxFit.fitWidth,
                    doubleTapZoomable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
