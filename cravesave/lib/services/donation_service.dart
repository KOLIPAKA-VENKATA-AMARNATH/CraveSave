import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create new donation
  Future<String> createDonation(DonationModel donation) async {
    DocumentReference ref = await _firestore.collection('donations').add(donation.toMap());
    return ref.id;
  }

  // Get available donations
  Stream<QuerySnapshot> getAvailableDonations() {
    return _firestore
        .collection('donations')
        .where('status', isEqualTo: 'pending')
        .orderBy('pickupDeadline')
        .snapshots();
  }

  // Claim donation
  Future<void> claimDonation(String donationId, String volunteerId, String? ngoId) async {
    await _firestore.collection('donations').doc(donationId).update({
      'status': 'claimed',
      'volunteerId': volunteerId,
      'ngoId': ngoId,
      'claimedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update donation status
  Future<void> updateDonationStatus(String donationId, String status) async {
    await _firestore.collection('donations').doc(donationId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get donor's donations
  Stream<QuerySnapshot> getDonorDonations(String donorId) {
    return _firestore
        .collection('donations')
        .where('donorId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}