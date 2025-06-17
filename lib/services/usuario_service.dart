import 'dart:convert';
import 'package:endeavor/models/usuario.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.0.102:8080/api/usuarios';

Future<Usuario> buscarUsuarioPorId(String id, String token) async {
  final url = Uri.parse('$baseUrl/$id');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return Usuario.fromJson(jsonData);
  } else if (response.statusCode == 404) {
    throw Exception('Usuário não encontrado');
  } else {
    throw Exception('Erro ao buscar usuário: ${response.statusCode}');
  }
}
