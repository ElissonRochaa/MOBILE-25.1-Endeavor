import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/meta.dart';
import '../utils/error_handler.dart';

final apiUrl = '${dotenv.env['API_URL']}/metas';



Future<List<Meta>> getMetas(String token) async {
  final response = await http.get(Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Meta.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<Meta> getMetaById(String id, String token) async {
  final response = await http.get(Uri.parse('$apiUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return Meta.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}


Future<List<Meta>> getMetaByMateria(String materiaId, String token) async {
  final response = await http.get(Uri.parse('$apiUrl/porMateria/$materiaId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Meta.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<Meta> createMeta({
  required String nome,
  required String descricao,
  required String materiaId,
  required String token,
  DateTime? data,
  bool concluida = false,

}) async {
  final body = jsonEncode({
    'nome': nome,
    'descricao': descricao,
    'materiaId': materiaId,
    'data': data?.toIso8601String(),
    'concluida': false,
  });
  print('Request body: $body');

  final response = await http.post(
    Uri.parse('$apiUrl/criar'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: body,
  );

  if (response.statusCode == 200) {
    return Meta.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao criar meta: ${response.statusCode} - ${response.body}');
  }
}

Future<Meta> updateMeta({
  required String id,
  required String token,
  bool? concluida,
}) async {
  final body = <String, dynamic>{'id': id};
  if (concluida != null) body['concluida'] = concluida;

  final response = await http.put(
    Uri.parse('$apiUrl/atualizar'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    return Meta.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> deleteMeta(String id, String token) async {
  final response = await http.delete(Uri.parse('$apiUrl/excluir/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 204) {
    handleHttpError(response);
  }
}



