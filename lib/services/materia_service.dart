import 'dart:convert';

import 'package:endeavor/models/materia.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final apiUrl = '${dotenv.env['API_URL']}/materias';
final String usuarioId = dotenv.env["USUARIO_ID"]!;

Future<List<Materia>> getMaterias() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Materia.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<Materia> getMateriaById(String id) async {
  final response = await http.get(Uri.parse('$apiUrl/$id'));
  if (response.statusCode == 200) {
    return Materia.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<Materia> createMateria({
  required String nome,
  required String descricao,
  required String usuarioId,
}) async {
  final response = await http.post(
    Uri.parse('$apiUrl/create'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'nome': nome,
      'descricao': descricao,
      'usuarioId': usuarioId,
    }),
  );

  if (response.statusCode == 200) {
    return Materia.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<Materia> updateMateria({
  required String id,
  String? nome,
  String? descricao,
  String? usuarioId,
}) async {
  final body = <String, dynamic>{'id': id};
  if (nome != null) body['nome'] = nome;
  if (descricao != null) body['descricao'] = descricao;
  if (usuarioId != null) body['usuarioId'] = usuarioId;

  final response = await http.put(
    Uri.parse('$apiUrl/update'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return Materia.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> deleteMateria(String id) async {
  final response = await http.delete(Uri.parse('$apiUrl/$id'));
  if (response.statusCode != 204) {
    handleHttpError(response);
  }
}

Future<List<Materia>> buscarMateriasPorUsuario(String usuarioId) async {
  final response = await http.get(Uri.parse('$apiUrl/usuario/$usuarioId'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Materia.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
