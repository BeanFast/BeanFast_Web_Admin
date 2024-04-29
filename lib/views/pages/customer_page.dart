import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/contains/contain.dart';
import '/enums/status_enum.dart';
import '/models/user.dart';
import '/controllers/customer_controller.dart';
import '/views/pages/loading_page.dart';
import '/views/pages/widget/data_table_page.dart';
import '/views/pages/widget/text_data_table_widget.dart';
import 'widget/text_active.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CustomerController());
    changeRole(RoleState.customer.code);
    return LoadingView(
      future: controller.refreshData,
      child: Obx(
        () => DataTableView(
          title: 'Quản lý khách hàng',
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
                label: const Text('Tên'),
                onSort: (index, ascending) => controller.sortByName(index)),
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
}
