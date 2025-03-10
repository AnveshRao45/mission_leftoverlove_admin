// widgets/payment_card.dart

import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  PaymentCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment ID: ${payment.paymentId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Order ID: ${payment.orderId}'),
            Text('Payment Method: ${payment.paymentMethod}'),
            Text('Payment Date: ${payment.paymentDate.toLocal().toString()}'),
            Text('Amount Paid: \$${payment.amountPaid.toStringAsFixed(2)}'),
            if (payment.transactionId != null)
              Text('Transaction ID: ${payment.transactionId}'),
          ],
        ),
      ),
    );
  }
}
