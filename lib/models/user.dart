import 'package:file_picker/file_picker.dart';

import 'base_model.dart';
import 'role.dart';

class User extends BaseModel {
  String? roleId;
  String? code;
  String? fullName;
  String? phone;
  String? email;
  String? password;
  String? avatarPath;
  String? deviceToken;
  String? roleName;
  Role? role;
  //image file
  FilePickerResult? imageFile;

  User({
    id,
    status,
    this.roleId,
    this.code,
    this.fullName,
    this.phone,
    this.email,
    this.password,
    this.avatarPath,
    this.roleName,
    this.role,
    this.imageFile,
  }) : super(id: id, status: status);

  factory User.fromJson(dynamic json) {
    return User(
      id: json["id"],
      status: json['status'],
      code: json['code'],
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      email: json['email'],
      avatarPath: json['avatarPath'],
      roleName: json['roleName'],
      role: json['role'] == null ? Role() : Role.fromJson(json['role']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "accessToken": accessToken.toString(),
  //     "id": id.toString(),
  //     "storeId": storeId.toString(),
  //     "name": name,
  //     "username": userName,
  //     "role": userRole,
  //     "status": status,
  //     "picUrl": picUrl ?? "",
  //   };
  // }
}
