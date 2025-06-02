import 'dart:convert';

import 'package:http/http.dart' as http;

const String _baseUrl = 'http://10.0.2.2:8080/api/tempo-materias';

Future<String?> iniciarSessao(materia) async {
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
Future<String?> pausarSessao(String tempoMateriaId) async {
  try {
    final response = await http.put(Uri.parse('$_baseUrl/pausar/$tempoMateriaId'));

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return tempoMateriaId;
      }
      final data = jsonDecode(response.body);
      return data['id'] ?? tempoMateriaId;
    } else {
      print('Erro ao pausar sessão. Status: ${response.statusCode}, Body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception ao pausar sessão: $e');
    return null;
  }
}

Future<String?> continuarSessao(String tempoMateriaId) async {
final response = await http.put(Uri.parse('$_baseUrl/continuar/$tempoMateriaId'));

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  return data['id'];
} else {
  print('Erro ao continuar sessão: ${response.body}');
  throw Exception('Erro ao continuar sessão');
}
}

Future<String?> finalizarSessao(String tempoMateriaId) async {
  final response = await http.put(Uri.parse('$_baseUrl/finalizar/$tempoMateriaId'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    print('Erro ao finalizar sessão: ${response.body}');
    throw Exception('Erro ao finalizar sessão');
  }
}

Future<Map<String, dynamic>?> buscarSessaoAtiva(String usuarioId, String materiaId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/buscaPorUsuarioMateriaAtiva?usuarioId=$usuarioId&materiaId=$materiaId'),
  );
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final inicioStr = data['inicio'];

    if (inicioStr != null) {

      return {
        'tempoMateriaId': data['id'],
        'tempoDecorrido': data['tempoTotalAcumulado'],
        'isRunning': data['status'] == 'EM_ANDAMENTO',
        'status': data['status'],
        'inicioSessao': data['inicio']
      };
    }
  }

  return null;
}