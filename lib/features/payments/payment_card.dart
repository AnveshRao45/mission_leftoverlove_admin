import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.indigo.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.indigo.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon to indicate payment type
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  payment.paymentMethod.toLowerCase().contains('card')
                      ? Icons.credit_card
                      : Icons.account_balance_wallet,
                  color: Colors.indigo,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Payment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${payment.orderId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.paymentMethod,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.paymentDate
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                '\$${payment.amountPaid.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}