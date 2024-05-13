import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextActive extends StatelessWidget {
  final int status;
  const TextActive({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 0:
        return  Text('Đã khóa', style: Get.textTheme.bodyMedium!.copyWith(color: Colors.red));
      case 1:
        return  Text('Đang hoạt động', style: Get.textTheme.bodyMedium!.copyWith(color: Colors.green));
      default:
        return  Text('Đang hoạt động',style: Get.textTheme.bodyMedium!.copyWith(color: Colors.green));
    }
  }
}
