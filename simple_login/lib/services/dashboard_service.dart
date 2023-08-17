import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants.dart';

Future<Map<String, dynamic>> fetchDashboardData(token) async {
  final response = await http.get(
    Uri.parse('${baseUrl}dashboard/'),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    // Handle error
    throw "Error Fetching Information";
  }
}