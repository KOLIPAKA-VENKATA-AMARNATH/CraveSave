import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_enums.dart';
import '../../../features/dashboard/routes/dashboard_routes.dart';

class NgoSignupScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String phone;
  final GeoPoint location;

  const NgoSignupScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.location,
  });

  @override
  State<NgoSignupScreen> createState() => _NgoSignupScreenState();
}

class _NgoSignupScreenState extends State<NgoSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final _registrationNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serviceAreasController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _descriptionController.dispose();
    _serviceAreasController.dispose();
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
        role: UserRole.ngo,
        location: widget.location,
      );

      if (credential != null && credential.user != null) {
        // Create NGO profile with additional details
        await _firestore
            .collection('ngo_profiles')
            .doc(credential.user!.uid)
            .set({
              'registrationNumber': _registrationNumberController.text.trim(),
              'description': _descriptionController.text.trim(),
              'serviceAreas':
                  _serviceAreasController.text
                      .trim()
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
              'createdAt': FieldValue.serverTimestamp(),
              'status': 'pending',
            });

        if (mounted) {
          Navigator.pushReplacementNamed(context, DashboardRoutes.ngoDashboard);
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
      appBar: AppBar(title: const Text('NGO Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Additional NGO Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _registrationNumberController,
                decoration: const InputDecoration(
                  labelText: 'Registration Number',
                  border: OutlineInputBorder(),
                  helperText: 'Enter your NGO registration number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Organization Description',
                  border: OutlineInputBorder(),
                  helperText:
                      'Brief description of your NGO\'s mission and activities',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _serviceAreasController,
                decoration: const InputDecoration(
                  labelText: 'Service Areas',
                  border: OutlineInputBorder(),
                  helperText:
                      'Enter service areas separated by commas (e.g., Education, Healthcare, Environment)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one service area';
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
