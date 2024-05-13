import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/controllers/kitchen_manager_controller.dart';
import '/contains/contain.dart';
import '/enums/status_enum.dart';
import '/models/user.dart';
import '/views/pages/loading_page.dart';
import '/views/pages/widget/data_table_page.dart';
import '/views/pages/widget/button_data_table.dart';
import '/views/pages/widget/text_data_table_widget.dart';
import 'widget/text_active.dart';

class KitchenManagerView extends GetView<KitchenManagerController> {
  const KitchenManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(KitchenManagerController());
    changeRole(RoleState.kitchenManager.code);
    return LoadingView(
      future: controller.refreshData,
      child: Obx(
        () => DataTableView(
          title: 'Quản lý người giao hàng',
          header: CreateButtonDataTable(
            onPressed: showDialog,
          ),
          refreshData: controller.refreshData,
          loadPage: (page) => controller.loadPage(page),
          search: (value) => controller.search(value),
          sortColumnIndex: controller.columnIndex.value,
          sortAscending: controller.columnAscending.value,
          columns: <DataColumn>[
            const DataColumn(
              label: Text('Stt'),
            ),
            const DataColumn(
              label: Text('Code'),
            ),
            const DataColumn(label: Text('Hình ảnh')),
            DataColumn(
                label: const Text('Họ và tên'),
                onSort: (index, ascending) => controller.sortByName(index)),
            const DataColumn(
              label: Text('Email'),
            ),
            const DataColumn(
              label: Text('Số điện thoại'),
            ),
            const DataColumn(
              label: Text('Trạng thái'),
            ),
            const DataColumn(label: Text(' ')),
          ],
          // ignore: invalid_use_of_protected_member
          rows: controller.rows.value,
        ),
      ),
    );
  }

  DataRow setRow(int index, User user) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
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
        DataCell(
          TextDataTable(
            data: user.fullName.toString(),
            maxLines: 2,
            width: 200,
          ),
        ),
        DataCell(Text(user.email.toString())),
        DataCell(Text(user.phone.toString())),
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
            'Thông tin tài khoản bếp',
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
                                border: const UnderlineInputBorder(),
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
                                // if (!RegExp(
                                //         r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,20}$')
                                //     .hasMatch(value)) {
                                //   return 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ hoa, chữ thường và số';
                                // }
                                if (value != controller.passwordText.text) {
                                  return 'Mật khẩu không khớp';
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
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              border: const UnderlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
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
                              // if (!RegExp(
                              //         r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,20}$')
                              //     .hasMatch(value)) {
                              //   return 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ hoa, chữ thường và số';
                              // }
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
