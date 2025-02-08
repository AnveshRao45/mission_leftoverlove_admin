import 'package:flutter/material.dart';

class Navigation {
  late GlobalKey<NavigatorState> navigationKey;

  static Navigation instance = Navigation();

  Navigation() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String rn, {Object? args}) {
    return navigationKey.currentState!
        .pushReplacementNamed(rn, arguments: args);
  }

  Future<dynamic> pushAndRemoveUntil(String rn, {Object? args}) {
    return navigationKey.currentState!
        .pushNamedAndRemoveUntil(rn, (route) => false, arguments: args);
  }

  Future<dynamic> navigateTo(String rn, {Object? args}) {
    return navigationKey.currentState!.pushNamed(rn, arguments: args);
  }

  Future<dynamic> pushNamed(MaterialPageRoute rn) {
    return navigationKey.currentState!.push(rn);
  }

  pushBack() {
    return navigationKey.currentState!.pop();
  }
}
