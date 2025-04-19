import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDonationStats() async {
    QuerySnapshot donations = await _firestore.collection('donations').get();
    
    return {
      'total': donations.size,
      'pending': donations.docs.where((d) => d['status'] == 'pending').length,
      'completed': donations.docs.where((d) => d['status'] == 'delivered').length,
      'expired': donations.docs.where((d) => d['status'] == 'expired').length,
    };
  }

  Future<Map<String, dynamic>> getVolunteerStats(String volunteerId) async {
    QuerySnapshot tasks = await _firestore
        .collection('volunteer_tasks')
        .where('volunteerId', isEqualTo: volunteerId)
        .get();

    return {
      'total_deliveries': tasks.size,
      'completed': tasks.docs.where((t) => t['status'] == 'delivered').length,
      'average_rating': await _calculateAverageRating(volunteerId),
    };
  }

  Future<Map<String, dynamic>> getNgoStats(String ngoId) async {
    QuerySnapshot donations = await _firestore
        .collection('donations')
        .where('ngoId', isEqualTo: ngoId)
        .get();

    return {
      'total_managed': donations.size,
      'active_volunteers': await _getActiveVolunteersCount(ngoId),
      'service_areas': await _getServiceAreasCount(ngoId),
    };
  }

  Future<double> _calculateAverageRating(String userId) async {
    QuerySnapshot feedback = await _firestore
        .collection('feedback')
        .where('toUserId', isEqualTo: userId)
        .get();

    if (feedback.docs.isEmpty) return 0.0;

    double total = feedback.docs.fold(0.0, (sum, doc) => sum + (doc['rating'] ?? 0.0));
    return total / feedback.docs.length;
  }

  Future<int> _getActiveVolunteersCount(String ngoId) async {
    QuerySnapshot volunteers = await _firestore
        .collection('volunteer_tasks')
        .where('ngoId', isEqualTo: ngoId)
        .get();

    return volunteers.docs.map((doc) => doc['volunteerId']).toSet().length;
  }

  Future<int> _getServiceAreasCount(String ngoId) async {
    DocumentSnapshot ngoProfile = await _firestore
        .collection('ngo_profiles')
        .doc(ngoId)
        .get();

    List<dynamic> areas = ngoProfile['serviceAreas'] ?? [];
    return areas.length;
  }
}