import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/payments_repo.dart';
import 'package:mission_leftoverlove_admin/features/payments/payment_card.dart';
import 'package:mission_leftoverlove_admin/features/payments/payments_controller.dart';

class PaymentScreen extends StatefulWidget {
  final int restaurantId;

  const PaymentScreen({super.key, required this.restaurantId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentController _controller = PaymentController(PaymentRepository());
  String _filter = 'today';
  PaymentSummary? _paymentSummary;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    final summary =
        await _controller.fetchPayments(widget.restaurantId, _filter);
    setState(() {
      _paymentSummary = summary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['today', 'week', 'month', 'year', 'total'].map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _filter = f;
                            _loadPayments();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _filter == f
                              ? Colors.indigo
                              : Colors.white.withOpacity(0.9),
                          foregroundColor:
                              _filter == f ? Colors.white : Colors.indigo,
                          elevation: _filter == f ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          f[0].toUpperCase() + f.substring(1),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              if (_paymentSummary != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard(
                        'Total Payments', _paymentSummary!.totalPayments),
                    _buildSummaryCard(
                        'Total Amount', _paymentSummary!.totalAmount),
                  ],
                ),
              const SizedBox(height: 24),

              // Payment List
              Expanded(
                child: _paymentSummary == null
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigo,
                        ),
                      )
                    : _paymentSummary!.payments.isEmpty
                        ? const Center(
                            child: Text(
                              'No payments found for this period.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _paymentSummary!.payments.length,
                            itemBuilder: (context, index) {
                              final payment = _paymentSummary!.payments[index];
                              return PaymentCard(payment: payment);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, num value) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title == 'Total Payments'
                    ? value.toString()
                    : '\$${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
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
