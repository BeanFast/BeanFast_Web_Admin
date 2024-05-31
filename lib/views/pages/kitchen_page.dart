import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/controllers/kitchen_controller.dart';
import '/models/kitchen.dart';
import '/views/pages/loading_page.dart';
import '/views/pages/widget/button_data_table.dart';
import '/views/pages/kitchen_detail.dart';
import 'widget/paginated_datatable_widget.dart';

class KitchenView extends GetView<KitchenController> {
  const KitchenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(KitchenController());
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
                    onPressed: showCreateKitchenDialog,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.8,
              child: const PaginatedDataTableView<KitchenController>(
                title: 'Danh sách bếp',
                columns: <DataColumn>[
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Hình ảnh')),
                  DataColumn(label: Text('Tên bếp')),
                  DataColumn(label: Text('Địa chỉ')),
                  DataColumn(label: Text('Người phụ trách')),
                  DataColumn(label: Text('Số trường')),
                  DataColumn(label: Text('')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow setRow(Kitchen kitchen) {
    return DataRow(
      cells: [
        DataCell(Text(kitchen.code.toString())),
        DataCell(
          SizedBox(
            height: 100,
            width: 100,
            child: Image.network(
              kitchen.imagePath.toString(),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        DataCell(Text(kitchen.name.toString())),
        DataCell(Text(kitchen.address.toString())),
        DataCell(Text(kitchen.manager!.fullName.toString())),
        DataCell(Text(kitchen.schoolCount!.toString())),
        DataCell(Row(
          children: [
            const Spacer(),
            DetailButtonDataTable(onPressed: () {
              Get.to(KitchenDetailView(kitchen));
            }),
          ],
        )),
      ],
    );
  }

  void showCreateKitchenDialog() {
    Get.dialog(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        child: AlertDialog(
          title: const Text('Thông tin bếp'),
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
                            ? Text('Chưa có ảnh',
                                style: Get.textTheme.bodyMedium)
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
                        child: TextButton(
                          onPressed: () async {
                            await controller.pickImage();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Iconsax.add,
                                size: 20,
                              ),
                              Text('Thay đổi ảnh',
                                  style: Get.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: controller.nameText,
                          decoration: const InputDecoration(
                            labelText: 'Tên bếp',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 200,
                          validator: (value) {
                            int minLenght = 10;
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < minLenght) {
                              return 'Vui lòng nhập tên bếp có độ dài tối thiểu là $minLenght ký tự';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showManagersDialog();
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Iconsax.location),
                          title: Text('Người quản lý',
                              style: Get.textTheme.bodyMedium),
                          subtitle: Obx(
                            () => Text(
                                controller.selectedManager.value == null
                                    ? 'Trống'
                                    : '${controller.selectedManager.value!.fullName}',
                                style: Get.textTheme.bodySmall),
                          ),
                          trailing: const Icon(Iconsax.arrow_circle_right),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showAreaDialog();
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Iconsax.location),
                          title:
                              Text('Khu vực', style: Get.textTheme.bodyMedium),
                          subtitle: Obx(
                            () => Text(
                                controller.selectedArea.value == null
                                    ? 'Chưa chọn khu vực'
                                    : '${controller.selectedArea.value!.ward}, ${controller.selectedArea.value!.district}, ${controller.selectedArea.value!.city}',
                                style: Get.textTheme.bodySmall),
                          ),
                          trailing: const Icon(Iconsax.arrow_circle_right),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: controller.addressText,
                          decoration: const InputDecoration(
                            labelText: 'Địa chỉ',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 500,
                          validator: (value) {
                            int minLenght = 10;
                            if (value == null ||
                                value.isEmpty ||
                                value.length < minLenght) {
                              return 'Vui lòng nhập địa chỉ có độ dài tối thiểu là $minLenght ký tự';
                            }
                            return null;
                          },
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

  void showAreaDialog() {
    Get.dialog(AlertDialog(
      title: Text('Chọn khu vực', style: Get.textTheme.titleMedium),
      content: LoadingView(
        future: () async {
          await controller.getAllArea();
        },
        child: SizedBox(
          width: Get.width * 0.8,
          height: Get.height * 0.5,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  onChanged: (value) => controller.searchArea(value),
                  decoration: const InputDecoration(
                    labelText: 'Tìm kiếm',
                  ),
                  style: Get.theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: Get.height * 0.44,
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      children: controller.listArea.map(
                        (area) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                  '${area.ward}, ${area.district}, ${area.city}'),
                              onTap: () {
                                Get.back();
                                controller.selectArea(area);
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void showManagersDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Chọn người quản lý',
          style: Get.textTheme.titleMedium,
        ),
        content: LoadingView(
          future: controller.getUsersNoKitchen,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              child: Obx(
                () => Column(
                  children: controller.managerlist.map((manager) {
                    return Card(
                      child: ListTile(
                        title: Text('Tên: ${manager.fullName}',
                            style: Get.textTheme.bodyMedium),
                        subtitle: Text(manager.email.toString(),
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.black54)),
                        onTap: () {
                          Get.back();
                          controller.selectManager(manager);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
