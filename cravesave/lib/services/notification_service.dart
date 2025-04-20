import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

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

  Future<void> requestNotificationPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> sendDonationRequestNotification({
    required String volunteerId,
    required String donorName,
    required String foodTitle,
  }) async {
    try {
      // Get volunteer's device token
      final volunteerDoc = await _firestore
          .collection('users')
          .doc(volunteerId)
          .get();
      
      final deviceToken = volunteerDoc.data()?['deviceToken'];
      if (deviceToken == null) return;

      // Create notification in Firestore
      await _firestore.collection('notifications').add({
        'userId': volunteerId,
        'title': 'New Donation Request',
        'body': '$donorName has requested you to collect $foodTitle',
        'type': 'donation_request',
        'seen': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send push notification
      await _messaging.sendMessage(
        to: deviceToken,
        data: {
          'type': 'donation_request',
          'title': 'New Donation Request',
          'body': '$donorName has requested you to collect $foodTitle',
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
      rethrow;
    }
  }

  Future<void> sendDonationAcceptedNotification({
    required String donorId,
    required String volunteerName,
    required String foodTitle,
  }) async {
    try {
      // Get donor's device token
      final donorDoc = await _firestore
          .collection('users')
          .doc(donorId)
          .get();
      
      final deviceToken = donorDoc.data()?['deviceToken'];
      if (deviceToken == null) return;

      // Create notification in Firestore
      await _firestore.collection('notifications').add({
        'userId': donorId,
        'title': 'Donation Accepted',
        'body': '$volunteerName has accepted to collect $foodTitle',
        'type': 'donation_accepted',
        'seen': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send push notification
      await _messaging.sendMessage(
        to: deviceToken,
        data: {
          'type': 'donation_accepted',
          'title': 'Donation Accepted',
          'body': '$volunteerName has accepted to collect $foodTitle',
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
      rethrow;
    }
  }

  Future<void> updateDeviceToken(String userId, String? token) async {
    await _firestore.collection('users').doc(userId).update({
      'deviceToken': token,
    });
  }
}