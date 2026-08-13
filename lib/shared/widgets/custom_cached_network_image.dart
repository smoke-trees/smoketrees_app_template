import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final LoadingErrorWidgetBuilder? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CustomCachedNetworkImage({
    required this.imageUrl,
    this.errorWidget,
    this.height,
    this.width,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget:
          errorWidget ??
          (context, url, error) => Image.network(
            url,
            errorBuilder: (context, error, stackTrace) => SizedBox(
              height: height,
              width: width,
              child: Icon(
                Icons.error,
                color: AppColors.error.withValues(alpha: 0.8),
              ),
            ),
          ),
      height: height,
      width: width,
      cacheManager: AppImageCacheManager(),
      fit: fit,
    );
  }
}

class AppImageCacheManager extends CacheManager {
  static const key = 'fomofyImageCache';

  AppImageCacheManager()
    : super(
        Config(
          key,
          stalePeriod: const Duration(hours: 6),
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
}
