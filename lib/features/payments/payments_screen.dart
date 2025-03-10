// screens/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
import 'package:mission_leftoverlove_admin/features/payments/payment_card.dart';
import 'package:mission_leftoverlove_admin/features/payments/payments_controller.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure the data fetch happens only once when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurantId = ref.read(globalOwnerModel)!.restaurantId;

      // Trigger fetching payments data after the widget is rendered
      ref
          .read(paymentControllerProvider.notifier)
          .fetchCompletedPayments(restaurantId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentControllerProvider);

    if (paymentState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (paymentState.error.isNotEmpty) {
      return Center(child: Text('Error: ${paymentState.error}'));
    }

    if (paymentState.payments.isEmpty) {
      return const Center(child: Text('No payments found.'));
    }

    return ListView.builder(
      itemCount: paymentState.payments.length,
      itemBuilder: (context, index) {
        final payment = paymentState.payments[index];
        return PaymentCard(payment: payment);
      },
    );
  }
}
