class NotificationModel {
  String? responseCode;
  String? message;
  int? unreadCount;
  int? totalSize;
  String? limit;
  String? offset;
  List<NotificationData>? data;
  List<dynamic>? errors;

  NotificationModel({
    this.responseCode,
    this.message,
    this.unreadCount,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    unreadCount = json['unread_count'];
    totalSize = json['total_size'];
    limit = json['limit']?.toString();
    offset = json['offset']?.toString();
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = List<dynamic>.from(json['errors']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['response_code'] = responseCode;
    map['message'] = message;
    map['unread_count'] = unreadCount;
    map['total_size'] = totalSize;
    map['limit'] = limit;
    map['offset'] = offset;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }
}

class NotificationData {
  String? id;
  String? source;
  String? notificationKey;
  String? group;
  String? title;
  String? description;
  String? referenceId;
  String? referenceType;
  String? imageFullPath;
  bool? isRead;
  String? createdAt;

  NotificationData({
    this.id,
    this.source,
    this.notificationKey,
    this.group,
    this.title,
    this.description,
    this.referenceId,
    this.referenceType,
    this.imageFullPath,
    this.isRead,
    this.createdAt,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
    notificationKey = json['notification_key'];
    group = json['group'];
    title = json['title'];
    description = json['description'];
    referenceId = json['reference_id'];
    referenceType = json['reference_type'];
    imageFullPath = json['image_full_path'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['source'] = source;
    map['notification_key'] = notificationKey;
    map['group'] = group;
    map['title'] = title;
    map['description'] = description;
    map['reference_id'] = referenceId;
    map['reference_type'] = referenceType;
    map['image_full_path'] = imageFullPath;
    map['is_read'] = isRead;
    map['created_at'] = createdAt;
    return map;
  }
}
