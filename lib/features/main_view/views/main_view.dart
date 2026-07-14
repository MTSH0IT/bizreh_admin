import 'package:bizreh_admin/features/Brands/views/brands_view.dart';
import 'package:bizreh_admin/features/Driver/views/drivers_view.dart';
import 'package:bizreh_admin/features/category/views/all_category_view.dart';
import 'package:bizreh_admin/features/collections/views/collection_view.dart';
import 'package:bizreh_admin/features/color_family/views/color_family_view.dart';
import 'package:bizreh_admin/features/discounts/views/discounts_view.dart';
import 'package:bizreh_admin/features/gifts/views/gifts_view.dart';
import 'package:bizreh_admin/features/payment/views/payments_view.dart';
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
import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  int _selectedIndex = 0;
  late final MainNavController _nav = Get.find<MainNavController>();
  late final List<_MainMenuItem> _menuItems;

  @override
  void initState() {
    super.initState();

    final userType = Get.find<AuthController>().userType;

    final allItems = [
      _MainMenuItem(
        title: 'Users',
        icon: Icons.group_outlined,
        entry: const MainNavEntry(title: 'Users', page: UsersView()),
      ),
      _MainMenuItem(
        title: 'Brands',
        icon: Icons.local_offer_outlined,
        entry: const MainNavEntry(title: 'Brands', page: BrandsView()),
      ),
      _MainMenuItem(
        title: 'Super Categories',
        icon: Icons.category_outlined,
        entry: const MainNavEntry(
          title: 'Super Categories',
          page: SuperCategoryView(),
        ),
      ),
      _MainMenuItem(
        title: 'Categories',
        icon: Icons.list_alt,
        entry: const MainNavEntry(title: 'Categories', page: AllCategoryView()),
      ),
      _MainMenuItem(
        title: 'Sub Categories',
        icon: Icons.subdirectory_arrow_right_rounded,
        entry: const MainNavEntry(
          title: 'Sub Categories',
          page: AllSubCategoryView(),
        ),
      ),
      _MainMenuItem(
        title: 'Collection',
        icon: Icons.collections_bookmark_outlined,
        entry: const MainNavEntry(title: 'Collection', page: CollectionView()),
      ),
      _MainMenuItem(
        title: 'Products',
        icon: Icons.inventory_2_outlined,
        entry: const MainNavEntry(title: 'Products', page: ProductsView()),
      ),
      _MainMenuItem(
        title: 'Color Family',
        icon: Icons.palette_outlined,
        entry: const MainNavEntry(title: 'Color Family', page: ColorFamilyView()),
      ),
      _MainMenuItem(
        title: 'Top Selling',
        icon: Icons.star_border,
        entry: const MainNavEntry(
          title: 'Top Selling',
          page: ProductTopSellingView(),
        ),
      ),
      _MainMenuItem(
        title: 'Packagings',
        icon: Icons.all_inbox_outlined,
        entry: const MainNavEntry(title: 'Packagings', page: PackagingsView()),
      ),
      _MainMenuItem(
        title: 'Drivers',
        icon: Icons.local_shipping_outlined,
        entry: const MainNavEntry(title: 'Drivers', page: DriversView()),
      ),
      _MainMenuItem(
        title: 'Cities',
        icon: Icons.location_city_outlined,
        entry: const MainNavEntry(title: 'Cities', page: CitiesView()),
      ),
      _MainMenuItem(
        title: 'Suppliers',
        icon: Icons.store_outlined,
        entry: const MainNavEntry(title: 'Suppliers', page: SuppliersView()),
      ),
      _MainMenuItem(
        title: 'Orders',
        icon: Icons.shopping_cart_outlined,
        entry: const MainNavEntry(title: 'Orders', page: OrdersView()),
      ),
      _MainMenuItem(
        title: 'Discounts',
        icon: Icons.percent_outlined,
        entry: const MainNavEntry(title: 'Discounts', page: DiscountsView()),
      ),
      _MainMenuItem(
        title: 'Points',
        icon: Icons.point_of_sale,
        entry: const MainNavEntry(title: 'Points', page: PointsView()),
      ),
      _MainMenuItem(
        title: 'Gifts',
        icon: Icons.card_giftcard_outlined,
        entry: const MainNavEntry(title: 'Gifts', page: GiftsView()),
      ),
      _MainMenuItem(
        title: 'Payments',
        icon: Icons.payments_outlined,
        entry: const MainNavEntry(title: 'Payments', page: PaymentsView()),
      ),
      _MainMenuItem(
        title: 'Ads',
        icon: Icons.campaign_outlined,
        entry: const MainNavEntry(title: 'Ads', page: AdsView()),
      ),
      _MainMenuItem(
        title: 'Offers Cart',
        icon: Icons.shopping_bag_outlined,
        entry: const MainNavEntry(title: 'Offers Cart', page: OffersCartView()),
      ),
    ];

    if (userType == 'data_entry') {
      final productInputTitles = {
        'Brands',
        'Super Categories',
        'Categories',
        'Sub Categories',
        'Collection',
        'Products',
        'Color Family',
        'Packagings',
      };
      _menuItems = allItems.where((item) => productInputTitles.contains(item.title)).toList();
    } else {
      _menuItems = allItems;
    }

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
              items: _menuItems
                  .map(
                    (e) => AdminSidebarItemData(title: e.title, icon: e.icon),
                  )
                  .toList(),
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
    if (selectedIndex >= 0 && selectedIndex < _menuItems.length) {
      return _menuItems[selectedIndex].entry;
    }
    return const MainNavEntry(
      title: 'Page',
      page: _PlaceholderPage(title: 'Page'),
    );
  }
}

class _MainMenuItem {
  final String title;
  final IconData icon;
  final MainNavEntry entry;

  const _MainMenuItem({
    required this.title,
    required this.icon,
    required this.entry,
  });
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
