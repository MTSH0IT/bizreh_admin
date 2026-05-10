import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';
import 'package:bizreh_admin/features/profile/controllers/profile_controller.dart';
import 'package:bizreh_admin/features/profile/views/widgets/change_password_dialog.dart';

import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const BuildProgressIndicator();
      }

      final profile = controller.profile.value;
      if (profile == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.errorMessage.value.isNotEmpty
                    ? controller.errorMessage.value
                    : 'لا توجد بيانات',
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.getProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      final fullName = [profile.firstName, profile.lastName]
          .where((e) => (e ?? '').trim().isNotEmpty)
          .map((e) => e!.trim())
          .join(' ');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE5E7EB),
                child: Icon(Icons.person, color: Color(0xFF374151)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? 'User' : fullName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    Get.dialog(ChangePasswordDialog(controller: controller)),
                icon: const Icon(Icons.lock_reset, color: Color(0xFF3B82F6)),
                tooltip: 'تغيير كلمة المرور',
              ),
              IconButton(
                onPressed: controller.getProfile,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => authController.logout(),
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 500,
            child: Card(
              elevation: 0,
              color: const Color(0xFFF9FAFB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(label: 'ID', value: profile.id?.toString() ?? '-'),
                    const Divider(height: 24),
                    _InfoRow(
                      label: 'First Name',
                      value: profile.firstName ?? '-',
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      label: 'Last Name',
                      value: profile.lastName ?? '-',
                    ),
                    const Divider(height: 24),
                    _InfoRow(label: 'Email', value: profile.email ?? '-'),
                    const Divider(height: 24),
                    _InfoRow(
                      label: 'Created At',
                      value: formatDate(profile.createdAt),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
