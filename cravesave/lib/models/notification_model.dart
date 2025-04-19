import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class NotificationModel extends BaseModel {
  final String userId;
  final String message;
  final String type;
  final bool seen;

  NotificationModel({
    required String id,
    required DateTime createdAt,
    required this.userId,
    required this.message,
    required this.type,
    required this.seen,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'type': type,
      'seen': seen,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'reminder',
      seen: map['seen'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
