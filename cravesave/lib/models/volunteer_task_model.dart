import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class VolunteerTaskModel extends BaseModel {
  final String donationId;
  final String volunteerId;
  final String ngoId;
  final String status;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final List<GeoPoint>? routeMap;

  VolunteerTaskModel({
    required String id,
    required DateTime createdAt,
    required this.donationId,
    required this.volunteerId,
    required this.ngoId,
    required this.status,
    this.pickupTime,
    this.deliveryTime,
    this.routeMap,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'donationId': donationId,
      'volunteerId': volunteerId,
      'ngoId': ngoId,
      'status': status,
      'pickupTime': pickupTime != null ? Timestamp.fromDate(pickupTime!) : null,
      'deliveryTime': deliveryTime != null ? Timestamp.fromDate(deliveryTime!) : null,
      'routeMap': routeMap,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory VolunteerTaskModel.fromMap(Map<String, dynamic> map, String id) {
    return VolunteerTaskModel(
      id: id,
      donationId: map['donationId'] ?? '',
      volunteerId: map['volunteerId'] ?? '',
      ngoId: map['ngoId'] ?? '',
      status: map['status'] ?? 'assigned',
      pickupTime: map['pickupTime'] != null ? (map['pickupTime'] as Timestamp).toDate() : null,
      deliveryTime: map['deliveryTime'] != null ? (map['deliveryTime'] as Timestamp).toDate() : null,
      routeMap: map['routeMap'] != null ? List<GeoPoint>.from(map['routeMap']) : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}