import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/controllers/deliverer_controller.dart';
import '/contains/contain.dart';
import '/enums/status_enum.dart';
import '/models/user.dart';
import '/views/pages/loading_page.dart';
import '/views/pages/widget/button_data_table.dart';
import 'widget/paginated_datatable_widget.dart';
import 'widget/text_active.dart';

class DelivererView extends GetView<DelivererController> {
  const DelivererView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DelivererController());
    changeRole(RoleState.deliverer.code);
    return LoadingView(
      future: controller.fetchData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      onChanged: (value) => controller.search(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        labelText: 'Tìm kiếm',
                      ),
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(),
                  CreateButtonDataTable(
                    onPressed: showDialog,
                  )
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.8,
              child: const PaginatedDataTableView<DelivererController>(
                title: 'Danh sách người giao hàng',
                columns: <DataColumn>[
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Hình ảnh')),
                  DataColumn(label: Text('Họ và tên')),
                  DataColumn(label: Text('Email')),
                  // DataColumn(label: Text('Số điện thoại')),
                  DataColumn(label: Text('Trạng thái')),
                  DataColumn(label: Text(' ')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow setRow(User user) {
    return DataRow(
      cells: [
        DataCell(Text(user.code.toString())),
        DataCell(
          SizedBox(
            height: 100,
            width: 100,
            child: Image.network(
              user.avatarPath.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        DataCell(Text(user.fullName.toString())),
        DataCell(Text(user.email.toString())),
        // DataCell(Text(user.phone.toString())),
        DataCell(TextActive(status: user.status!)),
        DataCell(Row(
          children: [
            const Spacer(),
            user.status! == ActiveStatus.active.index
                ? IconButton(
                    icon: const Icon(Iconsax.profile_delete),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Xác nhận',
                        content: const Text('Xác nhận khóa tài khoản?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              await controller.changeActive(user.id!, false);
                            },
                            child: const Text('Đồng ý'),
                          ),
                          TextButton(
                            child: const Text('Đóng'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  )
                : IconButton(
                    icon: const Icon(Iconsax.profile_add),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Xác nhận',
                        content: const Text('Xác nhận mở khóa tài khoản?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              await controller.changeActive(user.id!, true);
                            },
                            child: const Text('Đồng ý'),
                          ),
                          TextButton(
                            child: const Text('Đóng'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ],
        )),
      ],
    );
  }

  void showDialog() {
    Get.dialog(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width),
        child: AlertDialog(
          title: Text(
            'Thông tin tài khoản giao hàng',
            style: Get.textTheme.titleMedium,
          ),
          content: Form(
            key: controller.formCreateKey,
            child: SingleChildScrollView(
              child: SizedBox(
                width: Get.width * 0.8,
                child: ListBody(
                  children: [
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                        child: controller.selectedImageFile.value == null
                            ? Text(
                                'Chưa có ảnh',
                                style: Get.textTheme.bodyMedium,
                              )
                            : Image.memory(
                                controller.selectedImageFile.value!.files.single
                                    .bytes!,
                                width: 200,
                                height: 200,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                        child: SizedBox(
                          width: 140,
                          height: 40,
                          child: TextButton(
                            onPressed: () async {
                              await controller.pickImage();
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.add),
                                Text(
                                  'Thay đổi ảnh',
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: controller.fullName,
                          decoration: const InputDecoration(
                            labelText: 'Họ và tên',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 200,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: controller.emailText,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 200,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                          child: SizedBox(
                            child: TextFormField(
                              controller: controller.passwordText,
                              obscureText: controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                              maxLength: 50,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                if (!RegExp(
                                        r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,20}$')
                                    .hasMatch(value)) {
                                  return 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ hoa, chữ thường và số';
                                }

                                return null;
                              },
                            ),
                          ),
                        )),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                        child: SizedBox(
                          child: TextFormField(
                            obscureText: controller.isRePasswordVisible.value,
                            controller: controller.rePasswordText,
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isRePasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed:
                                    controller.toggleRePasswordVisibility,
                              ),
                            ),
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value != controller.passwordText.text) {
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await controller.submitForm();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Iconsax.add,
                    size: 20,
                  ),
                  Text('Lưu', style: Get.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
