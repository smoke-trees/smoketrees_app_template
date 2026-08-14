import 'package:dio/dio.dart';
import 'package:smoketrees_app_template/utils/console_logger.dart';

import '../response.dart';
import 'backend_dio.dart';

/// 💥 Centralized Dio error handler
ApiResponse<T> handleDioError<T>(DioException e) {
  int? statusCode = e.response?.statusCode;
  String errorMessage = "Something went wrong";
  try {
    ConsoleLogger.error("handleDioError ⚠️ ${e.error}");
    errorMessage = e.response?.data?["message"] != null
        ? e.response!.data!["message"]
        : "Something went wrong";
  } catch (e) {
    ConsoleLogger.error("handleDioError ⚠️ ${e.toString()}");
  }
  // if (statusCode == null) {
  //   Get.offAll(CustomErrorPage(error: 'hello error here'));
  // }
  switch (statusCode) {
    case 400:
      ConsoleLogger.error("⚠️ Bad Request (400): $errorMessage");
      return ApiResponse<T>.dioError(message: "Invalid request: $errorMessage");
    case 401:
      ConsoleLogger.error("🔒 Unauthorized (401): $errorMessage");
      return ApiResponse<T>.dioError(
        message: errorMessage ?? "Please login to continue.",
      );
    case 403:
      ConsoleLogger.error("🚫 Forbidden (403): $errorMessage");
      return ApiResponse<T>.dioError(
        message: "Access denied. This resource is restricted.",
      );
    case 404:
      ConsoleLogger.error("🔍 Not Found (404): $errorMessage");
      return ApiResponse<T>.dioError(
        message: "Resource not found: $errorMessage",
      );
    case 500:
      ConsoleLogger.error("🔥 Server Error (500): $errorMessage");
      return ApiResponse<T>.dioError(
        message: errorMessage ?? "Oops! Server error. Try again later.",
      );
    default:
      ConsoleLogger.error(
        "❌ Dio Error [${statusCode ?? 'No Code'}]: $errorMessage",
      );
      // FirebaseCrashlyticsService.logError(e, e.stackTrace,
      //     reason: "$errorMessage "
      //         "\nStatus Code: ${e.response?.statusCode} "
      //         "\nPath: ${e.requestOptions.path} "
      //         "\nBaseUrl: ${e.requestOptions.baseUrl} "
      //         "\nfullUrl: ${e.requestOptions.uri} "
      //         "\nMethod: ${e.requestOptions.method} "
      //         "\nHeaders: ${e.requestOptions.headers} "
      //         "\nQueryParams: ${e.requestOptions.queryParameters} "
      //         "\nData: ${e.requestOptions.data} "
      // "\nUserId: ${UserController.to.user?.id ?? ""} "
      // "\nUserName: ${UserController.to.user?.name ?? ""} "
      // "\nUserEmail: ${UserController.to.user?.email ?? ""} ",
      // );
      return ApiResponse<T>.dioError(message: "❗ $errorMessage");
  }
}

class EntityDio extends BackendDio {
  final String path;

  EntityDio({required this.path});

  Future<ApiResponse<T>> getQuery<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final Response response = await super.dio.get(
        "/${this.path}/$path",
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> postQuery<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      ConsoleLogger.info("📤 [POST] $path → Sending request...");
      final Response response = await super.dio.post(
        "/${this.path}/$path",
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      ConsoleLogger.success("✅ [POST] $path → Response received.");
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError<T>(e);
    } catch (e) {
      ConsoleLogger.error("⚠️ Unexpected error in postQuery: $e");
      return ApiResponse<T>.dioError(message: e.toString());
    }
  }

  Future<ApiResponse<T>> postFile<T>(
    String path, {
    Object? data,
    Options? options,
    Map<String, dynamic>? params,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      ConsoleLogger.info("📁 [POST FILE] $path → Uploading...");
      final Response response = await super.dio.post(
        "/${this.path}/$path",
        data: data,
        options: options,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      ConsoleLogger.success("✅ [POST FILE] $path → Upload complete.");
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError<T>(e);
    }
  }

  Future<ApiResponse<T>> deleteQuery<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await super.dio.delete(
        "/${this.path}/$path",
        queryParameters: queryParameters,
      );
      return ApiResponse<T>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError<T>(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> read(
    dynamic id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await super.dio.get(
        "/$path/$id",
        queryParameters: queryParameters,
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    } catch (e) {
      return ApiResponse.dioError(message: e.toString());
    }
  }

  Future<ApiResponse<dynamic>> create(
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await super.dio.post(
        "/$path",
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse<dynamic>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<dynamic>> createWithFile({
    String path = "",
    Map<String, dynamic>? queryParameters,
    required Object data,
  }) async {
    try {
      final Response response = await super.dio.post(
        "/${this.path}/$path",
        queryParameters: queryParameters,
        data: data,
      );
      return ApiResponse<dynamic>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<dynamic>> fileDownloadWithPost({
    String path = "",
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await super.dio.post(
        "/${this.path}/$path",
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResponse(
        status: Status(error: false),
        result: response.data,
        message: "Success",
      );
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<dynamic>> delete(
    dynamic id, {
    required Map<String, String?> data,
  }) async {
    try {
      final Response response = await super.dio.delete("/$path/$id");
      return ApiResponse<dynamic>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<dynamic>> put(
    dynamic id,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await super.dio.put(
        "/$path/$id",
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse<dynamic>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<List<dynamic>>> readMany({
    int? page,
    int? count,
    String? orderBy,
    String? order = "ASC",
    Map<String, dynamic>? params,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    Map<String, dynamic> queryParams = {
      if (page != null) "page": page,
      if (count != null) "count": count,
      if (orderBy != null) "orderBy": orderBy,
      "order": order,
    };

    queryParams.removeWhere((key, value) => value == null);
    params?.removeWhere((key, value) => value == null);
    queryParams.addEntries(params?.entries ?? {});

    try {
      Response response = await super.dio.get(
        "/$path",
        queryParameters: queryParams,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return ApiResponse<List<dynamic>>.fromJson(response.data);
    } on DioException catch (e) {
      return handleDioError(e);
    }
  }
}
