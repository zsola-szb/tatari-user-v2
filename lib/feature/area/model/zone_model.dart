import 'package:tatarigigs_user/util/core_export.dart';

class ZoneModel {
  String? id;
  String? name;
  int? providersCount;
  List<Coordinates>? formattedCoordinates;
  int? status;
  String? createdAt;
  String? updatedAt;


  ZoneModel({this.id, this.name, this.providersCount, this.formattedCoordinates, this.status, this.createdAt, this.updatedAt});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    providersCount = json['providers_count'];
    if (json['formatted_coordinates'] != null) {
      formattedCoordinates = <Coordinates>[];
      json['formatted_coordinates'].forEach((v) {
        formattedCoordinates!.add(Coordinates.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['providers_count'] = providersCount;
    if (formattedCoordinates != null) {
      data['formatted_coordinates'] = formattedCoordinates!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


