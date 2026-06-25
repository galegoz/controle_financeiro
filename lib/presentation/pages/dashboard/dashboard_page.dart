import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text('Dashboard em construção...'),
          ],
        ),
      ),
    );
  }
}
