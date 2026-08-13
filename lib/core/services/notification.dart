import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../utils/console_logger.dart';
import '../../utils/downloader.dart';
import '../../utils/redirect.dart';
import 'global_service.dart';

RedirectingMessage? redirectingMessageFromJson(String str) =>
    RedirectingMessage.fromJson(json.decode(str));

String redirectingMessageToJson(RedirectingMessage? data) =>
    json.encode(data!.toJson());

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );

  if (notificationResponse.payload != null) {
    print('handle msg background');
    NotificationService._handleMessage(
      redirectingMessageFromJson(notificationResponse.payload!)!,
      fromInit: true,
    );
  }

  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

class RedirectingMessage {
  String? type;
  Map<String, dynamic>? arguments;

  RedirectingMessage({this.type, this.arguments});

  factory RedirectingMessage.fromJson(Map<String, dynamic> json) =>
      RedirectingMessage(type: json["type"], arguments: json["arguments"]);

  Map<String, dynamic> toJson() => {"type": type, "arguments": arguments};
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static int localNotificationId = 0;

  static Future<void> initialize() async {
    await _initializeInAppNotifications();
    await _requestLocalNotificationPermissions();
    await _setupFCMMessage();

    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static Future<void> _initializeInAppNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          _onDidReceiveNotificationResponseHandler,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void _onDidReceiveNotificationResponseHandler(
    NotificationResponse notificationResponse,
  ) async {
    print(
      "_onDidReceiveNotificationResponseHandler ${notificationResponse.payload}",
    );
    if (notificationResponse.payload != null) {
      print('handle msg 1');
      _handleMessage(
        redirectingMessageFromJson(notificationResponse.payload!)!,
      );
    }
  }

  // NEW: Add this method to request local notification permissions
  static Future<void> _requestLocalNotificationPermissions() async {
    // Request Android local notification permissions
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation
          .requestNotificationsPermission();
      print(
        '[NotificationService] Android local notification permission granted: $granted',
      );
    }

    // Request iOS local notification permissions
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosImplementation != null) {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      print(
        '[NotificationService] iOS local notification permission granted: $granted',
      );
    }
  }

  static Future<void> handleNotificationLaunch() async {
    final details = await _localNotifications.getNotificationAppLaunchDetails();

    print(
      '[NotificationService] local launch ${details!.didNotificationLaunchApp}',
    );

    if (details.didNotificationLaunchApp ?? false) {
      final payload = details.notificationResponse?.payload;
      print(
        '[NotificationService] Launched from local notification payload1 $payload',
      );
      if (payload != null) {
        if (GlobalService.to.initializeDone.value) {
          print(
            '[NotificationService] Launched from local notification payload2 $payload',
          );
          _handleMessage(redirectingMessageFromJson(payload)!, fromInit: false);
        } else {
          GlobalService.to.pendingNotificationPayload =
              redirectingMessageFromJson(payload)!;
        }
      }
    }
  }

  static Future<bool> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('[NotificationService] User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('[NotificationService] User granted provisional permission');
      return true;
    } else {
      print(
        '[NotificationService] User declined or has not accepted permission',
      );
      return false;
    }
  }

  static Future<String?> getFCMToken() async {
    String? token = await _messaging.getToken();
    return token;
  }

  static Future<void> notificationPayloadCheck(RemoteMessage? message) async {
    print('handle msg 3');
    print('handle msg $message');
    if (message != null) {
      if (GlobalService.to.initializeDone.value) {
        _handleMessage(
          RedirectingMessage(
            type: message.data["type"],
            arguments: message.data,
          ),
          fromInit: true,
        );
      } else {
        GlobalService.to.pendingNotificationPayload = RedirectingMessage(
          type: message.data["type"],
          arguments: message.data,
        );
        print('pending notification set');
      }
    } else {
      print('handling local');
      await handleNotificationLaunch();
    }
  }

  // It is assumed that all messages contain a data field with the key 'type'
  static Future<void> _setupFCMMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    print('_setupFCMMessage ${initialMessage?.data}');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMesageOpenedApp');
      print('handle msg 4');
      print(message.data.toString());
      _handleMessage(
        RedirectingMessage(type: message.data["type"], arguments: message.data),
        fromInit: false,
      );
    });
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) => _remoteMessageToLocalNotification(message),
    );

    await notificationPayloadCheck(initialMessage);

    ever(GlobalService.to.initializeDone, (ready) {
      if (ready && GlobalService.to.pendingNotificationPayload != null) {
        print('pending notification');
        var pendingPayload = GlobalService.to.pendingNotificationPayload;
        _handleMessage(pendingPayload!, fromInit: true);
        GlobalService.to.pendingNotificationPayload = null;
      }
    });
  }

  // Helper method to handle messages (made static to be accessible from background)
  static Future<void> _handleMessage(
    RedirectingMessage message, {
    bool? fromInit,
  }) async {
    ConsoleLogger.info("[NotificationService] handleMessage ${message.type}");
    ConsoleLogger.info("[NotificationService] handleMessage ${message.arguments}");
    if (message.type != null) {
      print(
        "[NotificationService] handleMessage ${message.type} ${message.arguments}",
      );
      AppRedirect.redirectTo(
        message.type!,
        arguments: message.arguments,
        fromInit: fromInit ?? false,
      );
    }
    // NotificationController.to.updateRefreshList();
  }

  static _remoteMessageToLocalNotification(RemoteMessage? message) async {
    print(
      "[NotificationService] _remoteMessageToLocalNotification ${message?.data}",
    );

    await showLocalNotification(
      id: localNotificationId++,
      title: message?.notification?.title ?? "",
      body: message?.notification?.body ?? "",
      payload: redirectingMessageToJson(
        RedirectingMessage(
          type: message?.data["type"],
          arguments: message?.data,
        ),
      ),
      imageUrl:
          message?.notification?.android?.imageUrl ??
          message?.notification?.apple?.imageUrl,
    );
  }

  static Future<NotificationDetails> _notificationDetails({
    String? imageUrl,
  }) async {
    String? bigPicture;
    if (imageUrl != null) {
      bigPicture = await AppDownloader.downloadAndSaveFile(imageUrl, imageUrl);
    }
    // print(bigPicture);
    // print(AppDownloader.urlToFilename(imageUrl!));
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'com.otaApp.app',
          'General Notifications',
          groupKey: 'com.otaApp.app',
          channelDescription: 'General Notifications',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          ticker: 'ticker',
          // largeIcon: bigPicture != null
          //     ? DrawableResourceAndroidBitmap(
          //         AppDownloader.urlToFilename(imageUrl!))
          //     : null,
          styleInformation: bigPicture != null
              ? BigPictureStyleInformation(
                  FilePathAndroidBitmap(bigPicture),
                  hideExpandedLargeIcon: false,
                )
              : null,
        );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(threadIdentifier: "com.otaApp.app");

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    print("_notificationDetails ${details?.notificationResponse}");
    // if (details != null && details.didNotificationLaunchApp) {
    //   behaviorSubject.add(details.payload!);
    // }
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetails,
    );

    return platformChannelSpecifics;
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    String? imageUrl,
  }) async {
    final platformChannelSpecifics = await _notificationDetails(
      imageUrl: imageUrl,
    );
    await _localNotifications
        .show(id, title, body, platformChannelSpecifics, payload: payload)
        .onError((error, stackTrace) {
          print(error.toString());
          print(stackTrace.toString());
        });
    // NotificationController.to.updateRefreshList();
  }
}
