import 'dart:convert';

import 'package:endeavor/models/area_estudo.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final apiUrl = '${dotenv.env['API_URL']}/areas-estudo';

Future<List<AreaEstudo>> getAreasEstudo(String? token) async {
  final response = await http.get(Uri.parse(apiUrl));
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => AreaEstudo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<AreaEstudo> getAreaEstudoById(String id, String token) async {
  final response = await http.get(
    Uri.parse('$apiUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return AreaEstudo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<AreaEstudo> createAreaEstudo({
  required String nome,
  required String token,
}) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'nome': nome}),
  );

  if (response.statusCode == 200) {
    return AreaEstudo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<AreaEstudo> updateAreaEstudo(
  String id,
  String novoNome,
  String token,
) async {
  final response = await http.put(
    Uri.parse('$apiUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(novoNome),
  );

  if (response.statusCode == 200) {
    return AreaEstudo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> deleteAreaEstudo(String id, String token) async {
  final response = await http.delete(
    Uri.parse('$apiUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 204) {
    handleHttpError(response);
  }
}

Future<List<AreaEstudo>> findAreaEstudoByNome(String nome) async {
  final response = await http.get(
    Uri.parse('$apiUrl/search?nome=$nome'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => AreaEstudo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
