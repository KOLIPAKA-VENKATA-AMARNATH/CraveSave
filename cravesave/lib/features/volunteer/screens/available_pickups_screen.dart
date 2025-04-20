import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AvailablePickupsScreen extends StatefulWidget {
  const AvailablePickupsScreen({super.key});

  @override
  State<AvailablePickupsScreen> createState() => _AvailablePickupsScreenState();
}

class _AvailablePickupsScreenState extends State<AvailablePickupsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Pickups')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Pickup Requests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TODO: Add pickup requests list view
                    const Center(
                      child: Text('No pickup requests available yet'),
                    ),
                  ],
                ),
              ),
    );
  }
}
