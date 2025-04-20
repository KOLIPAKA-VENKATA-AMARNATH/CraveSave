import 'package:flutter/material.dart';
import '../screens/user_management_screen.dart';
import '../screens/ngo_verification_screen.dart';
import '../screens/system_settings_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/access_codes_screen.dart';

class AdminRoutes {
  static const String userManagement = '/admin/user-management';
  static const String ngoVerification = '/admin/ngo-verification';
  static const String systemSettings = '/admin/system-settings';
  static const String reports = '/admin/reports';
  static const String accessCodes = '/admin/access-codes';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      userManagement: (context) => const UserManagementScreen(),
      ngoVerification: (context) => const NGOVerificationScreen(),
      systemSettings: (context) => const SystemSettingsScreen(),
      reports: (context) => const ReportsScreen(),
      accessCodes: (context) => const AccessCodesScreen(),
    };
  }
}
