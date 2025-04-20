import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/donor_dashboard_screen.dart';
import '../screens/ngo_dashboard_screen.dart';
import '../screens/volunteer_dashboard_screen.dart';
import '../screens/admin_dashboard_screen.dart';

class DashboardRoutes {
  static const String dashboard = '/dashboard';
  static const String donorDashboard = '/donor-dashboard';
  static const String ngoDashboard = '/ngo-dashboard';
  static const String volunteerDashboard = '/volunteer-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardScreen(),
      donorDashboard: (context) => const DonorDashboardScreen(),
      ngoDashboard: (context) => const NGODashboardScreen(),
      volunteerDashboard: (context) => const VolunteerDashboardScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
    };
  }
}
