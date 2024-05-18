import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextActive extends StatelessWidget {
  final int status;
  const TextActive({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 0:
        return const Text('Đã khóa', style: TextStyle(color: Colors.red));
      case 1:
        return const Text('Đang hoạt động',
            style: TextStyle(color: Colors.green));
      case 2:
        return const Text('Chưa xác thực');
      default:
        return  Text('Đang hoạt động',style: Get.textTheme.bodyMedium!.copyWith(color: Colors.green));
    }
  }
}
