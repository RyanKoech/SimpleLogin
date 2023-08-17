import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading?
        const CircularProgressIndicator():
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding:  EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 200, bottom: 0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number, email or username',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  child: const Text( 'Log in ', style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: (){
                    print('Successfully log in ');
                  },

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final url = 'https://dev.cpims.net/api/token/'; // Replace with your API endpoint

    // final body = json.encode({
    //   "username": _usernameController.text,
    //   "password": _passwordController.text,
    // });

    final response = await http.post(
      Uri.parse(url),
      // headers: {"Content-Type": "application/json"},
      body: {
        "username": "testhealthit",
        "password": "T3st@987654321",
      },
    );

    if (response.statusCode == 200) {
      // Successful login, navigate to dashboard
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final token = jsonResponse['access'] as String;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(bearerToken: token),
        ),
      );

    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      print('Failed to fetch dashboard data');
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
