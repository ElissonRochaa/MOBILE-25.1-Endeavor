import 'dart:convert';
import 'package:endeavor/models/auth_response.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://10.0.2.2:8080/api/auth';

Future<AuthResponse> login(String email, String senha) async {

  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'senha': senha,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return AuthResponse(
      id: data['id'],
      token: data['token'],
    );
  } else if (response.statusCode == 401) {
    throw Exception('Credenciais inválidas');
  } else {
    throw Exception('Erro ao autenticar usuário');
  } 
}