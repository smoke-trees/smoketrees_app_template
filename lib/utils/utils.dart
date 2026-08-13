import 'dart:convert';
import 'dart:io' hide ContentType;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/models/user.dart';
import '../shared/animations/fade_in_animation.dart';
import '../shared/pages/inapp_webview.dart';
import 'console_logger.dart';

class AppUtils {
  String formatDateTime(
    DateTime? dateTime, {
    bool showNumbersOnly = false,
    String? showNumberWith,
    bool showDateTime = false,
    bool showDateMonth = false,
    bool showTimeOnly = false,
    bool monthTrim = false,
    bool yearTrim = false,
    bool monthYearTrim = false,
    String? format,
    String? timeZone,
  }) {
    if (dateTime == null) {
      return "";
    }

    String day = dateTime.day.toString();
    String suffix = getOrdinalSuffix(dateTime.day);
    String month = DateFormat('MMMM').format(dateTime);

    String monthNum = DateFormat('M').format(dateTime);
    String year = DateFormat('y').format(dateTime);
    if (format != null) {
      var outputFormat = DateFormat(format);
      var outputDate = outputFormat.format(dateTime);
      return outputDate;
    } else if (showTimeOnly) {
      var outputFormat = DateFormat('hh:mm a');
      var outputDate = outputFormat.format(dateTime);
      return outputDate;
    } else if (showNumberWith != null) {
      return '$day$showNumberWith$monthNum$showNumberWith$year';
    } else if (showNumbersOnly) {
      return '$day/$monthNum/$year';
    } else if (showDateTime) {
      var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
      var outputDate = outputFormat.format(dateTime);
      return outputDate;
    } else if (showDateMonth) {
      return '$day ${month.substring(0, 3)}';
    } else if (monthTrim) {
      return '$day$suffix ${month.substring(0, 3)}, $year';
    } else if (yearTrim) {
      return '$day$suffix $month, ${year.substring(2)}';
    } else if (monthYearTrim) {
      return '$day$suffix ${month.substring(0, 3)}, ${year.substring(2)}';
    } else {
      return '$day$suffix $month, $year';
    }
  }

  Future<User?> extractUserDataFromJWT(String jwtToken) async {
    try {
      final parts = jwtToken.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payload = parts[1];
      // Add padding characters if needed
      final int padLength = (4 - payload.length % 4) % 4;
      final paddedPayload = payload + '=' * padLength;
      final decoded = base64Url.decode(paddedPayload);
      final jsonString = utf8.decode(decoded);
      final userData = json.decode(jsonString);
      return User.fromJson(userData);
    } catch (e) {
ConsoleLogger.error('Error decoding JWT token: $e');
      e.toString();
      return null;
    }
  }

  static bool isAndroidGestureNavigationEnabled(BuildContext context) {
    final value = MediaQuery.of(context).systemGestureInsets.bottom;
    return value < 48.0 && value != 0.0;
  }

  static String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String hoursText = hours > 0 ? "$hours hr${hours > 1 ? 's' : ''}" : "";
    String minutesText = minutes > 0
        ? "$minutes min${minutes > 1 ? 's' : ''}"
        : "";
    String secondsText = seconds > 0
        ? "$seconds sec${seconds > 1 ? 's' : ''}"
        : "";

    if (totalSeconds == 0) {
      return "0 sec";
    } else if (totalSeconds == 1) {
      return "1 sec";
    }

    List<String> parts = [
      hoursText,
      minutesText,
      secondsText,
    ].where((e) => e.isNotEmpty).toList();
    return parts.join(" ");
  }

  Color getColorFromHex(String hexCode) {
    final cleanedHex = hexCode.replaceFirst('#', '');
    final colorInt = int.parse(cleanedHex, radix: 16);
    return Color(0xFF000000 | colorInt); // Ensures full opacity
  }

  String? sentenceCasing(String? sentence) {
    if (sentence == null) return null;

    return sentence.toLowerCase().replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }

  // Future<User?> extractUserDataFromJWT(String jwtToken) async {
  //   try {
  //     final parts = jwtToken.split('.');
  //     if (parts.length != 3) {
  //       return null;
  //     }
  //     final payload = parts[1];
  //     // Add padding characters if needed
  //     final int padLength = (4 - payload.length % 4) % 4;
  //     final paddedPayload = payload + '=' * padLength;
  //     final decoded = base64Url.decode(paddedPayload);
  //     final jsonString = utf8.decode(decoded);
  //     final userData = json.decode(jsonString);
  //     return User.fromJson(userData);
  //   } catch (e) {
  //     log('Error decoding JWT token: $e');
  //     e.toString();
  //     return null;
  //   }
  // }

  Future<void> updateApp() async {
    if (Platform.isAndroid) {
      _openPlayStore();
    } else {
      _openAppStore();
    }
  }

  Future<void> _openPlayStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;

    String url = "https://play.google.com/store/apps/details?id=$packageName";
    try {
      print("Opening playstore");
      print(url);
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (e) {
      print("Error in opening playstore");
    }
  }

  Future<void> _openAppStore() async {
    String? url = "https://apps.apple.com/in/app/fomofy/id6746635045";
    try {
      ConsoleLogger.info("Opening Appstore");
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (e) {
      print("Error in opening Appstore");
    }
  }

  static Future<String?> pickImage({bool isCamera = false}) async {
    var res = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
    );

    if (res != null) {
      return res.path;
    }
    return null;
  }

  static launchURL(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      await launchUrl(Uri.parse(url), mode: mode);
    } catch (e) {
      print(e.toString());
      throw 'Could not launch $url';
    }
  }

  static String pdfUrl =
      "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  static inAppWebView(String url) async {
    return Get.toNamed(InAppWebView.routeName, arguments: [url]);
  }

  static share(String text) async {
    final params = ShareParams(uri: Uri.parse(text));
    try {
      SharePlus.instance.share(params);
    } catch (e) {
      print(e.toString());
      throw 'Could not share $text';
    }
  }

  static shareWithParams(ShareParams shareParams) async {
    try {
      SharePlus.instance.share(shareParams);
    } catch (e) {
      print(e.toString());
      throw 'Could not share';
    }
  }

  static getCurrencySymbol(String text) {
    switch (text) {
      case "INR":
        return "â‚¹";
      case "USD":
        return "\$";
      case "EUR":
        return "â‚¬";
    }
  }

  // Future<String> getApiKey() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String apiKey =
  //       packageInfo.applicationInfo.metaData['com.google.android.geo.API_KEY'];
  //   return apiKey;
  // }

  static String generateLoremIpsum({int numParagraphs = 1}) {
    String loremIpsum = "";
    for (int i = 0; i < numParagraphs; i++) {
      if (i != 0) {
        loremIpsum += "\n\n";
      }
      loremIpsum +=
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc sapien ultricies nunc, vitae aliquam nisi nisl vitae nunc. Donec euismod, nisl eget aliquam ultricies, nunc sapien ultricies nunc.";
    }
    return loremIpsum;
  }
}

extension StringFormatting on String {
  String get toTitleCase {
    return split('_')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  String get toUpperCase {
    return split(' ')
        .map((word) {
          return word.toLowerCase();
        })
        .join('_');
  }

  bool get checkPhoneNumber {
    if (length != 10) return false;
    return hasMatch(this, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }
}

extension IntExtension on int {
  SizedBox get h {
    return SizedBox(height: toDouble());
  }

  SizedBox get w {
    return SizedBox(width: toDouble());
  }

  BorderRadius get rc {
    return BorderRadius.circular(toDouble());
  }

  EdgeInsets get ltrp {
    return EdgeInsets.only(
      left: toDouble(),
      right: toDouble(),
      top: toDouble(),
    );
  }

  EdgeInsets get lrbp {
    return EdgeInsets.only(
      left: toDouble(),
      right: toDouble(),
      bottom: toDouble(),
    );
  }

  EdgeInsets get p {
    return EdgeInsets.all(toDouble());
  }

  EdgeInsets get lp {
    return EdgeInsets.only(left: toDouble());
  }

  EdgeInsets get rp {
    return EdgeInsets.only(right: toDouble());
  }

  EdgeInsets get bp {
    return EdgeInsets.only(bottom: toDouble());
  }

  EdgeInsets get tp {
    return EdgeInsets.only(top: toDouble());
  }

  EdgeInsets get hp {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }

  EdgeInsets get vp {
    return EdgeInsets.symmetric(vertical: toDouble());
  }
}

extension FadeInAnimationss on Widget {
  FadeInAnimation fadeInAnimation({double delay = 0.2}) {
    return FadeInAnimation(delay: delay, child: this);
  }
}

extension FadeInAnimationsOnList on List<Widget> {
  List<FadeInAnimation> fadeInAnimation({
    double delay = 0.2,
    double interval = 0.1,
    bool reverse = false,
  }) {
    return map((e) {
      delay += interval;
      return FadeInAnimation(reverse: reverse, delay: delay, child: e);
    }).toList();
  }
}

extension NumberAbbreviation on int {
  String get abbreviateNumber {
    if (this >= 10000000) {
      return '${(this / 10000000).toStringAsFixed(1)} Cr';
    } else if (this >= 100000) {
      return '${(this / 100000).toStringAsFixed(1)} Lakh';
    } else if (this >= 1000 && this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    } else {
      return toString();
    }
  }
}

String convertToCurrencyRange(String input) {
  List<String> parts = input.split(', ');

  double minValue = double.parse(parts[0]);
  double maxValue = double.parse(parts[1]);
  String minAmount = (minValue * 1000).toString();
  String maxAmount = (maxValue * 1000).toString();
  String formattedMinAmount = formatCurrency(minAmount);
  String formattedMaxAmount = formatCurrency(maxAmount);
  return "â‚¹$formattedMinAmount-â‚¹$formattedMaxAmount";
}

String formatCurrency(String value) {
  value = value.replaceAll(',', '').trim();

  List<String> parts = value.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? parts[1] : '';

  int len = integerPart.length;
  if (len > 3) {
    String lastThree = integerPart.substring(len - 3);
    String rest = integerPart.substring(0, len - 3);
    List<String> restParts = [];
    while (rest.length > 2) {
      restParts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) restParts.insert(0, rest);
    integerPart = '${restParts.join(',')},$lastThree';
  }

  if (decimalPart.isNotEmpty) {
    decimalPart = decimalPart.padRight(2, '0').substring(0, 2);
    return '$integerPart.$decimalPart';
  } else {
    return '$integerPart.00';
  }
}

String formatAmount(int amount) {
  String formatted = amount.toString();
  String result = '';
  int count = 0;
  for (int i = formatted.length - 1; i >= 0; i--) {
    result = formatted[i] + result;
    count++;
    if (count == 3 && i != 0) {
      result = ',$result';
      count = 0;
    }
  }
  return result;
}

// String? getProductTag(Catalogue? catalogue) {
//   if (catalogue == null) return null;

//   if (catalogue.gender == 'all') {
//     return 'UNISEX';
//   } else if (catalogue.isPlusSize ?? false) {
//     return 'PLUS SIZE';
//   } else if (catalogue.isSustainable ?? false) {
//     return 'SUSTAINABLE';
//   } else if (catalogue.updatedAt != null &&
//       catalogue.updatedAt!.between(
//           DateTime.now().subtract(const Duration(days: 7)), DateTime.now())) {
//     return 'NEW';
//   }

//   return null;
// }

extension IndianNumberFormatting on String {
  int get getIndexByAlphabet {
    switch (this) {
      case 'a':
        return 0;
      case 'b':
        return 1;
      case 'c':
        return 2;
      case 'd':
        return 3;
      default:
        return -1;
    }
  }

  String formatIndianNumber() {
    if (isEmpty) {
      return '';
    }
    String value = replaceAll(',', '');
    final reversedValue = value.split('').reversed.join();
    final chunks = List<String>.generate(
      (reversedValue.length / 3).ceil(),
      (i) => reversedValue.substring(
        i * 3,
        (i + 1) * 3 < reversedValue.length ? (i + 1) * 3 : reversedValue.length,
      ),
    );
    final formattedValue = chunks.join(',').split('').reversed.join();
    return formattedValue;
  }

  int parseIndianNumber() {
    if (isEmpty) {
      return 0;
    }
    final value = replaceAll(',', '');
    return int.tryParse(value) ?? 0;
  }
}

extension ConvertMinutesToHours on int {
  String get getAlphabet {
    switch (this) {
      case 0:
        return 'a';
      case 1:
        return 'b';
      case 2:
        return 'c';
      case 3:
        return 'd';
      default:
        return 'NA';
    }
  }

  String secToReadableTime() {
    int seconds = this;
    int days = (seconds / (60 * 60 * 24)).floor();
    int remainingTimeInSeconds = seconds % (60 * 60 * 24);
    int hours = (remainingTimeInSeconds / (60 * 60)).floor();
    int remainingTimeInMinutes = remainingTimeInSeconds % (60 * 60);
    int minutes = (remainingTimeInMinutes / 60).floor();
    int remainingSeconds = remainingTimeInMinutes % 60;

    String result = '';
    if (days > 0) {
      result += '$days days ';
    }
    if (hours > 0) {
      result += '$hours hours ';
    }
    if (minutes > 0) {
      if (minutes == 1) {
        result += '$minutes min ';
      } else {
        result += '$minutes mins ';
      }
    }
    if (remainingSeconds > 0 || result.isEmpty) {
      result += '$remainingSeconds seconds';
    }
    return result.trim();
  }

  String minToReadableTime({int threshold = 60}) {
    if (this < threshold) {
      return '$this mins';
    } else {
      int days = (this / (60 * 24)).floor();
      int remainingTimeInMinutes = this % (60 * 24);
      int hours = (remainingTimeInMinutes / 60).floor();
      int minutes = remainingTimeInMinutes % 60;

      String result = '';
      if (days > 0) {
        result += '$days days ';
      }
      if (hours > 0) {
        result += '$hours hours ';
      }
      if (minutes > 0 || result.isEmpty) {
        result += '$minutes mins';
      }
      return result.trim();
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Convert Color To HexCode
  String getHexCode() {
    return '#${value.toRadixString(16)}';
  }
}

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hrs ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hr ago' : 'An hr ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 min ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
