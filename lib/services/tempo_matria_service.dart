import 'dart:convert';

import 'package:http/http.dart' as http;

const String _baseUrl = 'http://10.0.2.2:8080/api/tempo-materias';

Future<int?> iniciarSessao(materia) async {
  final response = await http.post(Uri.parse('$_baseUrl/criar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'usuarioId': materia.usuarioId,
      'materiaId': materia.id,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    print('Erro ao iniciar sessão: ${response.body}');
    throw Exception('Erro ao iniciar sessão');
  }
}

Future<bool> pausarSessao(int tempoMateriaId) async {
final response = await http.put(Uri.parse('$_baseUrl/pausar/$tempoMateriaId'));
return response.statusCode == 200;
}

Future<bool> continuarSessao(int tempoMateriaId) async {
final response = await http.put(Uri.parse('$_baseUrl/continuar/$tempoMateriaId'));
return response.statusCode == 200;
}

Future<bool> finalizarSessao(int tempoMateriaId) async {
  final response = await http.put(Uri.parse('$_baseUrl/finalizar/$tempoMateriaId'));
  return response.statusCode == 200;
}

Future<int> getTempoMateriaAcumulado(int tempoMateriaId) async {
  final response = await http.get(Uri.parse('$_baseUrl/tempo-acumulado/$tempoMateriaId'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['tempoAcumulado'];
  } else {
    throw Exception('Erro ao obter tempo acumulado');
  }
}