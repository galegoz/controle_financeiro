import 'package:flutter/material.dart';
import '../reports/reports_page.dart';
import '../indicators/indicators_page.dart';

class ReportsTabPage extends StatelessWidget {
  const ReportsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Relatórios & Indicadores'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.description_outlined), text: 'Relatórios'),
              Tab(icon: Icon(Icons.insights_outlined), text: 'Indicadores'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportsContent(),
            IndicatorsPage(),
          ],
        ),
      ),
    );
  }
}
