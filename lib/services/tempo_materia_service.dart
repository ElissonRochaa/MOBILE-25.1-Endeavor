import 'dart:convert';

import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _baseUrl = '${dotenv.env['API_URL']}/tempo-materias';

Future<String?> iniciarSessao(materia, String token) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/criar'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: jsonEncode({'usuarioId': materia.usuarioId, 'materiaId': materia.id}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    handleHttpError(response);
  }
}

Future<String?> pausarSessao(String tempoMateriaId, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$_baseUrl/pausar/$tempoMateriaId'),
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return tempoMateriaId;
      }
      final data = jsonDecode(response.body);
      return data['id'] ?? tempoMateriaId;
    } else {
      handleHttpError(response);
    }
  } catch (e) {
    print('Exception ao pausar sessão: $e');
    return null;
  }
}

Future<String?> continuarSessao(String tempoMateriaId, String token) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/continuar/$tempoMateriaId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    handleHttpError(response);
  }
}

Future<String?> finalizarSessao(String tempoMateriaId, String token) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/finalizar/$tempoMateriaId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    handleHttpError(response);
  }
}

Future<Map<String, dynamic>?> buscarSessaoAtiva(
  String usuarioId,
  String materiaId,
  String token
) async {
  final response = await http.get(
    Uri.parse(
      '$_baseUrl/buscaPorUsuarioMateriaAtiva?usuarioId=$usuarioId&materiaId=$materiaId',
    ),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
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
        'status': status,
        'inicioSessao': inicioStr,
      };
    }
  }

  return null;
}

Future<List<TempoMateria>> buscarSessoesDeHojePorUsuario(
  String usuarioId,
  String token,
) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/sessoes-hoje?usuarioId=$usuarioId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => TempoMateria.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
