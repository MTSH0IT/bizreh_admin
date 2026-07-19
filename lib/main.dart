import 'package:bizreh_admin/features/auth/views/login_view.dart';
import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';
import 'package:bizreh_admin/features/main_view/views/main_view.dart';
import 'package:bizreh_admin/utils/widgets/app_scroll_behavior.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';

import 'package:bizreh_admin/helper/di/service_locator.dart' as di;
import 'package:bizreh_admin/helper/bindings/app_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      home: const _RootDecider(),
      scrollBehavior: const AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _RootDecider extends StatefulWidget {
  const _RootDecider();

  @override
  State<_RootDecider> createState() => _RootDeciderState();
}

class _RootDeciderState extends State<_RootDecider> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _attemptAutoLogin();
  }

  Future<void> _attemptAutoLogin() async {
    final success = await _authController.tryAutoLogin();
    if (!mounted) return;

    if (success) {
      Get.offAll(() => MainView());
    } else {
      Get.offAll(() => const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BuildProgressIndicator());
  }
}
