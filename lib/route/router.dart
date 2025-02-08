import 'package:flutter/material.dart';
import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
import 'package:mission_leftoverlove_admin/features/auth/auth_screen.dart';
import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_screen.dart';
import 'package:mission_leftoverlove_admin/features/splash/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static Route generateRoute(RouteSettings route) {
    const PageTransitionType style = PageTransitionType.fade;

    PageTransition pageTransition(Widget child) {
      return PageTransition(child: child, type: style);
    }

    if (route.name == AuthScreen.id.path) {
      return pageTransition(const AuthScreen());
    } else if (route.name == SplashScreen.id.path) {
      return pageTransition(const SplashScreen());
    } else if (route.name == BottomNavScreen.id.path) {
      return pageTransition(const BottomNavScreen());
    
    // } else if (route.name == LocationScreen.id.path) {
    //   return pageTransition(const LocationScreen());
    // } else if (route.name == RestaurentDetailScreen.id.path) {
    //   final int restaurentId = route.arguments as int;
    //   return pageTransition(RestaurentDetailScreen(
    //     restaurentId: restaurentId,
    //   ));
    } else {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('No view defined for this route'),
          ),
        ),
      );
    }
  }
}
