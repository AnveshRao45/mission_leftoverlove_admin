import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Widget horizontalDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Divider(
      color: Colors.white.withOpacity(0.2),
    ),
  );
}

appToast(String message) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
    content: Text(message),
  ));
}

sbh(double h) {
  return SizedBox(
    height: h,
  );
}

sbw(double w) {
  return SizedBox(
    width: w,
  );
}

debugLog(String tag, String message) {
  return log("$tag : $message");
}

String calculatePrice(int quantity, double price) {
  return (quantity * price).toStringAsFixed(2);
}

enum FuntionStates { sucess }

// Function to calculate CO₂ saved
double calculateCO2Saved(double weightOfFoodInKg) {
  const double co2EmissionFactor = 3.0; // CO₂ emitted per kg of food in kg
  return weightOfFoodInKg * co2EmissionFactor;
}

// Function to calculate trees saved from CO₂ saved
double calculateTreesSavedFromCO2(double co2Saved) {
  const double annualCO2AbsorptionPerTree =
      21.0; // CO₂ absorbed per tree annually in kg
  return co2Saved / annualCO2AbsorptionPerTree;
}

String calculateMinutesToReach(double distanceInMeters) {
  // Average speed in meters per second (approx. 18 km/h)
  double speedInMetersPerSecond = 5.0;

  // Calculate time in seconds
  double timeInSeconds = distanceInMeters / speedInMetersPerSecond;

  // Convert seconds to minutes
  double timeInMinutes = timeInSeconds / 60;

  return timeInMinutes.toStringAsFixed(1);
}

String calculateKmFromMeters(double meters) {
  return (meters / 1000).toStringAsFixed(2);
}

String formatTimeTo12Hour(String time) {
  try {
    // Parse the input string into a DateTime object
    final parsedTime = DateTime.parse("1970-01-01T$time");
    // Format the time into 12-hour format with AM/PM
    return DateFormat('hh:mm a').format(parsedTime);
  } catch (e) {
    return time; // Return the original string if parsing fails
  }
}
