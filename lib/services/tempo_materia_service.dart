import 'dart:convert';

import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _baseUrl = '${dotenv.env['API_URL']}/tempo-materias';

Future<String?> iniciarSessao(materia) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/criar'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'usuarioId': materia.usuarioId, 'materiaId': materia.id}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    handleHttpError(response);
  }
}

Future<String?> pausarSessao(String tempoMateriaId) async {
  try {
    final response = await http.put(
      Uri.parse('$_baseUrl/pausar/$tempoMateriaId'),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return tempoMateriaId;
      }
      final data = jsonDecode(response.body);
      return data['id'] ?? tempoMateriaId;
    } else {
      print(
        'Erro ao pausar sessão. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return null;
    }
  } catch (e) {
    print('Exception ao pausar sessão: $e');
    return null;
  }
}

Future<String?> continuarSessao(String tempoMateriaId) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/continuar/$tempoMateriaId'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    print('Erro ao continuar sessão: ${response.body}');
    throw Exception('Erro ao continuar sessão');
  }
}

Future<String?> finalizarSessao(String tempoMateriaId) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/finalizar/$tempoMateriaId'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    print('Erro ao finalizar sessão: ${response.body}');
    throw Exception('Erro ao finalizar sessão');
  }
}

Future<Map<String, dynamic>?> buscarSessaoAtiva(
  String usuarioId,
  String materiaId,
) async {
  final response = await http.get(
    Uri.parse(
      '$_baseUrl/buscaPorUsuarioMateria?usuarioId=$usuarioId&materiaId=$materiaId',
    ),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['status'];
    final inicioStr = data['inicio'];
    final id = data['id'];

    if (status != 'FINALIZADO' && inicioStr != null) {
      final tempoDecorrido = data['tempoTotalAcumulado'];

      return {
        'tempoMateriaId': id,
        'tempoDecorrido': tempoDecorrido,
        'isRunning': status == 'EM_ANDAMENTO' ? true : false,
        'inicioSessao': inicioStr,
      };
    }
  }

  return null;
}

Future<List<TempoMateria>> buscarSessoesDeHojePorUsuario(
  String usuarioId,
) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/sessoes-hoje?usuarioId=$usuarioId'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => TempoMateria.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
