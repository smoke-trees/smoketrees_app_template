import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
// import 'package:dio_firebase_performance/dio_firebase_performance.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../../../utils/urls.dart';
import 'interceptor_wrapper.dart';

class BackendDio {
  static final BackendDio _instance = BackendDio._internal();

  late Dio dio;

  BackendDio._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppUrls.backendUrl,
        connectTimeout: const Duration(hours: 1),
        receiveTimeout: const Duration(hours: 1),
      ),
    );
    _initializeInterceptors();
  }

  factory BackendDio() {
    return _instance;
  }

  // Configure cache options
  final cacheOptions = CacheOptions(
    // store: HiveCacheStore('./cache'), // Persistent caching using Hive
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorCodes: [401, 403],
    priority: CachePriority.normal,
    maxStale: const Duration(days: 7),
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  );

  void _initializeInterceptors() {
    dio.interceptors.addAll([
      // DioCacheInterceptor(options: cacheOptions),
      getInterceptor(dio),
      // if (kDebugMode)
      //   PrettyDioLogger(
      //     requestBody: true,
      //     requestHeader: true,
      //     responseHeader: false,
      //     responseBody: true,
      //   ),
      LogInterceptor(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    ]);
    if (!kDebugMode) {
      // dio.interceptors.add(DioFirebasePerformanceInterceptor());
    }
  }
}

BackendDio backendDio = BackendDio();