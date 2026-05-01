import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/complaint.dart';

class ApiService {
  static const String baseUrl = 'https://69f4355ebd2396bf5310ad9f.mockapi.io/api/v1/complaint';

  // GET all
  static Future<List<Complaint>> getComplaints() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Complaint.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load complaints');
    }
  }

  // POST
  static Future<void> createComplaint(Complaint complaint) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(complaint.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create complaint');
    }
  }

  // PUT (approve)
  static Future<void> updateComplaint(String id, bool status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update complaint');
    }
  }

  // DELETE
  static Future<void> deleteComplaint(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete complaint');
    }
  }
}