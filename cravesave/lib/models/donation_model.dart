import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class DonationModel extends BaseModel {
  final String donorId;
  final String foodTitle;
  final String description;
  final String? photoUrl;
  final GeoPoint pickupLocation;
  final String pickupAddress;
  final String quantity;
  final String status;
  final DateTime pickupDeadline;
  final String? volunteerId;
  final String? ngoId;

  DonationModel({
    required String id,
    required DateTime createdAt,
    required this.donorId,
    required this.foodTitle,
    required this.description,
    this.photoUrl,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.quantity,
    required this.status,
    required this.pickupDeadline,
    this.volunteerId,
    this.ngoId,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'donorId': donorId,
      'foodTitle': foodTitle,
      'description': description,
      'photoUrl': photoUrl,
      'pickupLocation': pickupLocation,
      'pickupAddress': pickupAddress,
      'quantity': quantity,
      'status': status,
      'pickupDeadline': Timestamp.fromDate(pickupDeadline),
      'volunteerId': volunteerId,
      'ngoId': ngoId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map, String id) {
    return DonationModel(
      id: id,
      donorId: map['donorId'] ?? '',
      foodTitle: map['foodTitle'] ?? '',
      description: map['description'] ?? '',
      photoUrl: map['photoUrl'],
      pickupLocation: map['pickupLocation'] as GeoPoint,
      pickupAddress: map['pickupAddress'] ?? '',
      quantity: map['quantity'] ?? '',
      status: map['status'] ?? 'pending',
      pickupDeadline: (map['pickupDeadline'] as Timestamp).toDate(),
      volunteerId: map['volunteerId'],
      ngoId: map['ngoId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
