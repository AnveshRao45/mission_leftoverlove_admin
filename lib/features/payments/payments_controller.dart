// controllers/payment_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';
import 'package:mission_leftoverlove_admin/core/services/repositories/payments_repo.dart';

class PaymentState {
  final bool isLoading;
  final List<Payment> payments;
  final String error;

  PaymentState({
    required this.isLoading,
    required this.payments,
    required this.error,
  });

  factory PaymentState.initial() {
    return PaymentState(
      isLoading: false,
      payments: [],
      error: '',
    );
  }

  PaymentState copyWith({
    bool? isLoading,
    List<Payment>? payments,
    String? error,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      payments: payments ?? this.payments,
      error: error ?? this.error,
    );
  }
}

class PaymentController extends StateNotifier<PaymentState> {
  final PaymentRepo paymentRepository;

  PaymentController({required this.paymentRepository})
      : super(PaymentState.initial());

  void fetchCompletedPayments(int restaurantId) async {
    print("Fetching payments for restaurant with ID: $restaurantId");
    state = state.copyWith(isLoading: true);
    try {
      final result = await paymentRepository.getCompletedPayments(restaurantId);
      if (result.isNotEmpty) {
        state = state.copyWith(isLoading: false, payments: result);
      } else {
        state = state.copyWith(
            isLoading: false, payments: [], error: 'No payments found');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final paymentControllerProvider =
    StateNotifierProvider<PaymentController, PaymentState>((ref) {
  final paymentRepository = ref.read(paymentRepoProvider);
  return PaymentController(paymentRepository: paymentRepository);
});
