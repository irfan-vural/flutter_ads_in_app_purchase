import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JavaService {
  // HTTP GET isteği
  String apiUrl = 'http://192.168.1.105:8080/api/v1/auth/register';
  Future<void> register() async {
    final Map<String, dynamic> postData = {
      "firstName": "irfan",
      "lastName": "vural",
      "email": "irfanvural.dev@gmail.com",
      "phone": "05457736288",
      "password": "12345678"
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        debugPrint(data.toString());
      } else {
        debugPrint('Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }
}
