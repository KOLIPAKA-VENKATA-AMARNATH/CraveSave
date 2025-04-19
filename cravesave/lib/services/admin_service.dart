import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all unverified users
  Stream<QuerySnapshot> getUnverifiedUsers() {
    return _firestore
        .collection('users')
        .where('isVerified', isEqualTo: false)
        .snapshots();
  }

  // Verify a user
  Future<void> verifyUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isVerified': true,
      'active': true,
      'verifiedAt': FieldValue.serverTimestamp(),
    });
  }

  // Reject a user
  Future<void> rejectUser(String userId, String reason) async {
    await _firestore.collection('users').doc(userId).update({
      'isVerified': false,
      'active': false,
      'rejectionReason': reason,
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get verification requests count
  Stream<int> getPendingVerificationsCount() {
    return _firestore
        .collection('users')
        .where('isVerified', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}