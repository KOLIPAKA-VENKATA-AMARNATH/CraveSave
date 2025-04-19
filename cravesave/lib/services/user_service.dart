import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get NGO Additional Info
  Future<Map<String, dynamic>?> getNgoProfile(String ngoId) async {
    DocumentSnapshot doc = await _firestore
        .collection('ngo_profiles')
        .doc(ngoId)
        .get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Update NGO Profile
  Future<void> updateNgoProfile(String ngoId, Map<String, dynamic> data) async {
    await _firestore.collection('ngo_profiles').doc(ngoId).update(data);
  }

  // Get Volunteer Profile
  Future<Map<String, dynamic>?> getVolunteerProfile(String volunteerId) async {
    DocumentSnapshot doc = await _firestore
        .collection('volunteer_profiles')
        .doc(volunteerId)
        .get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Update Service Area
  Future<void> updateServiceArea(String userId, List<GeoPoint> serviceArea) async {
    await _firestore.collection('users').doc(userId).update({
      'serviceArea': serviceArea,
    });
  }

  // Get Users by Role
  Stream<QuerySnapshot> getUsersByRole(UserRole role) {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: role.value)
        .where('active', isEqualTo: true)
        .snapshots();
  }

  // Update Device Token
  Future<void> updateDeviceToken(String userId, String? token) async {
    await _firestore.collection('users').doc(userId).update({
      'deviceToken': token,
    });
  }

  // Update Last Active
  Future<void> updateLastActive(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}