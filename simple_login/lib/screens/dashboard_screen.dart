import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  final String bearerToken;

  DashboardScreen({required this.bearerToken});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> dashboardData = {}; // To store the received data

  Future<void> _fetchDashboardData() async {
    try {
      final jsonResponse = await fetchDashboardData(widget.bearerToken);
      setState(() {
        dashboardData = jsonResponse;
      });
    } catch(e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e as String)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dashboard Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (dashboardData.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Government: ${dashboardData['government']}'),
                    Text('NGO: ${dashboardData['ngo']}'),
                    // Add more data fields here
                  ],
                ),
              if (dashboardData.isEmpty)
                CircularProgressIndicator(), // Display loading indicator
            ],
          ),
        ),
      ),
    );
  }
}
