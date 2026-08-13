import 'package:dio/dio.dart';
import 'package:get/get.dart' as get1;
import 'package:get/get.dart';

import '../../../utils/console_logger.dart';
import '../../services/global_service.dart';

QueuedInterceptorsWrapper getInterceptor(Dio dio) {
  return QueuedInterceptorsWrapper(
    onRequest:
        (
          RequestOptions options,
          RequestInterceptorHandler requestInterceptorHandler,
        ) async {
          // Do something before request is sent
          // UserController userController = UserController.to;
          //print("User Token ${userController.user?.accessToken}");
          // if (userController.user?.accessToken != null) {
          //   options.headers["Authorization"] =
          //       "Bearer ${userController.user?.accessToken}";

          //   get1.log('User token present');
          // } else {
          //   get1.log('No token present');
          //   get1.log(
          //       'options.path${options.path} options.method ${options.method}');
          //   if (options.path == '/users/access' && options.method == 'POST') {
          //     /// Creating user, so no tokenId yet
          //     print('Creating user, so no tokenId yet');

          //     // String? newToken =
          //     // await LoginController.to.fetchTokenWithRefreshToken();
          //     // if(newToken!=null){
          //     //   options.headers['Authorization'] =
          //     //   "Bearer $newToken";
          //     // }
          //     // options.headers['Authorization'] =
          //     //     "Bearer ${await FirebaseAuthController.to.getTokenId()!}";
          //   }
          // }
          return requestInterceptorHandler.next(options);
        },
    onError: (DioException error, ErrorInterceptorHandler errorInterceptorHandler) async {
      final response = error.response;
      final options = error.requestOptions;
      final statusCode = response?.statusCode;

      final errorService = GlobalService.to;

      ConsoleLogger.error("🚨 Dio Error caught:");
      ConsoleLogger.error("➡️ Path: ${options.path}");
      ConsoleLogger.error("➡️ Status Code: $statusCode");

      if (statusCode == 502 ||
          statusCode == 503 ||
          statusCode == 504 ||
          statusCode == null) {
        ConsoleLogger.info("Get.currentRoute");
        ConsoleLogger.info(Get.currentRoute);
        if (!errorService.hasShownErrorPage.value &&
            !errorService.isNavigatingToError) {
          errorService.isNavigatingToError = true;
          await Future.delayed(const Duration(milliseconds: 50));
          errorService.hasShownErrorPage.value = true;
          // await Get.offAll(
          //   () => CustomErrorPage(
          //     error: "Something went wrong, Please try again later.",
          //     // showRetryButton: false,
          //   ),
          // );
        }

        return errorInterceptorHandler.reject(error);
      }
      print('[DioInterceptorsWrapper] Error ${error.message}');
      if (error.response == null) {
        return errorInterceptorHandler.next(error);
      }

      if (options.method == 'POST' &&
          (options.path == '/users/verify-update-phone' ||
              options.path == '/users/verify-update-email' ||
              options.path == '/users/validate-otp' ||
              options.path == '/users/access')) {
        return errorInterceptorHandler.next(error);
      }

      // String? newToken = await LoginController.to.fetchTokenWithRefreshToken();
      // log("[DioInterceptorsWrapper] fetchTokenWithRefreshToken $newToken");

      // error.response?.statusCode == 401
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 401) {
        ConsoleLogger.warn('[DioInterceptorsWrapper] Unauthorized');

        ConsoleLogger.warn(
          "[DioInterceptorsWrapper] ${error.requestOptions.path}",
        );

        // String? newToken = await UserController.to.fetchTokenWithRefreshToken();
        // get1.log("[DioInterceptorsWrapper] newToken $newToken");
        // if (newToken == null && Get.currentRoute != SignUpPage.routeName) {
        //   get1.log("[DioInterceptorsWrapper] Noauth Logout");
        //   errorInterceptorHandler.next(error);
        //   // await LoginController.to.invalidateToken();
        //   var logout = await UserController.to.logout(isInvalidateToken: false);
        //   if (logout) await Get.offAllNamed(SignUpPage.routeName);
        // } else {
        //   options.headers["Authorization"] = "Bearer $newToken";
        //   get1.log("[DioInterceptorsWrapper] new token fetched");
        //   // dio.interceptors.responseLock.unlock();
        //   errorInterceptorHandler.resolve(
        //     await dio.fetch(
        //       options,
        //     ),
        //   );
        // }
      } else {
        // firebaseCrashlyticsService.logError(
        //   error,
        //   error.stackTrace,
        //   reason: 'DioError',
        // );
        return errorInterceptorHandler.next(error);
      }
    },
  );
}
