import 'base_model.dart';

class Role extends BaseModel {
  String? code;
  String? name;
  String? englishName;
  String? description;
  String? shortDescription;

  Role({
    id,
    status,
    this.code,
    this.name,
    this.englishName,
    this.description,
    this.shortDescription,
  }) : super(id: id, status: status);

  factory Role.fromJson(dynamic json) {
    return Role(
      id: json["id"],
      status: json['status'],
      code: json["code"],
      name: json['name'],
      englishName: json['englishName'],
      description: json['description'],
      shortDescription: json['shortDescription'],
    );
  }
}
