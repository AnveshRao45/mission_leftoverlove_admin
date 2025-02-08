import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/owner_model.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final ownerRepoProvider = Provider((ref) {
  final supaClient = ref.read(supabaseServiceProvider);
  return OwnerRepo(supaClient);
});

class OwnerRepo {
  final SupabaseClient supabaseClient;
  OwnerModel? _cachedOwner; // Cached owner for global access

  OwnerRepo(this.supabaseClient);

  /// Adds a new owner to the database
  Future<String> addOwner(OwnerModel owner) async {
    try {
      await supabaseClient.from('owners').insert(owner.toMap());
      return "OWNER ADDED SUCCCESFULLY";
    } catch (e) {
      return e.toString();
    }
  }

  /// Fetches owner details from the database
  Future<OwnerModel?> getOwnerData(String? ownerId) async {
    if (ownerId == null) {
      print("[getOwnerData] ERROR: ownerId is null");
      return null;
    }
    try {
      final owner = await supabaseClient
          .from('owners')
          .select()
          .eq('owner_id', ownerId)
          .maybeSingle();

      print("[getOwnerData] Query result: $owner");

      final ownerModel = OwnerModel.fromMap(owner!);
      _cachedOwner = ownerModel; // Cache the owner
      return ownerModel;
    } catch (e) {
      print("$e");
      return null;
    }
  }

  /// Retrieves the currently signed-in owner's details
  Future<OwnerModel?> getCurrentOwner() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;

    if (_cachedOwner != null)
      return _cachedOwner; // Return cached owner if available

    return await getOwnerData(user.id);
  }

  /// Returns the current user's ID
  String? getOwnerId() {
    return supabaseClient.auth.currentUser?.id;
  }
}
