import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AppDownloader {
  static String urlToFilename(String url) {
    return url.replaceAll(":", "").replaceAll("/", "").replaceAll(".", "");
  }

  static Future<String?> downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    print("[AppDownloader] Downloading: $url");
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/${urlToFilename(fileName)}.png';
    final response = await Dio().download(url, filePath);
    if (response.statusCode == 200) {
      return filePath;
    } else {
      return null;
    }
  }
}
