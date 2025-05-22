import 'package:endeavor/models/materia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://10.0.2.2:8080/api/materias';

List<Materia> _materiasDummy = [
  Materia(
    id: 1,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
  ),
  Materia(
    id: 2,
    nome: 'Verificação e validação de testes',
    descricao: 'cadeira de testes',
    ),
  Materia(
    id: 3,
    nome: 'Outra matéria',
    descricao: 'É uma outra matéria',
  ),
];

Future<List<Materia>> getMaterias() async {

  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Materia.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar matérias');
  }
}

Future<Materia> getMateriaById(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/$id'));

  if (response.statusCode == 200) {
    return Materia.fromJson(json.decode(response.body));
  } else {
    throw Exception('Matéria não encontrada');
  }
}

Future<Materia> createMateria({
  required String nome,
  required String descricao,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/create'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': nome,
      'descricao': descricao,
    }),
  );

  if (response.statusCode == 200) {
    return Materia.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao criar matéria');
  }
}

Future<Materia?> updateMateria({
  String? nome,
  String? descricao,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/update'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': nome,
      'descricao': descricao,
    }),
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



