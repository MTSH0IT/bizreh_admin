// import 'package:bizreh_admin/features/payment/controllers/user_payments_controller.dart';
// import 'package:bizreh_admin/features/payment/views/widgets/user_payments_table.dart';
// import 'package:bizreh_admin/features/payment/views/widgets/user_payments_summary_cards.dart';
// import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
// import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
// import 'package:bizreh_admin/utils/widgets/search_field.dart';
// import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UserPaymentsView extends StatefulWidget {
//   final int userId;
//   final String? userName;

//   const UserPaymentsView({super.key, required this.userId, this.userName});

//   @override
//   State<UserPaymentsView> createState() => _UserPaymentsViewState();
// }

// class _UserPaymentsViewState extends State<UserPaymentsView> {
//   late final String tag;
//   late final UserPaymentsController controller;

//   @override
//   void initState() {
//     super.initState();
//     tag = 'user_payments_${widget.userId}';
//     controller = Get.put(UserPaymentsController(), tag: tag);

//     // Initialize with user ID
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getPaymentsByUserId(widget.userId);
//     });
//   }

//   @override
//   void dispose() {
//     Get.delete<UserPaymentsController>(tag: tag);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SearchField(
//           hintText: 'Search payments...',
//           onChanged: controller.setUserPaymentSearchQuery,
//         ),
//         const SizedBox(height: 12),
//         ToolbarRow(
//           onRefresh: () => controller.getPaymentsByUserId(widget.userId),
//           addText: null,
//           refreshText: 'Refresh',
//         ),
//         const SizedBox(height: 16),
//         Obx(() {
//           if (controller.isLoadingUserPayments.value) {
//             return const BuildProgressIndicator();
//           }

//           final userPayment = controller.filteredUserPayment;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (userPayment != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     UserPaymentsSummaryCards(userPayment: userPayment),
//                     const SizedBox(height: 16),
//                     DetailsSectionCard(
//                       title: 'Payment History',
//                       child: UserPaymentsTable(payments: userPayment.payments!),
//                     ),
//                   ],
//                 )
//               else
//                 const Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.payments_outlined,
//                         color: Color(0xFF6B7280),
//                         size: 48,
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'No payment data found',
//                         style: TextStyle(color: Color(0xFF6B7280)),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           );
//         }),
//       ],
//     );
//   }
// }
