import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

enum PrintType {
  informative('💁'),
  warning('⚠️Warning: '),
  exception('️🐞❗Exception: '),
  error('❌'),
  simple('👍'),
  debug('🟣');

  final String icon;

  const PrintType(this.icon);
}

void printWithCheck(String message, {int? wrapWidth, PrintType? type}) {
  if (kDebugMode) {
    final msg = type == null ? message : '${type.icon} $message';
    debugPrint(msg, wrapWidth: wrapWidth);
  }
}

/// Prints a warning message with an icon.
///
/// Example:
/// printWarning("API response time is slow.");
void printWarning(String message, {int? wrapWidth}) {
  printWithCheck(message, wrapWidth: wrapWidth, type: PrintType.warning);
}

/// Prints an exception message with an icon.
///
/// Example:
/// printException("Caught an e: ${e.toString()}");
void printException(String message, {String? exception, String? stack, int? wrapWidth}) {
  final msg = '$message \nException: $exception \nStack: $stack';
  printWithCheck(msg, wrapWidth: wrapWidth, type: PrintType.exception);
}

/// Prints an error message with an icon.
///
/// Example:
/// printError("Failed to fetch data from the server");
void printError(String message, {int? wrapWidth}) {
  printWithCheck(message, wrapWidth: wrapWidth, type: PrintType.error);
}

/// Prints a simple success or confirmation message with an icon.
///
/// Example:
/// printSimple("Operation completed successfully");
void printSimple(String message, {int? wrapWidth}) {
  printWithCheck(message, wrapWidth: wrapWidth, type: PrintType.simple);
}

// /// An enum representing different types of log messages, each with a
// /// corresponding icon and label for visual distinction, and a color.
// enum LogType {
//   /// For general information or successful operations.
//   info('🔵 INFO', AnsiColor.blue),
//
//   /// For potential issues that don't stop execution but might need attention.
//   warning('🟠 WARN', AnsiColor.yellow),
//
//   /// For exceptions caught during execution.
//   exception('🔴 EXCEPT', AnsiColor.red),
//
//   /// For critical errors that indicate a failure.
//   error('❌ ERROR', AnsiColor.red),
//
//   /// For successful operations or confirmations.
//   success('✅ SUCCESS', AnsiColor.green),
//
//   /// For debugging specific values or states.
//   debug('🟣 DEBUG', AnsiColor.magenta);
//
//   /// The icon and label associated with each log type.
//   final String label;
//
//   /// The ANSI color associated with each log type.
//   final AnsiColor color;
//
//   const LogType(this.label, this.color);
// }
//
// /// A class to define ANSI escape codes for colors.
// class AnsiColor {
//   final int foreground;
//   final int background;
//
//   const AnsiColor.rgb(this.foreground, [this.background = 0]);
//
//   // Predefined colors
//   static const AnsiColor black = AnsiColor.rgb(30);
//   static const AnsiColor red = AnsiColor.rgb(31);
//   static const AnsiColor green = AnsiColor.rgb(32);
//   static const AnsiColor yellow = AnsiColor.rgb(33);
//   static const AnsiColor blue = AnsiColor.rgb(34);
//   static const AnsiColor magenta = AnsiColor.rgb(35);
//   static const AnsiColor cyan = AnsiColor.rgb(36);
//   static const AnsiColor white = AnsiColor.rgb(37);
//   static const AnsiColor reset = AnsiColor.rgb(0); // Reset all attributes
//
//   String call(String msg) {
//     return '\x1B[${foreground}m$msg\x1B[${reset.foreground}m';
//   }
// }
//
// /// A highly customizable debug printing function that wraps Flutter's
// /// `debugPrint`. It only prints in debug mode and allows for various
// /// levels of detail, formatting, and now, colorization using ANSI codes.
// ///
// /// [message] The primary message to be printed.
// /// [tag] An optional tag to categorize the log message (e.g., "API", "UI").
// /// [type] The type of log message (e.g., [LogType.info], [LogType.error]).
// /// [wrapWidth] The maximum width of the output line before wrapping.
// /// [includeTimestamp] Whether to include a timestamp with the log message.
// /// [includeLocation] Whether to include the file and line number where
// /// the log was called.
// void customDebugPrint(
//     dynamic message, {
//       String? tag,
//       LogType type = LogType.info,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   if (kDebugMode) {
//     final StringBuffer buffer = StringBuffer();
//
//     // Add timestamp
//     if (includeTimestamp) {
//       final now = DateTime.now();
//       buffer.write('${now.hour}:${now.minute}:${now.second}.${now.millisecond} ');
//     }
//
//     // Add log type label with color
//     buffer.write(type.color('${type.label}: '));
//
//     // Add tag if provided
//     if (tag != null) {
//       buffer.write(type.color('[$tag] ')); // Also colorize the tag
//     }
//
//     // Add message
//     buffer.write(type.color(message.toString())); // Colorize the message
//
//     // Add calling file and line number (less reliable in release builds,
//     // and can be expensive in debug builds, use judiciously)
//     if (includeLocation) {
//       try {
//         throw Exception();
//       } catch (e, st) {
//         final frames = st.toString().split('\n');
//         final relevantFrame = frames.firstWhere(
//               (frame) =>
//           !frame.contains('custom_debug_print.dart') &&
//               frame.contains('.dart:'),
//           orElse: () => '',
//         );
//         if (relevantFrame.isNotEmpty) {
//           final regex = RegExp(r'(\S+\.dart):(\d+):(\d+)');
//           final match = regex.firstMatch(relevantFrame);
//           if (match != null && match.groupCount >= 2) {
//             final fileName = match.group(1)?.split('/').last;
//             final lineNumber = match.group(2);
//             buffer.write(type.color(' (at $fileName:$lineNumber)')); // Colorize location
//           }
//         }
//       }
//     }
//
//     // The entire string with ANSI codes will be passed to debugPrint
//     debugPrint(buffer.toString(), wrapWidth: wrapWidth);
//   }
// }
//
// // --- Convenience Functions (remain largely the same, but now implicitly use colors) ---
//
// /// Prints an informational message.
// void logInfo(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.info,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
//
// /// Prints a warning message.
// void logWarning(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.warning,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
//
// /// Prints an exception message.
// void logException(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.exception,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
//
// /// Prints an error message.
// void logError(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.error,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
//
// /// Prints a success message.
// void logSuccess(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.success,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
//
// /// Prints a debug message.
// void logDebug(
//     dynamic message, {
//       String? tag,
//       int? wrapWidth,
//       bool includeTimestamp = true,
//       bool includeLocation = false,
//     }) {
//   customDebugPrint(
//     message,
//     tag: tag,
//     type: LogType.debug,
//     wrapWidth: wrapWidth,
//     includeTimestamp: includeTimestamp,
//     includeLocation: includeLocation,
//   );
// }
