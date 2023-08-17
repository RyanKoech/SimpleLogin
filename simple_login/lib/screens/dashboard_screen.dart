import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DashboardPage extends StatefulWidget {
  final String bearerToken;

  DashboardPage({required this.bearerToken});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic> dashboardData = {}; // To store the received data

  Future<void> _fetchDashboardData() async {
    final url = 'https://dev.cpims.net/api/dashboard/'; // Replace with the actual dashboard API endpoint

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${widget.bearerToken}"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        dashboardData = jsonResponse;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetching Data Failed')),
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
