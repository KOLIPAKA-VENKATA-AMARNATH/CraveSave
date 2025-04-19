import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create feedback
  Future<void> createFeedback(FeedbackModel feedback) async {
    await _firestore.collection('feedback').add(feedback.toMap());
  }

  // Get user's received feedback
  Stream<QuerySnapshot> getUserFeedback(String userId) {
    return _firestore
        .collection('feedback')
        .where('toUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get donation feedback
  Stream<QuerySnapshot> getDonationFeedback(String donationId) {
    return _firestore
        .collection('feedback')
        .where('donationId', isEqualTo: donationId)
        .snapshots();
  }
}