import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/order_food_item_card.dart';
import 'package:mission_leftoverlove_admin/features/orders/orders_controller.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  late String currentStatus;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    currentStatus =
        'booked'; // Default status since we don't have order object yet
  }

  Future<void> _showStatusUpdateConfirmation(String newStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Text(
            'Are you sure you want to change the status to ${_formatStatus(newStatus)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _updateOrderStatus(newStatus);
    }
  }

  void _updateOrderStatus(String newStatus) async {
    setState(() => isUpdating = true);

    try {
      // Update using Riverpod controller
      // await ref
      //     .read(ordersControllerProvider.notifier)
      //     .updateOrderStatus(widget.orderId, newStatus);

      setState(() {
        currentStatus = newStatus;
        isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Order status updated to ${_formatStatus(newStatus)}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => isUpdating = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order status: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'booked':
        return Colors.blue;
      case 'picked':
        return Colors.green;
      case 'noShowCancelled':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'booked':
        return 'Booked';
      case 'picked':
        return 'Picked Up';
      case 'noShowCancelled':
        return 'No Show (Cancelled)';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderFutureProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: orderAsync.when(
        data: (order) {
          final orderDate = order!.orderDetails?.orderDate != null
              ? DateFormat('MMM dd, yyyy - HH:mm')
                  .format(DateTime.parse(order.orderDetails!.orderDate!))
              : 'N/A';

          return Column(
            children: [
              _buildOrderInfoCard(orderDate, order),
              _buildStatusSection(),
              const Divider(height: 1),
              _buildItemsSection(order),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard(String orderDate, dynamic order) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order ID',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('#${order.orderDetails?.orderId ?? "N/A"}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Order Value',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('\$${order.orderValue?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Order Timing',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Order Date: $orderDate',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Pickup Time: ${order.restaurant?.pickupTime ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_off, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('End Time: ${order.restaurant?.endTime ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStatus).withOpacity(0.1),
                  border: Border.all(
                      color: _getStatusColor(currentStatus), width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle,
                        size: 12, color: _getStatusColor(currentStatus)),
                    const SizedBox(width: 4),
                    Text(_formatStatus(currentStatus),
                        style: TextStyle(
                            color: _getStatusColor(currentStatus),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              if (isUpdating)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) => _buildStatusUpdateSheet(),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update Order Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Select the new status for this order:',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          _buildStatusOption('booked', 'Booked', Icons.bookmark_border),
          _buildStatusOption('picked', 'Picked Up', Icons.check_circle_outline),
          _buildStatusOption('noShowCancelled', 'No Show (Cancelled)',
              Icons.person_off_outlined),
          _buildStatusOption('cancelled', 'Cancelled', Icons.cancel_outlined),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String value, String label, IconData icon) {
    final isSelected = currentStatus == value;

    return ListTile(
      leading:
          Icon(icon, color: isSelected ? _getStatusColor(value) : Colors.grey),
      title: Text(label,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? _getStatusColor(value) : null)),
      tileColor: isSelected ? _getStatusColor(value).withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: _getStatusColor(value), width: 1)
            : BorderSide.none,
      ),
      onTap: () {
        Navigator.pop(context);
        if (value != currentStatus) {
          _showStatusUpdateConfirmation(value);
        }
      },
    );
  }

  Widget _buildItemsSection(dynamic order) {
    final hasItems = order.menu != null && order.menu!.isNotEmpty;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Items (${order.menu?.length ?? 0})',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                if (hasItems)
                  Text(
                      'Total: \$${order.orderValue?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          if (!hasItems)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fastfood_outlined,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('No items in this order',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: order.menu!.length,
                itemBuilder: (context, index) {
                  final item = order.menu![index];
                  return OrderFoodItemCard(
                    foodItem: item,
                    quantity: item.orderedQuantity ?? 0,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
