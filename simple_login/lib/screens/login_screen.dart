import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

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
  bool _isLoading = false;

  Future<void> _login() async {
    setState((){
      _isLoading = true;
    });
    try {
      final jsonResponse  = await performLogin("testhealthit", "T3st@987654321");
      // final jsonResponse  = await performLogin(_usernameController.text, _passwordController.text);
      setState((){
        _isLoading = false;
      });
      final token = jsonResponse['access'] as String;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(bearerToken: token),
        ),
      );
    }catch(e) {
      setState((){
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e as String)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: _isLoading
        ?const CircularProgressIndicator()
        :Padding(
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