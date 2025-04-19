import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class DeliveryLogModel extends BaseModel {
  final String taskId;
  final List<GeoPoint> locationUpdates;
  final Map<String, dynamic> deviceInfo;
  final double? batteryLevel;

  DeliveryLogModel({
    required String id,
    required DateTime createdAt,
    required this.taskId,
    required this.locationUpdates,
    required this.deviceInfo,
    this.batteryLevel,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'locationUpdates': locationUpdates,
      'deviceInfo': deviceInfo,
      'batteryLevel': batteryLevel,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DeliveryLogModel.fromMap(Map<String, dynamic> map, String id) {
    return DeliveryLogModel(
      id: id,
      taskId: map['taskId'] ?? '',
      locationUpdates: List<GeoPoint>.from(map['locationUpdates'] ?? []),
      deviceInfo: Map<String, dynamic>.from(map['deviceInfo'] ?? {}),
      batteryLevel: map['batteryLevel']?.toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
