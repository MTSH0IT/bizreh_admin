import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/profile/views/profile_view.dart';
import 'package:get/get.dart';

class AdminTopBar extends StatelessWidget {
  final String hintText;

  const AdminTopBar({super.key, this.hintText = 'Search'});

  @override
  Widget build(BuildContext context) {
    final MainNavController nav = Get.find<MainNavController>();

    return Container(
      height: 72,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Obx(() {
            final titles = nav.stack.map((e) => e.title).toList();
            final breadcrumb = titles.join(' / ');

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (nav.canPop) ...[
                  IconButton(
                    onPressed: nav.pop,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 6),
                ],
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Text(
                    breadcrumb.isEmpty ? 'Admin Panel' : breadcrumb,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          }),
          const Spacer(),
          // SizedBox(
          //   width: 260,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: hintText,
          //       prefixIcon: const Icon(Icons.search),
          //       isDense: true,
          //       filled: true,
          //       fillColor: const Color(0xFFF3F4F6),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide.none,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 12),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.notifications_none_rounded),
          // ),
          // const SizedBox(width: 12),
          InkWell(
            onTap: () {
              nav.resetTo(
                const MainNavEntry(title: 'Profile', page: ProfileView()),
              );
            },
            borderRadius: BorderRadius.circular(999),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE5E7EB),
              child: Icon(Icons.person, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }
}
