import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  final String name;
  final String email;
  final String phone;
  final String role;
  final GeoPoint location;
  final bool isVerified;
  final bool active;
  final String? profileImage;
  final DateTime lastActive;
  final String? deviceToken;

  UserModel({
    required String id,
    required DateTime createdAt,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.location,
    required this.isVerified,
    required this.active,
    this.profileImage,
    required this.lastActive,
    this.deviceToken,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'active': active,
      'profileImage': profileImage,
      'lastActive': Timestamp.fromDate(lastActive),
      'deviceToken': deviceToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      location: map['location'] as GeoPoint,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isVerified: map['isVerified'] ?? false,
      active: map['active'] ?? true,
      profileImage: map['profileImage'],
      lastActive: (map['lastActive'] as Timestamp).toDate(),
      deviceToken: map['deviceToken'],
    );
  }
}