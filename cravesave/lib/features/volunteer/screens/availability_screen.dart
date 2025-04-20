import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/auth_theme.dart';
import '../../../services/auth_service.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    final doc = await _firestore
        .collection('volunteers')
        .doc(_authService.currentUser?.uid)
        .get();
    
    if (doc.exists) {
      setState(() {
        _isAvailable = doc.data()?['isAvailable'] ?? false;
      });
    }
  }

  Future<void> _updateAvailability(bool value) async {
    setState(() {
      _isAvailable = value;
    });

    await _firestore
        .collection('volunteers')
        .doc(_authService.currentUser?.uid)
        .update({
      'isAvailable': value,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Availability'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set your availability status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'When you are available, you will be shown to donors looking for volunteers to collect their donations.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              SwitchListTile(
                title: const Text(
                  'I am available for pickups',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _isAvailable
                      ? 'You are currently available for pickups'
                      : 'You are currently not available for pickups',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                value: _isAvailable,
                onChanged: _updateAvailability,
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 