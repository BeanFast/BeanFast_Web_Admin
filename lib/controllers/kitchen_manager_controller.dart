import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/views/pages/kitchen_manager_page.dart';
import '/contains/contain.dart';
import '/services/user_service.dart';
import '/enums/status_enum.dart';
import '/models/role.dart';
import '/models/user.dart';
import 'paginated_data_table_controller.dart';

class KitchenManagerController extends PaginatedDataTableController<User> {
  //Form
  final GlobalKey<FormState> formCreateKey = GlobalKey<FormState>();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();
  var selectedImageFile = Rxn<FilePickerResult>();
  var isPasswordVisible = true.obs;
  var isRePasswordVisible = true.obs;

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

  void clear() {
    fullName.clear();
    emailText.clear();
    passwordText.clear();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRePasswordVisibility() {
    isRePasswordVisible.value = !isRePasswordVisible.value;
  }

  Future submitForm() async {
    Role? role =
        listRole.firstWhereOrNull((e) => e.code == RoleState.deliverer.code);
    if (role == null) {
      Get.snackbar('Lỗi', 'Không có role');
      return;
    }
    if (selectedImageFile.value == null) {
      Get.snackbar('Thất bại', 'Ảnh trống');
      return;
    }
    if (formCreateKey.currentState!.validate()) {
      User model = User();
      model.fullName = fullName.text;
      model.email = emailText.text;
      model.password = passwordText.text;
      model.roleId = role.id;
      model.imageFile = selectedImageFile.value!;
      try {
        await UserService().create(model);
        Get.back();
        Get.snackbar('Thành công', '');
        await fetchData();
      } on DioException catch (e) {
        Get.snackbar('Lỗi', e.response!.data['title']);
      }
    } else {
      Get.snackbar('Thát bại', 'Thông tin chưa chính xác');
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

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      selectedImageFile.value = result;
    }
  }

  @override
  void setDataTable(List<User> list) {
    rows.value = list.map((dataMap) {
      return const KitchenManagerView().setRow(dataMap);
    }).toList();
  }

  @override
  Future fetchData() async {
    try {
      final data = await UserService().getByRoleId(selectedRole!.id);
      data.sort((a, b) => b.fullName!.compareTo(a.fullName!));
      dataList = data;
      setDataTable(dataList);
    } catch (e) {
      throw Exception();
    }
  }
}
