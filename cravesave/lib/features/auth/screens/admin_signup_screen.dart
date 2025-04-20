import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_enums.dart';
import '../../../features/dashboard/routes/dashboard_routes.dart';

class AdminSignupScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String phone;
  final GeoPoint location;

  const AdminSignupScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.location,
  });

  @override
  State<AdminSignupScreen> createState() => _AdminSignupScreenState();
}

class _AdminSignupScreenState extends State<AdminSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final _accessCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  Future<bool> _verifyAccessCode(String code) async {
    try {
      final doc = await _firestore.collection('admin_codes').doc(code).get();

      if (!doc.exists) return false;

      // Check if code is already used
      if (doc.data()?['used'] == true) return false;

      // Mark code as used
      await doc.reference.update({'used': true});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Verify access code
      final isValidCode = await _verifyAccessCode(
        _accessCodeController.text.trim(),
      );
      if (!isValidCode) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid or already used access code'),
            ),
          );
        }
        return;
      }

      // Register the user
      final credential = await AuthService().registerUser(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        phone: widget.phone,
        role: UserRole.admin,
        location: widget.location,
      );

      if (credential != null && credential.user != null) {
        // Create admin profile
        await _firestore
            .collection('admin_profiles')
            .doc(credential.user!.uid)
            .set({
              'createdAt': FieldValue.serverTimestamp(),
              'status': 'active',
            });

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            DashboardRoutes.adminDashboard,
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
      appBar: AppBar(title: const Text('Admin Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Admin Access Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _accessCodeController,
                decoration: const InputDecoration(
                  labelText: 'Access Code',
                  border: OutlineInputBorder(),
                  helperText: 'Enter the admin access code provided to you',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the access code';
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
