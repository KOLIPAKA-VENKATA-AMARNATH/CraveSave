import 'package:flutter/material.dart';
import '../screens/available_pickups_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/delivery_history_screen.dart';
import '../screens/availability_screen.dart';

class VolunteerRoutes {
  static const String availablePickups = '/volunteer/available-pickups';
  static const String schedule = '/volunteer/schedule';
  static const String deliveryHistory = '/volunteer/delivery-history';
  static const String availability = '/volunteer/availability';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      availablePickups: (context) => const AvailablePickupsScreen(),
      schedule: (context) => const ScheduleScreen(),
      deliveryHistory: (context) => const DeliveryHistoryScreen(),
      availability: (context) => const AvailabilityScreen(),
    };
  }
}
