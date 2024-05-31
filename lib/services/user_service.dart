import 'package:beanfast_admin/models/user.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

import '/services/api_service.dart';

class UserService {
  final ApiService _apiService = getx.Get.put(ApiService());
  final String baseUrl = 'users';

  Future<List<User>> getByRoleId(String? roleId) async {
    Map<String, dynamic> queryParameters = {};
    if (roleId != null) {
      queryParameters['roleId'] = roleId.toString();
    }
    final response = await _apiService.request.get(baseUrl,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null);
    List<User> list = [];
    for (var e in response.data['data']) {
      list.add(User.fromJson(e));
    }
    list.sort((a, b) => b.status!.compareTo(a.status!));
    return list;
  }

  Future<bool> changeActive(String id, bool isActive) async {
    Map<String, dynamic> data = {
      'isActive': isActive,
    };
    final response =
        await _apiService.request.patch('$baseUrl/$id', data: data);
    return response.statusCode == 200;
  }

  Future<bool> create(User model) async {
    FormData formData = FormData.fromMap({
      'FullName': model.fullName,
      'Email': model.email,
      'Password': model.password,
      'RoleId': model.roleId,
      'image': MultipartFile.fromBytes(
        model.imageFile!.files.single.bytes!,
        filename: 'uploadFile.jpg',
      ),
    });
    Response response = await _apiService.request.post(baseUrl, data: formData);
    return response.statusCode == 201;
  }

  Future<List<User>> getNoKitchen() async {
    final response = await _apiService.request.get('$baseUrl/kitchens');
    List<User> list = [];
    for (var e in response.data['data']) {
      list.add(User.fromJson(e));
    }
    return list;
  }
}
