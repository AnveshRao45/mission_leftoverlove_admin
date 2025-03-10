import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/models/order_table_model.dart';
import 'package:mission_leftoverlove_admin/core/services/supabase_service.dart';
import 'package:mission_leftoverlove_admin/core/theme/theme.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/donate_screen.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/feed_screen.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/menu/menu_screen.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/profile_scren.dart';
import 'package:mission_leftoverlove_admin/features/orders/orders_controller.dart';
import 'package:mission_leftoverlove_admin/features/orders/orders_screen.dart';
import 'package:mission_leftoverlove_admin/features/payments/payments_screen.dart';
import 'package:mission_leftoverlove_admin/route/app_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomNavScreen extends ConsumerStatefulWidget {
  static const id = AppRoutes.bottomNavScreen;
  const BottomNavScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int currentIndex = 0;

  final screens = [
    const MenuScreen(),
    const PaymentScreen(),
    const DonateScreen(),
    const OrderScreen(),
    const ProfileScren()
  ];

  handleCallback(PostgresChangePayload payload) {
    final newRec = OrderTable.fromJson(payload.newRecord);

    ref
        .read(ordersControllerProvider.notifier)
        .addOrUpdateOrderRealtime(newRec);
  }

  initiateStream() {
    final supabase = ref.read(supabaseServiceProvider);
    final ownerDets = ref.read(globalOwnerModel);
    supabase
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          callback: handleCallback,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.inFilter,
            column: "restaurant_id",
            value: [ownerDets!.restaurantId], // Subscribe only when IDs exist
          ),
        )
        .subscribe();
  }

  @override
  void initState() {
    initiateStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.grey,
          selectedItemColor: primaryColor,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          currentIndex: currentIndex,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Feed"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/logo.png",
                  height: 6.h,
                ),
                label: "Donate"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.view_module), label: "orders"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile")
          ]),
      body: screens[currentIndex],
    );
  }
}
