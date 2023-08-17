import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants.dart';

Future<Map<String, dynamic>> performLogin(String username, String password) async {

  final response = await http.post(
    Uri.parse('${baseUrl}token/'),
    body: {
      "username": username,
      "password": password,
    },
  );

  if (response.statusCode == 200) {
    // Successful login, navigate to dashboard
    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Handle error
    throw "Login Failed. Try Again";

  }
}