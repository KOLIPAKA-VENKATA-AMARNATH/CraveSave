import 'package:flutter/material.dart';
import '../screens/donation_form_screen.dart';
import '../screens/nearby_volunteers_screen.dart';
import '../screens/donation_history_screen.dart';

class DonorRoutes {
  static const String dashboard = '/donor/dashboard';
  static const String donationForm = '/donor/donation-form';
  static const String nearbyVolunteers = '/donor/nearby-volunteers';
  static const String donationHistory = '/donor/donation-history';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      donationForm: (context) => const DonationFormScreen(),
      nearbyVolunteers: (context) => const NearbyVolunteersScreen(),
      donationHistory: (context) => const DonationHistoryScreen(),
    };
  }
} 