import 'dart:convert';

import 'package:endeavor/models/usuario.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final apiUrl = '${dotenv.env['API_URL']}/usuarios';

Future<List<Usuario>> listarUsuarios() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<Usuario> buscarUsuarioPorId(String id, String token) async {
  final url = Uri.parse('$apiUrl/$id');

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

Future<Usuario> atualizarUsuario(Usuario usuario) async {
  final response = await http.put(
    Uri.parse('$apiUrl/atualizar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(usuario.toJson()),
  );

  if (response.statusCode == 200) {
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> excluirUsuario(String id) async {
  final response = await http.delete(Uri.parse('$apiUrl/$id'));

  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<bool> usuarioJaCadastrado(String email) async {
  final response = await http.get(
    Uri.parse('$apiUrl/usuarioJaCadastrado/$email'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as bool;
  } else {
    handleHttpError(response);
  }
}

Future<List<Usuario>> buscarUsuariosPorNome(String nome) async {
  final response = await http.get(
    Uri.parse('$apiUrl/buscarUsuariosPorNome/$nome'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}


