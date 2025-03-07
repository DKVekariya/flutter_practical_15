import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});


class ApiService {
  final String baseUrl = "http://universities.hipolabs.com/search";

  // Fetch universities by name and country
  Future<List<dynamic>> fetchUniversities({String name = "", String country = ""}) async {
    try {
      final Uri uri = Uri.parse("$baseUrl?name=$name&country=$country");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch universities");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch universities by country only
  Future<List<dynamic>> fetchUniversitiesByCountry(String selectedCountry) async {
    try {
      final Uri uri = Uri.parse("$baseUrl?country=$selectedCountry");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch universities");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}