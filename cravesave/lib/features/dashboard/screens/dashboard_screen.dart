import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user data: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${_currentUser?.name ?? 'User'}'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleSignOut),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Role', _currentUser?.role ?? 'N/A'),
                    _buildInfoRow('Email', _currentUser?.email ?? 'N/A'),
                    _buildInfoRow('Phone', _currentUser?.phone ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            // Role-specific actions will be added here
            _buildRoleSpecificActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificActions() {
    switch (_currentUser?.role) {
      case 'donor':
        return _buildDonorActions();
      case 'ngo':
        return _buildNgoActions();
      case 'volunteer':
        return _buildVolunteerActions();
      case 'admin':
        return _buildAdminActions();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDonorActions() {
    return Column(
      children: [
        _buildActionButton('Donate Food', Icons.food_bank, () {
          // TODO: Navigate to food donation screen
        }),
        const SizedBox(height: 12),
        _buildActionButton('My Donations', Icons.history, () {
          // TODO: Navigate to donation history
        }),
      ],
    );
  }

  Widget _buildNgoActions() {
    return Column(
      children: [
        _buildActionButton('View Donations', Icons.list_alt, () {
          // TODO: Navigate to available donations
        }),
        const SizedBox(height: 12),
        _buildActionButton('My Inventory', Icons.inventory, () {
          // TODO: Navigate to inventory
        }),
      ],
    );
  }

  Widget _buildVolunteerActions() {
    return Column(
      children: [
        _buildActionButton('Available Pickups', Icons.delivery_dining, () {
          // TODO: Navigate to available pickups
        }),
        const SizedBox(height: 12),
        _buildActionButton('My Schedule', Icons.calendar_today, () {
          // TODO: Navigate to schedule
        }),
      ],
    );
  }

  Widget _buildAdminActions() {
    return Column(
      children: [
        _buildActionButton('Manage Users', Icons.people, () {
          // TODO: Navigate to user management
        }),
        const SizedBox(height: 12),
        _buildActionButton('NGO Verifications', Icons.verified_user, () {
          // TODO: Navigate to NGO verifications
        }),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
