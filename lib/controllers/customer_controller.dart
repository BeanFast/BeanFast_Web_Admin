import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '/contains/contain.dart';
import '/services/user_service.dart';
import '/views/pages/customer_page.dart';
import '/models/user.dart';
import 'data_table_controller.dart';

class CustomerController extends DataTableController<User> {

  Future changeActive(String id, bool isActive) async {
    try {
      await UserService().changeActive(id, isActive);
      Get.back();
      Get.snackbar('Thành công', '');
      await refreshData();
    } on DioException catch (e) {
      Get.snackbar('Lỗi', e.response!.data['message']);
    }
  }

  @override
  void search(String value) {
    if (value.isEmpty) {
      setDataTable(initModelList);
    } else {
      currentModelList = initModelList
          .where((e) =>
              e.code!.toLowerCase().contains(value.toLowerCase()) ||
              e.fullName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      setDataTable(currentModelList);
    }
  }

  void sortByName(int index) {
    columnIndex.value = index;
    columnAscending.value = !columnAscending.value;
    currentModelList.sort((a, b) => a.fullName!.compareTo(b.fullName!));
    if (!columnAscending.value) {
      currentModelList = currentModelList.reversed.toList();
    }
    setDataTable(currentModelList);
  }

  @override
  Future getData(list) async {
    try {
      final apiDataList = await UserService().getByRoleId(selectedRole!.id);
      for (var e in apiDataList) {
        initModelList.add(e);
      }
    } on DioException catch (e) {
      Get.snackbar('Lỗi', e.response!.data['message']);
    }
  }

  @override
  void setDataTable(List<User> list) {
    rows.value = list.map((dataMap) {
      return const CustomerView().setRow(list.indexOf(dataMap), dataMap);
    }).toList();
  }

  @override
  Future loadPage(int page) {
    // TODO: implement loadPage
    throw UnimplementedError();
  }
}
