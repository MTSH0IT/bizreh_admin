import 'package:bizreh_admin/features/orders/models/order_model/item.dart';
import 'package:bizreh_admin/features/orders/models/order_model/order_model.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/func/status_color.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? const <Item>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(order: order),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final leftContent = Column(
              children: [
                _OrderSummaryCard(order: order),
                const SizedBox(height: 12),
                _CustomerCard(order: order),
                const SizedBox(height: 12),
                _AddressCard(order: order),
              ],
            );
            final rightContent = Column(
              children: [
                _PaymentCard(order: order),
                const SizedBox(height: 12),
                _DriverCard(order: order),
              ],
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: leftContent),
                  const SizedBox(width: 12),
                  Expanded(child: rightContent),
                ],
              );
            }

            return Column(
              children: [leftContent, const SizedBox(height: 12), rightContent],
            );
          },
        ),
        const SizedBox(height: 12),
        _ItemsCard(items: items),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final OrderModel order;

  const _Header({required this.order});

  @override
  Widget build(BuildContext context) {
    final title = (order.orderNumber ?? '').trim().isEmpty
        ? 'Order'
        : 'Order #${order.orderNumber}';

    final status = (order.status ?? '-').trim();
    final payment = (order.paymentStatus ?? '-').trim();

    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Created: ${formatDate(order.createdAt)}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Badge(
                label: status.isEmpty ? '-' : status,
                color: getOrderStatusColor(status),
              ),
              const SizedBox(height: 8),
              _Badge(
                label: payment.isEmpty ? '-' : payment,
                color: getPaymentStatusColor(payment),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final total = order.financialSummary?.total;
    final subtotal = order.financialSummary?.subTotal;
    final discount = order.financialSummary?.totalDiscount;

    return _SectionCard(
      title: 'Summary',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KeyValue(
                  label: 'Total',
                  value: total == null ? '-' : total.toStringAsFixed(2),
                ),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Items',
                  value: order.totalItemsCount?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _KeyValue(
                  label: 'Sub total',
                  value: subtotal == null ? '-' : subtotal.toStringAsFixed(2),
                ),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Discount',
                  value: discount == null ? '-' : discount.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final OrderModel order;

  const _CustomerCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Customer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _KeyValue(label: 'Name', value: order.userName ?? '-'),
              ),
              Expanded(
                child: _KeyValue(label: 'Phone', value: order.userPhone ?? '-'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _KeyValue(label: 'Email', value: order.userEmail ?? '-'),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final OrderModel order;

  const _AddressCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final city = (order.arCityName ?? order.cityName ?? '-').trim();

    return _SectionCard(
      title: 'Delivery address',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _KeyValue(label: 'City', value: city),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Address ID',
                  value: '${order.addressId ?? '-'}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _KeyValue(label: 'Line', value: order.addressLine ?? '-'),
          const SizedBox(height: 8),
          _KeyValue(label: 'Note', value: order.addressNote ?? '-'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _KeyValue(
                  label: 'Latitude',
                  value: order.latitude?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Longitude',
                  value: order.longitude?.toString() ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final OrderModel order;

  const _PaymentCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = (order.paymentStatus ?? '-').trim();

    return _SectionCard(
      title: 'Payment',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KeyValue(
                  label: 'Status',
                  value: status.isEmpty ? '-' : status,
                ),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Total',
                  value: order.financialSummary?.total == null
                      ? '-'
                      : order.financialSummary!.total!.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final OrderModel order;

  const _DriverCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Driver',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KeyValue(label: 'Name', value: order.driverName ?? '-'),
              ),
              Expanded(
                child: _KeyValue(
                  label: 'Phone',
                  value: order.driverPhone ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<Item> items;

  const _ItemsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Items',
      child: items.isEmpty
          ? const Text('No items', style: TextStyle(color: Color(0xFF6B7280)))
          : Column(
              children: [
                ...items.map(
                  (it) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ItemTile(item: it),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Item item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final title = (item.arTitle ?? item.title ?? '-').trim();
    final option = (item.arOptionName ?? item.optionName ?? '-').trim();
    final packaging = (item.packagingArTitle ?? item.packagingTitle ?? '-')
        .trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageNetwork(image: item.image ?? ''),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _InlineMeta(label: 'SKU', value: item.productSku ?? '-'),
                    _InlineMeta(label: 'Option', value: option),
                    _InlineMeta(label: 'Packaging', value: packaging),
                    _InlineMeta(
                      label: 'Qty/Unit',
                      value: item.quantityPerUnit?.toString() ?? '-',
                    ),
                    _InlineMeta(label: 'Brand', value: item.brandTitle ?? '-'),
                    _InlineMeta(
                      label: 'Category',
                      value: item.categoryTitle ?? '-',
                    ),
                    _InlineMeta(
                      label: 'Stock Qty',
                      value: item.stockQuantity?.toString() ?? '-',
                    ),
                    if (item.color != null)
                      _InlineMeta(
                        label: 'Color',
                        value: item.color!.name ?? '-',
                      ),
                    if (item.appliedDiscountName != null &&
                        item.appliedDiscountName!.isNotEmpty)
                      _InlineMeta(
                        label: 'Discount',
                        value: item.appliedDiscountName!,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.finalItemPrice == null
                    ? '-'
                    : item.finalItemPrice!.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                item.unitPrice == null
                    ? '-'
                    : 'Unit: ${item.unitPrice!.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineMeta extends StatelessWidget {
  final String label;
  final String value;

  const _InlineMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            value.isEmpty ? '-' : value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.trim().isEmpty ? '-' : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
