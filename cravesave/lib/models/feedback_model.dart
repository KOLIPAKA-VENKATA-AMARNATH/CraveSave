import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class FeedbackModel extends BaseModel {
  final String donationId;
  final String fromUserId;
  final String toUserId;
  final double rating;
  final String? comment;

  FeedbackModel({
    required String id,
    required DateTime createdAt,
    required this.donationId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    this.comment,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'donationId': donationId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String id) {
    return FeedbackModel(
      id: id,
      donationId: map['donationId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
