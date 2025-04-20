import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/donation_model.dart';
import '../../../theme/auth_theme.dart';
import '../../../services/auth_service.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery History'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('donations')
              .where('volunteerId', isEqualTo: _authService.currentUser?.uid)
              .where('status', isEqualTo: 'completed')
              .orderBy('pickupDeadline', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final donations = snapshot.data?.docs ?? [];
            if (donations.isEmpty) {
              return const Center(
                child: Text('No delivery history'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = DonationModel.fromMap(
                  donations[index].data() as Map<String, dynamic>,
                  donations[index].id,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      donation.foodTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Quantity: ${donation.quantity}'),
                        Text('Completed on: ${donation.pickupDeadline.toString().split(' ')[0]}'),
                        const SizedBox(height: 8),
                        Text(
                          donation.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 