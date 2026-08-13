import 'dart:core';

import 'package:flutter/foundation.dart';

/// Log levels for console output
enum LogLevel { debug, info, success, warn, error }

/// Console logger for the main app.
///
/// Replaces ad-hoc `dart:developer` `log()` calls with level-aware output,
/// mirroring the CLI's [stac_cli.lib.src.utils.console_logger.ConsoleLogger].
/// Every line is prefixed with its level and routed through Flutter's
/// `debugPrint` so long payloads aren't dropped on Android. Lines are
/// colourised when the process stdout supports ANSI escapes (desktop/flutter
/// run terminals); on-device logs fall back to plain prefixes.
class ConsoleLogger {
  /// Log a debug message (silenced when [setVerbose] is false).
  static void debug(String message) {
    _log(message, LogLevel.debug, '\x1B[90m');
  }

  /// Log an info message
  static void info(String message) {
    _log(message, LogLevel.info, '\x1B[34m'); // Blue
  }

  /// Log a success message
  static void success(String message) {
    _log(message, LogLevel.success, '\x1B[32m'); // Green
  }

  /// Log a warning message
  static void warn(String message) {
    _log(message, LogLevel.warn, '\x1B[33m'); // Yellow
  }

  /// Log an error message, optionally carrying the underlying [error] and
  /// [stackTrace] (e.g. from [FlutterErrorDetails] or `runZonedGuarded`).
  static void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      LogLevel.error,
      '\x1B[31m', // Red
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Print a message without any level prefix.
  static void plain(String message) {
    debugPrint(message);
  }

  static void _log(
    String message,
    LogLevel level,
    String color, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final prefix = _getPrefix(level);
    final label = (name != null && name.isNotEmpty) ? ' [$name]' : '';

    // if (stdout.hasTerminal) {
    if (kDebugMode) {
      print('$color$prefix\x1B[0m$label $message');
    } else {
      debugPrint('$prefix$label $message');
    }
    if (error != null) {
      if (kDebugMode) {
        print('$color Error:\x1B[0m $error');
      } else {
        debugPrint('  Error: $error');
      }
    }
    if (stackTrace != null) {
      if (kDebugMode) {
        print('\x1B[31m [StackTrace]\x1B[0m${stackTrace.toString()}');
      } else {
        debugPrint(stackTrace.toString());
      }
    }
  }

  static String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO]';
      case LogLevel.success:
        return '[SUCCESS]';
      case LogLevel.warn:
        return '[WARN]';
      case LogLevel.error:
        return '[ERROR]';
    }
  }
}
