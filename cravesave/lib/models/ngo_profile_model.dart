import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class NgoProfileModel extends BaseModel {
  final String name;
  final String contact;
  final String address;
  final List<GeoPoint> servicesArea;
  final List<String> staffList;
  final bool approvedByAdmin;
  final String? logoUrl;

  NgoProfileModel({
    required String id,
    required DateTime createdAt,
    required this.name,
    required this.contact,
    required this.address,
    required this.servicesArea,
    required this.staffList,
    required this.approvedByAdmin,
    this.logoUrl,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'address': address,
      'servicesArea': servicesArea,
      'staffList': staffList,
      'approvedByAdmin': approvedByAdmin,
      'logoUrl': logoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory NgoProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return NgoProfileModel(
      id: id,
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
      servicesArea: List<GeoPoint>.from(map['servicesArea'] ?? []),
      staffList: List<String>.from(map['staffList'] ?? []),
      approvedByAdmin: map['approvedByAdmin'] ?? false,
      logoUrl: map['logoUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}