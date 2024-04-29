import 'package:get/get.dart' as getx;

import '/models/role.dart';
import '/services/api_service.dart';

class RoleService {
  final ApiService _apiService = getx.Get.put(ApiService());
  final String baseUrl = 'roles';

  Future<List<Role>> getAll() async {
    final response = await _apiService.request.get(baseUrl);
    List<Role> list = [];
    for (var e in response.data['data']) {
      list.add(Role.fromJson(e));
    }
    return list;
  }
}
