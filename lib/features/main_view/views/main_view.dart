import 'package:bizreh_admin/features/Brands/views/brands_view.dart';
import 'package:bizreh_admin/features/Driver/views/drivers_view.dart';
import 'package:bizreh_admin/features/category/views/all_category_view.dart';
import 'package:bizreh_admin/features/color_family/views/color_family_view.dart';
import 'package:bizreh_admin/features/discounts/views/discounts_view.dart';
import 'package:bizreh_admin/features/gifts/views/gifts_view.dart';
import 'package:bizreh_admin/features/ads/views/ads_view.dart';
import 'package:bizreh_admin/features/main_view/views/widgets/admin_topbar.dart';
import 'package:bizreh_admin/features/orders/views/orders_view.dart';
import 'package:bizreh_admin/features/offers_cart/views/offers_cart_view.dart';
import 'package:bizreh_admin/features/packaging/views/packagings_view.dart';
import 'package:bizreh_admin/features/points/views/points_view.dart';
import 'package:bizreh_admin/features/sub_category/views/all_sub_category_view.dart';
import 'package:bizreh_admin/features/super_category/views/super_category_view.dart';
import 'package:bizreh_admin/features/products/views/products_view.dart';
import 'package:bizreh_admin/features/product_top_silling/views/product_top_selling_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/users/views/users_view.dart';
import 'package:bizreh_admin/features/cities/views/cities_view.dart';
import 'package:bizreh_admin/features/suppliers/views/suppliers_view.dart';
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
                      scrollDirection: Axis.vertical,
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
        return const MainNavEntry(title: 'Users', page: UsersView());
      case 1:
        return const MainNavEntry(title: 'Brands', page: BrandsView());
      case 2:
        return const MainNavEntry(
          title: 'Super Categories',
          page: SuperCategoryView(),
        );
      case 3:
        return const MainNavEntry(title: 'Categories', page: AllCategoryView());
      case 4:
        return const MainNavEntry(
          title: 'Sub Categories',
          page: AllSubCategoryView(),
        );
      case 5:
        return const MainNavEntry(title: 'Products', page: ProductsView());
      case 6:
        return const MainNavEntry(
          title: 'Color Family',
          page: ColorFamilyView(),
        );
      case 7:
        return const MainNavEntry(
          title: 'Top Selling',
          page: ProductTopSellingView(),
        );
      case 8:
        return const MainNavEntry(title: 'Packagings', page: PackagingsView());
      case 9:
        return const MainNavEntry(title: 'Drivers', page: DriversView());
      case 10:
        return const MainNavEntry(title: 'Cities', page: CitiesView());
      case 11:
        return const MainNavEntry(title: 'Suppliers', page: SuppliersView());
      case 12:
        return const MainNavEntry(title: 'Orders', page: OrdersView());
      case 13:
        return const MainNavEntry(title: 'Discounts', page: DiscountsView());
      case 14:
        return const MainNavEntry(title: 'Points', page: PointsView());
      case 15:
        return const MainNavEntry(title: 'Gifts', page: GiftsView());

      case 16:
        return const MainNavEntry(title: 'Ads', page: AdsView());

      case 17:
        return const MainNavEntry(title: 'Offers Cart', page: OffersCartView());

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
