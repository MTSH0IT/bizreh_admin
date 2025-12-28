// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// Future<void> showTextInputDialog({
//   required String title,
//   required String confirmText,
//   required String cancelText,
//   String? hintText,
//   int maxLines = 1,
//   required void Function(TextEditingController controller) onConfirm,
// }) async {
//   final controller = TextEditingController();

//   Get.defaultDialog(
//     title: title,
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             hintText: hintText,
//           ),
//         ),
//       ],
//     ),
//     textConfirm: confirmText,
//     textCancel: cancelText,
//     onConfirm: () => onConfirm(controller),
//   );
// }
