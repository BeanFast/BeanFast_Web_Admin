import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '/contains/contain.dart';
import '/services/user_service.dart';
import '../views/pages/customer_page.dart';
import '/models/user.dart';
import 'paginated_data_table_controller.dart';

class CustomerController extends PaginatedDataTableController<User> {

  Future changeActive(String id, bool isActive) async {
    try {
      await UserService().changeActive(id, isActive);
      Get.back();
      Get.snackbar('Thành công', '');
      await fetchData();
    } on DioException catch (e) {
      Get.snackbar('Lỗi', e.response!.data['message']);
    }
  }

  void search(String value) {
    if (value.isEmpty) {
      setDataTable(dataList);
    } else {
      var list = dataList
          .where((e) =>
              e.code!.toLowerCase().contains(value.toLowerCase()) ||
              e.fullName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      setDataTable(list);
    }
  }

  @override
  void setDataTable(List<User> list) {
    rows.value = list.map((dataMap) {
      return const CustomerView().setRow( dataMap);
    }).toList();
  }
  
  @override
  Future fetchData() async {
    try {
      final data = await UserService().getByRoleId(selectedRole!.id);
      data.sort((a, b) => a.fullName!.compareTo(b.fullName!));
      dataList = data;
      setDataTable(dataList);
    } catch (e) {
      throw Exception(e);
    }
  }
}
