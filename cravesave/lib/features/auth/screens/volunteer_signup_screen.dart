import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_enums.dart';
import '../../../features/dashboard/routes/dashboard_routes.dart';

class VolunteerSignupScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String phone;
  final GeoPoint location;

  const VolunteerSignupScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.location,
  });

  @override
  State<VolunteerSignupScreen> createState() => _VolunteerSignupScreenState();
}

class _VolunteerSignupScreenState extends State<VolunteerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  double _serviceRadius = 5.0; // Default 5km radius
  final _availabilityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _availabilityController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Register the user
      final credential = await AuthService().registerUser(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        phone: widget.phone,
        role: UserRole.volunteer,
        location: widget.location,
      );

      if (credential != null && credential.user != null) {
        // Create volunteer profile with additional details
        await _firestore
            .collection('volunteer_profiles')
            .doc(credential.user!.uid)
            .set({
              'serviceRadius': _serviceRadius,
              'availability': _availabilityController.text.trim(),
              'createdAt': FieldValue.serverTimestamp(),
              'status': 'active',
            });

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            DashboardRoutes.volunteerDashboard,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Additional Volunteer Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Service Area Radius (km)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _serviceRadius,
                min: 1,
                max: 50,
                divisions: 49,
                label: '${_serviceRadius.round()} km',
                onChanged: (value) {
                  setState(() => _serviceRadius = value);
                },
              ),
              Text(
                '${_serviceRadius.round()} km',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _availabilityController,
                decoration: const InputDecoration(
                  labelText: 'Availability',
                  border: OutlineInputBorder(),
                  helperText:
                      'Enter your availability (e.g., Weekdays 9-5, Weekends)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your availability';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Complete Registration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
