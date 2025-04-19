import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getNearbyDonations(
    GeoPoint center,
    double radiusKm,
  ) async {
    QuerySnapshot donations = await _firestore.collection('donations').get();

    return donations.docs.where((doc) {
      GeoPoint location = doc['location'];
      return _isWithinRadius(
        center.latitude,
        center.longitude,
        location.latitude,
        location.longitude,
        radiusKm,
      );
    }).toList();
  }

  Future<void> updateDeliveryLocation(String taskId, GeoPoint location) async {
    await _firestore.collection('delivery_logs').add({
      'taskId': taskId,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<QueryDocumentSnapshot>> streamNearbyVolunteers(
    GeoPoint center,
    double radiusKm,
  ) {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'volunteer')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.where((doc) {
            GeoPoint location = doc['location'];
            return _isWithinRadius(
              center.latitude,
              center.longitude,
              location.latitude,
              location.longitude,
              radiusKm,
            );
          }).toList();
        });
  }

  bool _isWithinRadius(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
    double radiusKm,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance <= radiusKm;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }
}
