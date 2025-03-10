class Payment {
  int paymentId; // Unique ID for the payment
  int orderId; // Foreign key from orders table
  String paymentMethod; // Payment method (e.g., 'Bank Transfer', 'Cheque')
  DateTime paymentDate; // Date of the payment
  double amountPaid; // Amount paid to the restaurant
  String? transactionId; // Transaction ID for the payment (optional)

  // Constructor
  Payment({
    required this.paymentId,
    required this.orderId,
    required this.paymentMethod,
    required this.paymentDate,
    required this.amountPaid,
    this.transactionId,
  });

  // Factory method to create a Payment from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      paymentMethod: json['payment_method'],
      paymentDate: DateTime.parse(json['payment_date']),
      amountPaid: json['amount_paid'].toDouble(),
      transactionId: json['transaction_id'],
    );
  }

  // Method to convert a Payment to JSON
  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'order_id': orderId,
      'payment_method': paymentMethod,
      'payment_date': paymentDate.toIso8601String(),
      'amount_paid': amountPaid,
      'transaction_id': transactionId,
    };
  }
}

class PaymentSummary {
  final int totalPayments;
  final double totalAmount;
  final List<Payment> payments;

  PaymentSummary({
    required this.totalPayments,
    required this.totalAmount,
    required this.payments,
  });
}
