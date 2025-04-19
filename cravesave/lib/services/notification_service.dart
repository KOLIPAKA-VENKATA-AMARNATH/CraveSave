import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create notification
  Future<void> createNotification(NotificationModel notification) async {
    await _firestore.collection('notifications').add(notification.toMap());
  }

  // Get user notifications
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mark notification as seen
  Future<void> markAsSeen(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'seen': true,
      'seenAt': FieldValue.serverTimestamp(),
    });
  }
}