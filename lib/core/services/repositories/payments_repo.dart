// repositories/payment_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/payments_model.dart';
import 'package:supabase/supabase.dart';

import '../supabase_service.dart';

class PaymentRepo {
  final SupabaseClient supabaseClient;

  PaymentRepo({required this.supabaseClient});

  Future<List<Payment>> getCompletedPayments(int restaurantId) async {
    final response = await supabaseClient
        .rpc('get_completed_payments_for_restaurant', params: {
      'res_id': restaurantId,
    });
    if (response == null || response.isEmpty) {
      print("Received null or empty response: $response");
      return [];
    }
    print("Response JSON: $response");
    //TODO: fix the parsing of the list of payments.
    if (response is List) {
      try {
        return response.map((json) => Payment.fromJson(json)).toList();
      } catch (e) {
        print("$e");
        return [];
      }
    } else {
      print("Unexpected response format: $response");
      return [];
    }
  }
}

// PaymentRepo provider
final paymentRepoProvider = Provider((ref) {
  final supabaseClient = ref.read(supabaseServiceProvider);
  return PaymentRepo(supabaseClient: supabaseClient);
});
