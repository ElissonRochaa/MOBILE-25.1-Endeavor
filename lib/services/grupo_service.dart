import 'dart:convert';

import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final apiUrl = '${dotenv.env['API_URL']}/grupos-estudo';
final String usuarioId = dotenv.env["USUARIO_ID"]!;

Future<List<Grupo>> getGrupos() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Grupo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<List<Grupo>> getGruposFromUsuario(String usuarioId) async {
  final response = await http.get(
    Uri.parse('$apiUrl/usuario?usuarioId=$usuarioId'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<Grupo> grupos =
        jsonList.map((json) {
          return Grupo.fromJson(json as Map<String, dynamic>);
        }).toList();
    return grupos;
  } else {
    handleHttpError(response);
  }
}

Future<Grupo> getGrupoById(String id) async {
  final response = await http.get(Uri.parse('$apiUrl/$id'));

  if (response.statusCode == 200) {
    return Grupo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<Grupo> createGrupo({
  required String titulo,
  required String descricao,
  required int capacidade,
  required bool privado,
  required String areaEstudo,
  required String idCriador,
}) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'titulo': titulo,
      'descricao': descricao,
      'capacidade': capacidade,
      'privado': privado,
      'areaEstudoId': areaEstudo,
      'usuarioCriadorId': usuarioId,
    }),
  );
  if (response.statusCode == 201) {
    return Grupo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<Grupo> updateGrupo({
  required String id,
  String? titulo,
  String? descricao,
  int? capacidade,
  bool? privado,
  List<String>? areasEstudo,
}) async {
  final body = <String, dynamic>{};
  if (titulo != null) body['titulo'] = titulo;
  if (descricao != null) body['descricao'] = descricao;
  if (capacidade != null) body['capacidade'] = capacidade;
  if (privado != null) body['privado'] = privado;
  if (areasEstudo != null) body['areasEstudo'] = areasEstudo;

  final response = await http.put(
    Uri.parse('$apiUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return Grupo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> deleteGrupo(String id) async {
  final response = await http.delete(Uri.parse('$apiUrl/$id'));

  if (response.statusCode != 204) {
    handleHttpError(response);
  }
}

Future<List<Grupo>> getGruposByMembroNome(String nome) async {
  final response = await http.get(Uri.parse('$apiUrl?membroNome=$nome'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Grupo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<void> adicionarMembroAoGrupo(String grupoId, String membroId) async {
  final response = await http.patch(
    Uri.parse('$apiUrl/$grupoId/adicionar-usuario/$usuarioId'),
  );
  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<void> removerMembroDoGrupo(String grupoId, String membroId) async {
  final response = await http.patch(
    Uri.parse('$apiUrl/$grupoId/remover-usuario/$membroId'),
  );

  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<List<MembroComTempo>> getMembrosDoGrupo(String grupoId) async {
  final response = await http.get(Uri.parse('$apiUrl/$grupoId/membros'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => MembroComTempo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
