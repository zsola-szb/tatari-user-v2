import 'package:tatarigigs_user/util/core_export.dart';

abstract class BookingParse {
  static String? string(dynamic value) {
    if (value == null) {
      return null;
    }
    final String text = value.toString().trim();
    if (text.isEmpty || text == 'null') {
      return null;
    }
    return text;
  }

  static double toDouble(dynamic value, {double fallback = 0}) => doubleOrNull(value) ?? fallback;

  static double? doubleOrNull(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    final String? text = string(value);
    return text == null ? null : double.tryParse(text);
  }

  static int toInt(dynamic value, {int fallback = 0}) => intOrNull(value) ?? fallback;

  static int? intOrNull(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    final String? text = string(value);
    return text == null ? null : int.tryParse(text) ?? double.tryParse(text)?.toInt();
  }

  static bool toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final String? text = string(value)?.toLowerCase();
    return text == '1' || text == 'true';
  }

  static DateTime? utcDate(dynamic value) {
    final String? text = string(value);
    if (text == null) {
      return null;
    }
    try {
      return DateConverter.isoUtcStringToLocalDate(text);
    } catch (_) {
      return DateTime.tryParse(text);
    }
  }

  static DateTime? plainDate(dynamic value) {
    final String? text = string(value);
    return text == null ? null : DateTime.tryParse(text);
  }

  static List<String> stringList(dynamic value) {
    if (value is! List) {
      return const <String>[];
    }
    return value.map(string).whereType<String>().toList(growable: false);
  }

  static List<T> objectList<T>(dynamic value, T Function(Map<String, dynamic>) parse) {
    if (value is! List) {
      return const <Never>[];
    }
    return value.whereType<Map>().map((Map item) => parse(Map<String, dynamic>.from(item))).toList(growable: false);
  }

  static Map<String, dynamic>? object(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;
}
