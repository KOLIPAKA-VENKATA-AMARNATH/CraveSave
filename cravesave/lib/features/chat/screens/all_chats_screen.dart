import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/donation_model.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../theme/auth_theme.dart';
import 'chat_screen.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Chats'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('donations')
              .where('donorId', isEqualTo: _authService.currentUser?.uid)
              .where('volunteerId', isNotEqualTo: null)
              .orderBy('createdAt', descending: true)
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
                child: Text('No active chats'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donationData = donations[index].data();
                if (donationData == null) return const SizedBox.shrink();
                
                final donation = DonationModel.fromMap(
                  donationData as Map<String, dynamic>,
                  donations[index].id,
                );

                if (donation.volunteerId == null) return const SizedBox.shrink();

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(donation.volunteerId).get(),
                  builder: (context, volunteerSnapshot) {
                    if (!volunteerSnapshot.hasData || volunteerSnapshot.data?.data() == null) {
                      return const SizedBox.shrink();
                    }

                    final volunteerData = volunteerSnapshot.data!.data() as Map<String, dynamic>;
                    final volunteer = UserModel.fromMap(
                      volunteerData,
                      volunteerSnapshot.data!.id,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                donationId: donation.id,
                                volunteerId: donation.volunteerId!,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      donation.foodTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  _buildStatusChip(donation.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Volunteer: ${volunteer.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text('Phone: ${volunteer.phone}'),
                              const SizedBox(height: 8),
                              Text(
                                donation.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'accepted':
        chipColor = Colors.blue;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
    );
  }
} 