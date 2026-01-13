import 'package:flutter/material.dart';

class AdminSidebarItemData {
  final String title;
  final IconData icon;

  const AdminSidebarItemData({required this.title, required this.icon});
}

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  static const double width = 200;

  @override
  Widget build(BuildContext context) {
    final items = <AdminSidebarItemData>[
      const AdminSidebarItemData(title: 'Dashboard', icon: Icons.home_outlined),
      const AdminSidebarItemData(title: 'Users', icon: Icons.group_outlined),
      const AdminSidebarItemData(
        title: 'Brands',
        icon: Icons.local_offer_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Super Categories',
        icon: Icons.category_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Categories',
        icon: Icons.category_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Sub Categories',
        icon: Icons.category_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Products',
        icon: Icons.inventory_2_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Color Family',
        icon: Icons.palette_outlined,
      ),
      const AdminSidebarItemData(title: 'Top Selling', icon: Icons.star_border),
      const AdminSidebarItemData(
        title: 'Packagings',
        icon: Icons.all_inbox_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Drivers',
        icon: Icons.local_shipping_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Cities',
        icon: Icons.location_city_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Suppliers',
        icon: Icons.store_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Orders',
        icon: Icons.shopping_cart_outlined,
      ),
      const AdminSidebarItemData(
        title: 'Discounts',
        icon: Icons.percent_outlined,
      ),
    ];

    return Container(
      width: width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Admin Panel',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = index == selectedIndex;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelect(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF3F4F6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: selected
                              ? Colors.black
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: selected
                                  ? Colors.black
                                  : const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
