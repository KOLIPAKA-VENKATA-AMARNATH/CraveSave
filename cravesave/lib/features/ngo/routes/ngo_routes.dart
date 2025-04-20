import 'package:flutter/material.dart';
import '../screens/donations_screen.dart';
import '../screens/volunteers_screen.dart';
import '../screens/reports_screen.dart';

class NGORoutes {
  static const String donations = '/ngo/donations';
  static const String volunteers = '/ngo/volunteers';
  static const String reports = '/ngo/reports';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      donations: (context) => const DonationsScreen(),
      volunteers: (context) => const VolunteersScreen(),
      reports: (context) => const ReportsScreen(),
    };
  }
}
