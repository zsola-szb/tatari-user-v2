class PaginatedEnvelope {
  final List<dynamic> rows;
  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? from;

  const PaginatedEnvelope({this.rows = const <dynamic>[], this.currentPage, this.lastPage, this.total, this.from});

  factory PaginatedEnvelope.fromJson(Map<String, dynamic> json) {
    final int? total = toInt(json['total'] ?? json['total_size']);
    final int? limit = toInt(json['per_page'] ?? json['limit']);
    final int? lastPage = toInt(json['last_page']) ??
        (total != null && limit != null && limit > 0 ? (total / limit).ceil() : null);

    return PaginatedEnvelope(
      rows: json['data'] is List ? json['data'] as List<dynamic> : const <dynamic>[],
      currentPage: toInt(json['current_page'] ?? json['offset']),
      lastPage: lastPage,
      total: total,
      from: toInt(json['from']),
    );
  }

  static Map<String, dynamic>? resolve(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    if (content is Map<String, dynamic>) {
      return content;
    }
    if (json['data'] is List) {
      return json;
    }
    return null;
  }

  static List<Map<String, dynamic>> rowsOf(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const <Map<String, dynamic>>[];
    }
    final Map<String, dynamic>? content = resolve(json);
    if (content == null) {
      return const <Map<String, dynamic>>[];
    }
    return PaginatedEnvelope.fromJson(content).rows.whereType<Map<String, dynamic>>().toList();
  }

  static int? toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value');
  }
}