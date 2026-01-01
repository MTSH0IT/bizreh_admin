import 'package:bizreh_admin/features/Brands/views/brands_view.dart';
import 'package:bizreh_admin/features/category/views/category_view.dart';
import 'package:bizreh_admin/features/subCategory/views/sub_category_view.dart';
import 'package:bizreh_admin/features/superCategory/views/super_category_view.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/mainView/views/widgets/admin_sidebar.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Row(
          children: [
            AdminSidebar(
              selectedIndex: _selectedIndex,
              onSelect: (i) => setState(() => _selectedIndex = i),
            ),
            Expanded(
              child: Column(
                children: [
                  //const AdminTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _buildPage(),
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

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const _PlaceholderPage(title: 'Dashboard');
      case 1:
        return const _PlaceholderPage(title: 'Users');
      case 2:
        return const BrandsView();
      case 3:
        return const SuperCategoryView();
      case 4:
        return const CategoryView();
      case 5:
        return const SubCategoryView();
      case 6:
        return const _PlaceholderPage(title: 'Settings');
      default:
        return const _PlaceholderPage(title: 'Page');
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
