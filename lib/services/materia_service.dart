import 'package:endeavor/models/materia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://192.168.56.1:8080/api/materias';

Future<List<Materia>> getMaterias(String token) async {
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Materia.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar matérias: ${response.body}');
  }
}

Future<Materia> getMateriaById(String id, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

  if (response.statusCode == 200) {
    return Materia.fromJson(json.decode(response.body));
  } else {
    throw Exception('Matéria não encontrada');
  }
}

Future<Materia> createMateria({
  required String nome,
  required String descricao,
  String? usuarioId = "e1e78a67-7ba6-4ebb-9330-084da088037f",
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/create'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': nome,
      'descricao': descricao,
      'usuarioId': usuarioId,
    }),
  );

  if (response.statusCode == 200) {
    return Materia.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao criar matéria');
  }
}

Future<Materia?> updateMateria({String? nome, String? descricao}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/update'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'nome': nome, 'descricao': descricao}),
  );

  if (response.statusCode == 200) {
    return Materia.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao atualizar matéria');
  }
}

Future<void> deleteMateria(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));

  if (response.statusCode != 204) {
    throw Exception('Erro ao deletar matéria');
  }
}
