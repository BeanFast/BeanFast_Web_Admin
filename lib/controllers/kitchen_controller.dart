import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/area.dart';
import '/services/area_service.dart';
import '/services/kitchen_service.dart';
import '/views/pages/kitchen_page.dart';
import '/models/kitchen.dart';
import 'paginated_data_table_controller.dart';

class KitchenController extends PaginatedDataTableController<Kitchen> {
  RxList<Area> listArea = <Area>[].obs;
  List<Area> listInitArea = [];
  //Form
  final GlobalKey<FormState> formCreateKey = GlobalKey<FormState>();
  final TextEditingController nameText = TextEditingController();
  final TextEditingController addressText = TextEditingController();
  Rx<Area?> selectedArea = Rx<Area?>(null);
  var selectedImageFile = Rxn<FilePickerResult>();

  Future submitForm() async {
    if (selectedImageFile.value == null) {
      Get.snackbar('Thất bại', 'Ảnh trống');
      return;
    }
    if (selectedArea.value == null) {
      Get.snackbar('Thất bại', 'Chưa có thông tin khu vực');
      return;
    }
    if (formCreateKey.currentState!.validate()) {
      Kitchen model = Kitchen();
      model.name = nameText.text;
      model.address = addressText.text;
      model.areaId = selectedArea.value!.id!;
      model.imageFile = selectedImageFile.value!;
      try {
        await KitchenService().create(model);
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
      var searchDataList = dataList
          .where((e) =>
              e.code!.toLowerCase().contains(value.toLowerCase()) ||
              e.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      setDataTable(searchDataList);
    }
  }

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      selectedImageFile.value = result;
    }
  }

  void searchArea(String value) {
    listArea.clear();
    if (value.isEmpty) {
      listArea.addAll(listInitArea);
    } else {
      listArea.value = listInitArea
          .where((e) =>
              e.ward!.toLowerCase().contains(value.toLowerCase()) ||
              e.district!.toLowerCase().contains(value.toLowerCase()) ||
              e.city!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  Future getAllArea() async {
    listArea.clear();
    try {
      var data = await AreaService().getAll();
      listInitArea = data;
      listArea.addAll(listInitArea);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  void selectArea(Area area) {
    selectedArea.value = area;
  }

  @override
  void setDataTable(List<Kitchen> list) {
    rows.value = list.map((dataMap) {
      return const KitchenView().setRow(dataMap);
    }).toList();
  }

  @override
  Future fetchData() async {
    try {
      final data = await KitchenService().getAll();
      data.sort((a, b) => b.schoolCount!.compareTo(a.schoolCount!));
      dataList = data;
      setDataTable(dataList);
    } catch (e) {
      throw Exception();
    }
  }
}
