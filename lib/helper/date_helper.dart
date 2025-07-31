import 'package:intl/intl.dart';

// class DateConverter {
//   static String formatDate(DateTime dateTime) {
//     return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
//   }

//   static String _timeFormatter({String timeFormat = '24'}) {
//     return timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
//   }
// }

class DateConverter {
  /// Formats the given DateTime object to a date string with a default format.
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
  }

  /// Formats the given DateTime object to a time string, allowing 12-hour or 24-hour formats.
  static String formatTime(DateTime dateTime, {String timeFormat = '24'}) {
    String timeFormatter = _timeFormatter(timeFormat: timeFormat);
    return DateFormat(timeFormatter).format(dateTime);
  }

  /// Determines the time format based on the given timeFormat parameter.
  static String _timeFormatter({String timeFormat = '24'}) {
    return timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  /// Parses a time string in HH:mm or hh:mm a format and returns a DateTime object.
  DateTime parseTimeString(String time, {String timeFormat = '24'}) {
    String timeFormatter = _timeFormatter(timeFormat: timeFormat);
    return DateFormat(timeFormatter).parse(time);
  }

  static String convertTo12HourFormat(String time) {
    try {
      // Parse the time string into a DateTime object.
      DateTime parsedTime = DateFormat("HH:mm").parse(time);

      // Format the DateTime object to 12-hour format with AM/PM.
      String formattedTime = DateFormat("hh:mm a").format(parsedTime);

      return formattedTime;
    } catch (e) {
      // Return the input time if parsing fails.
      return time;
    }
  }
}
