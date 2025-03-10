// repositories/payment_repository.dart

import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class PaymentRepo {
//   final SupabaseClient supabaseClient;

//   PaymentRepo({required this.supabaseClient});

//   Future<List<Payment>> getCompletedPayments(int restaurantId) async {
//     final response = await supabaseClient
//         .rpc('get_completed_payments_for_restaurant', params: {
//       'res_id': restaurantId,
//     });
//     if (response == null || response.isEmpty) {
//       print("Received null or empty response: $response");
//       return [];
//     }
//     print("Response JSON: $response");
//     //TODO: fix the parsing of the list of payments.
//     if (response is List) {
//       try {
//         return response.map((json) => Payment.fromJson(json)).toList();
//       } catch (e) {
//         print("$e");
//         return [];
//       }
//     } else {
//       print("Unexpected response format: $response");
//       return [];
//     }
//   }
// }

// // PaymentRepo provider
// final paymentRepoProvider = Provider((ref) {
//   final supabaseClient = ref.read(supabaseServiceProvider);
//   return PaymentRepo(supabaseClient: supabaseClient);
// });

class PaymentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<PaymentSummary> getPayments(int restaurantId, String filter) async {
    final response = await _supabase.rpc('get_payments', params: {
      'res_id': restaurantId,
      'filter': filter,
    });
    print("RESPONSE  -- getPayments: $response");

    final data = response as List<dynamic>;
    final payments = data.map((json) => Payment.fromJson(json)).toList();
    final totalPayments =
        data.isNotEmpty ? data[0]['total_payments'] as int : 0;
    final totalAmount =
        data.isNotEmpty ? (data[0]['total_amount'] as num).toDouble() : 0.0;

    return PaymentSummary(
      totalPayments: totalPayments,
      totalAmount: totalAmount,
      payments: payments,
    );
  }

  Future<Map<String, double>> getPaymentSummary(int restaurantId) async {
    final response = await _supabase.rpc('get_payment_summary', params: {
      'res_id': restaurantId,
    });

    if (response.error != null) throw Exception(response.error!.message);

    final data = response.data[0] as Map<String, dynamic>;
    return {
      'today': (data['today_total'] as num).toDouble(),
      'week': (data['week_total'] as num).toDouble(),
      'month': (data['month_total'] as num).toDouble(),
      'year': (data['year_total'] as num).toDouble(),
      'all_time': (data['all_time_total'] as num).toDouble(),
    };
  }
}
