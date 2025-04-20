import 'package:flutter/material.dart';
import '../../../theme/auth_theme.dart';
import 'donation_form_screen.dart';
import 'donation_history_screen.dart';
import 'nearby_volunteers_screen.dart';
import '../../chat/screens/all_chats_screen.dart';

class DonorDashboardScreen extends StatelessWidget {
  const DonorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Donor Dashboard'),
          centerTitle: true,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildDashboardItem(
              context,
              'Donate Food',
              Icons.food_bank,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonationFormScreen(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              context,
              'Nearby Volunteers',
              Icons.people,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NearbyVolunteersScreen(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              context,
              'Donation History',
              Icons.history,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonationHistoryScreen(),
                  ),
                );
              },
            ),
            _buildDashboardItem(
              context,
              'My Chats',
              Icons.chat,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllChatsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}