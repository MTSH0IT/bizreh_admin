import 'package:bizreh_admin/features/Brands/views/brands_view.dart';
import 'package:bizreh_admin/features/Driver/views/drivers_view.dart';
import 'package:bizreh_admin/features/main_view/views/widgets/admin_topbar.dart';
import 'package:bizreh_admin/features/packaging/views/packagings_view.dart';
import 'package:bizreh_admin/features/super_category/views/super_category_view.dart';
import 'package:bizreh_admin/features/products/views/products_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/main_view/views/widgets/admin_sidebar.dart';
import 'package:get/get.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  int _selectedIndex = 0;
  late final MainNavController _nav = Get.put(MainNavController());
  @override
  void initState() {
    super.initState();

    _nav.resetTo(_buildRootEntry(_selectedIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Row(
          children: [
            AdminSidebar(
              selectedIndex: _selectedIndex,
              onSelect: (i) {
                setState(() => _selectedIndex = i);
                _nav.resetTo(_buildRootEntry(i));
              },
            ),
            Expanded(
              child: Column(
                children: [
                  const AdminTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Obx(() => _nav.current),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  MainNavEntry _buildRootEntry(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const MainNavEntry(
          title: 'Dashboard',
          page: _PlaceholderPage(title: 'Dashboard'),
        );
      case 1:
        return const MainNavEntry(
          title: 'Users',
          page: _PlaceholderPage(title: 'Users'),
        );
      case 2:
        return const MainNavEntry(title: 'Brands', page: BrandsView());
      case 3:
        return const MainNavEntry(
          title: 'Super Categories',
          page: SuperCategoryView(),
        );
      case 4:
        return const MainNavEntry(title: 'Products', page: ProductsView());
      case 5:
        return const MainNavEntry(title: 'Packagings', page: PackagingsView());
      case 6:
        return const MainNavEntry(title: 'Drivers', page: DriversView());
      case 7:
        return const MainNavEntry(
          title: 'Settings',
          page: _PlaceholderPage(title: 'Settings'),
        );
      default:
        return const MainNavEntry(
          title: 'Page',
          page: _PlaceholderPage(title: 'Page'),
        );
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
