import 'dart:convert';

import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final apiUrl = '${dotenv.env['API_URL']}/grupos-estudo';

Future<List<Grupo>> getGrupos(String token) async {
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => Grupo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<List<Grupo>> getGruposFromUsuario(String usuarioId, String token) async {
  final response = await http.get(
    Uri.parse('$apiUrl/usuario?usuarioId=$usuarioId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    print("GRUPOS");
    print(jsonList);
    final List<Grupo> grupos =
        jsonList.map((json) {
          return Grupo.fromJson(json as Map<String, dynamic>);
        }).toList();

    return grupos;
  } else {
    handleHttpError(response);
  }
}

Future<void> atualizarGrupo({
  required String grupoId,
  required Grupo grupoData,
  required String token,
}) async {
  print("AQUII");
  print(grupoData.areasEstudo.first.id);
  final response = await http.put(
    Uri.parse('$apiUrl/$grupoId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'titulo': grupoData.titulo,
      'descricao': grupoData.descricao,
      'capacidade': grupoData.capacidade,
      'privado': grupoData.privado,
      'areaEstudoId': grupoData.areasEstudo.first.id,
    }),
  );

  if (response.statusCode == 200) {
    return;
  } else {
    handleHttpError(response);
  }
}

Future<Grupo> getGrupoById(String id, String token) async {
  final response = await http.get(
    Uri.parse('$apiUrl/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

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
  required String token,
}) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'titulo': titulo,
      'descricao': descricao,
      'capacidade': capacidade,
      'privado': privado,
      'areaEstudoId': areaEstudo,
      'usuarioCriadorId': idCriador,
    }),
  );
  if (response.statusCode == 201) {
    return Grupo.fromJson(jsonDecode(response.body));
  } else {
    handleHttpError(response);
  }
}

Future<void> deleteGrupo(String id, String token) async {
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

Future<List<Grupo>> getGruposByMembroNome(String nome, String token) async {
  final response = await http.get(
    Uri.parse('$apiUrl?membroNome=$nome'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Grupo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<List<Grupo>> getGrupoByAreaEstudo(String areaEstudo) async {
  print("aqui!");
  print('$apiUrl/por-area/$areaEstudo');
  final response = await http.get(
    Uri.parse('$apiUrl/por-area/$areaEstudo'),
    headers: {
      'Content-Type': 'application/json',
      },
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Grupo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}

Future<void> adicionarMembroAoGrupo(
  String grupoId,
  String membroId,
  String token,
) async {
  final response = await http.patch(
    Uri.parse('$apiUrl/$grupoId/adicionar-usuario/$membroId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<void> removerMembroDoGrupo(
  String grupoId,
  String membroId,
  String token,
) async {
  final response = await http.patch(
    Uri.parse('$apiUrl/$grupoId/remover-usuario/$membroId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<List<MembroComTempo>> getMembrosDoGrupo(
  String grupoId,
  String token,
) async {
  final response = await http.get(
    Uri.parse('$apiUrl/$grupoId/membros'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => MembroComTempo.fromJson(json)).toList();
  } else {
    handleHttpError(response);
  }
}
