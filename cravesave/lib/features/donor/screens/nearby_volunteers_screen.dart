import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/user_model.dart';
import '../../../theme/auth_theme.dart';
import '../../donor/routes/donor_routes.dart';
import '../../donor/screens/donation_form_screen.dart';

class NearbyVolunteersScreen extends StatefulWidget {
  final String? donationId;

  const NearbyVolunteersScreen({
    super.key,
    this.donationId,
  });

  @override
  State<NearbyVolunteersScreen> createState() => _NearbyVolunteersScreenState();
}

class _NearbyVolunteersScreenState extends State<NearbyVolunteersScreen> {
  final _firestore = FirebaseFirestore.instance;
  List<UserModel> _nearbyVolunteers = [];
  bool _isLoading = true;
  late GeoPoint _pickupLocation;
  Map<String, dynamic>? _donationData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _pickupLocation = args['pickupLocation'] as GeoPoint;
    _donationData = args['donationData'];
    _loadNearbyVolunteers();
  }

  Future<void> _loadNearbyVolunteers() async {
    try {
      // Get all volunteers
      final volunteersSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'volunteer')
          .where('active', isEqualTo: true)
          .get();

      final volunteers = volunteersSnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      // Calculate distances and filter nearby volunteers (within 10km)
      final nearbyVolunteers = volunteers.where((volunteer) {
        final distance = Geolocator.distanceBetween(
          _pickupLocation.latitude,
          _pickupLocation.longitude,
          volunteer.location.latitude,
          volunteer.location.longitude,
        );
        return distance <= 10000; // 10km in meters
      }).toList();

      // Sort by distance
      nearbyVolunteers.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          _pickupLocation.latitude,
          _pickupLocation.longitude,
          a.location.latitude,
          a.location.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          _pickupLocation.latitude,
          _pickupLocation.longitude,
          b.location.latitude,
          b.location.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        _nearbyVolunteers = nearbyVolunteers;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading volunteers: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _selectVolunteer(String volunteerId) async {
    if (widget.donationId != null) {
      // Update existing donation
      await _firestore.collection('donations').doc(widget.donationId).update({
        'volunteerId': volunteerId,
        'status': 'pending',
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      // Navigate to donation form with selected volunteer
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationFormScreen(
              volunteerId: volunteerId,
              pickupLocation: _pickupLocation,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Volunteers'),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _nearbyVolunteers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No nearby volunteers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _nearbyVolunteers.length,
                    itemBuilder: (context, index) {
                      final volunteer = _nearbyVolunteers[index];
                      final distance = Geolocator.distanceBetween(
                        _pickupLocation.latitude,
                        _pickupLocation.longitude,
                        volunteer.location.latitude,
                        volunteer.location.longitude,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(volunteer.name[0]),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          volunteer.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(distance / 1000).toStringAsFixed(1)} km away',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _selectVolunteer(volunteer.id),
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Phone', volunteer.phone),
                              _buildInfoRow('Email', volunteer.email),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
} 