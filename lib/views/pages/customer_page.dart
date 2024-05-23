import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/contains/contain.dart';
import '/enums/status_enum.dart';
import '/models/user.dart';
import '/controllers/customer_controller.dart';
import '/views/pages/loading_page.dart';
import '/views/pages/widget/text_data_table_widget.dart';
import 'widget/paginated_datatable_widget.dart';
import 'widget/text_active.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CustomerController());
    changeRole(RoleState.customer.code);
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
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.8,
              child: const PaginatedDataTableView<CustomerController>(
                title: 'Danh sách khách hàng',
                columns: <DataColumn>[
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Hình ảnh')),
                  DataColumn(label: Text('Tên')),
                  DataColumn(label: Text('Số điện thoại')),
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
