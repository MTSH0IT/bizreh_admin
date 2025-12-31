import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T?> openFormDialog<T>({
  VoidCallback? onBeforeOpen,
  required WidgetBuilder dialogBuilder,
  bool barrierDismissible = false,
}) async {
  onBeforeOpen?.call();

  return Get.dialog<T>(
    Builder(builder: dialogBuilder),
    barrierDismissible: barrierDismissible,
  );
}
