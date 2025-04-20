import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/donation_model.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/notification_service.dart';
import '../../../theme/auth_theme.dart';
import '../../../services/auth_service.dart';

class AcceptDonationScreen extends StatefulWidget {
  final String donationId;

  const AcceptDonationScreen({
    super.key,
    required this.donationId,
  });

  @override
  State<AcceptDonationScreen> createState() => _AcceptDonationScreenState();
}

class _AcceptDonationScreenState extends State<AcceptDonationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();
  final _notificationService = NotificationService();
  
  DonationModel? _donation;
  UserModel? _donor;
  bool _isLoading = true;
  bool _isAccepting = false;

  @override
  void initState() {
    super.initState();
    _loadDonation();
  }

  Future<void> _loadDonation() async {
    try {
      final doc = await _firestore.collection('donations').doc(widget.donationId).get();
      if (doc.exists) {
        _donation = DonationModel.fromMap(doc.data()!, doc.id);
        
        // Load donor info
        final donorDoc = await _firestore.collection('users').doc(_donation!.donorId).get();
        _donor = UserModel.fromMap(donorDoc.data()!, donorDoc.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading donation: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _acceptDonation() async {
    if (_donation == null || _donor == null) return;

    setState(() => _isAccepting = true);

    try {
      final volunteer = await _authService.getCurrentUser();
      if (volunteer == null) throw Exception('Volunteer not found');

      // Update donation status
      await _firestore.collection('donations').doc(widget.donationId).update({
        'status': 'accepted',
        'volunteerId': volunteer.id,
      });

      // Send notification to donor
      await _notificationService.sendDonationAcceptedNotification(
        donorId: _donor!.id,
        volunteerName: volunteer.name,
        foodTitle: _donation!.foodTitle,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation accepted successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accepting donation: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAccepting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accept Donation'),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _donation == null
                ? const Center(child: Text('Donation not found'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Food Image
                        if (_donation!.photoUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _donation!.photoUrl!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Food Details
                        _buildInfoRow('Food Title', _donation!.foodTitle),
                        _buildInfoRow('Quantity', _donation!.quantity),
                        _buildInfoRow('Description', _donation!.description),
                        _buildInfoRow(
                          'Pickup Deadline',
                          _donation!.pickupDeadline.toString().split(' ')[0],
                        ),
                        _buildInfoRow(
                          'Pickup Location',
                          '${_donation!.pickupLocation.latitude.toStringAsFixed(4)}, ${_donation!.pickupLocation.longitude.toStringAsFixed(4)}',
                        ),
                        const SizedBox(height: 24),

                        // Donor Info
                        const Text(
                          'Donor Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Name', _donor?.name ?? 'Unknown'),
                        _buildInfoRow('Phone', _donor?.phone ?? 'Not provided'),
                        const SizedBox(height: 24),

                        // Accept Button
                        ElevatedButton(
                          onPressed: _isAccepting ? null : _acceptDonation,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isAccepting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Accept Donation'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 