import 'package:bizreh_admin/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
