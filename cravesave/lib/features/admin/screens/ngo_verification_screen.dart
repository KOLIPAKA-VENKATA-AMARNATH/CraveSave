import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NGOVerificationScreen extends StatefulWidget {
  const NGOVerificationScreen({super.key});

  @override
  State<NGOVerificationScreen> createState() => _NGOVerificationScreenState();
}

class _NGOVerificationScreenState extends State<NGOVerificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NGO Verification')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending NGO Verifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TODO: Add NGO verification list view
                    const Center(child: Text('No pending NGO verifications')),
                  ],
                ),
              ),
    );
  }
}
