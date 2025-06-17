import 'dart:convert';
import 'package:endeavor/models/auth_response.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.0.102:8080/api/auth';

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

Future<String> registrar(
  String nome,
  String email,
  String senha,
  int idade,
  String escolaridade,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/registro'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'idade': idade,
      'escolaridade': escolaridade,
    }),
  );

  if (response.statusCode == 200) {
    return 'Usuário registrado com sucesso';
  } else if (response.statusCode == 400) {
    final data = json.decode(response.body);
    throw Exception(data['message'] ?? 'Erro ao registrar usuário');
    
  } else {
    throw Exception('Erro ao registrar usuário');
  }
}
