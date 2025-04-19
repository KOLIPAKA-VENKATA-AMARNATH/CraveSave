enum UserRole {
  donor,
  volunteer,
  ngo,
  admin;

  String get value {
    switch (this) {
      case UserRole.donor:
        return 'donor';
      case UserRole.volunteer:
        return 'volunteer';
      case UserRole.ngo:
        return 'ngo';
      case UserRole.admin:
        return 'admin';
    }
  }

  bool get requiresVerification {
    return this == UserRole.ngo || this == UserRole.admin;
  }

  bool get canCreateDonations {
    return this == UserRole.donor;
  }

  bool get canManageDeliveries {
    return this == UserRole.volunteer || this == UserRole.ngo;
  }

  bool get canApproveUsers {
    return this == UserRole.admin;
  }

  bool get canAssignTasks {
    return this == UserRole.ngo || this == UserRole.admin;
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'donor':
        return UserRole.donor;
      case 'volunteer':
        return UserRole.volunteer;
      case 'ngo':
        return UserRole.ngo;
      case 'admin':
        return UserRole.admin;
      default:
        throw ArgumentError('Invalid user role: $value. Allowed roles: donor, volunteer, ngo, admin');
    }
  }
}