import 'package:endeavor/models/evolucao_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseEstatisticasUrl = '${dotenv.env['API_URL']}/estatisticas';

Future<int> getTempoTotalPorMateria({
  required String usuarioId,
  required int materiaId,
  required String token
}) async {
  final url = Uri.parse(
    '$baseEstatisticasUrl/materia?usuarioId=$usuarioId&materiaId=$materiaId',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter tempo total por matéria');
  }
}

Future<int> getTempoTotalNoDia({
  required String usuarioId,
  required DateTime data,
  required String token
}) async {
  final dataStr = data.toIso8601String().substring(0, 10);
  final url = Uri.parse(
    '$baseEstatisticasUrl/dia?usuarioId=$usuarioId&data=$dataStr',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter tempo total no dia');
  }
}

Future<int> getTempoTotalNoDiaPorMateria({
  required String usuarioId,
  required int materiaId,
  required DateTime data,
  required String token
}) async {
  final dataStr = data.toIso8601String().substring(0, 10);
  final url = Uri.parse(
    '$baseEstatisticasUrl/dia/materia?usuarioId=$usuarioId&materiaId=$materiaId&data=$dataStr',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter tempo total no dia por matéria');
  }
}

Future<int> getTempoNaSemana({
  required String usuarioId,
  required DateTime inicio,
  required DateTime fim,
  required String token,
}) async {
  final inicioStr = inicio.toIso8601String().substring(0, 10);
  final fimStr = fim.toIso8601String().substring(0, 10);
  final url = Uri.parse(
    '$baseEstatisticasUrl/semana?usuarioId=$usuarioId&inicio=$inicioStr&fim=$fimStr',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter tempo na semana');
  }
}

Future<int> getTempoNaSemanaPorMateria({
  required String usuarioId,
  required int materiaId,
  required DateTime inicio,
  required DateTime fim,
  required String token,
}) async {
  final inicioStr = inicio.toIso8601String().substring(0, 10);
  final fimStr = fim.toIso8601String().substring(0, 10);
  final url = Uri.parse(
    '$baseEstatisticasUrl/semana/materia?usuarioId=$usuarioId&materiaId=$materiaId&inicio=$inicioStr&fim=$fimStr',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter tempo na semana por matéria');
  }
}

Future<List<EvolucaoModel>> getEvolucao({
  required String usuarioId,
  required DateTime inicio,
  required DateTime fim,
  required String unidade, // "DAYS", "WEEKS", "MONTHS" - unidades de tempo
  required String token,
  int intervalo = 1,

}) async {
  final String url = '$baseEstatisticasUrl/evolucao'
      '?usuarioId=$usuarioId'
      '&inicio=${inicio.toIso8601String().split('T')[0]}'
      '&fim=${fim.toIso8601String().split('T')[0]}'
      '&unidade=$unidade'
      '&intervalo=$intervalo';

  final response = await http.get(Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<EvolucaoModel> evolucao = data.map((item) => EvolucaoModel.fromJson(item)).toList();
    print(evolucao);
    print(DateTime.now());
    return evolucao;
  } else {
    throw Exception('Erro ao carregar evolução');
  }
}

Future<int> getDiasConsecutivosDeEstudo({
  required String usuarioId,
  required String token,
  int tempoMinimoDiario = 5,
}) async {
  final url = Uri.parse(
    '$baseEstatisticasUrl/foguinho'
        '?usuarioId=$usuarioId'
        '&tempoMinimoDiario=$tempoMinimoDiario',
  );

  final response = await http.get(url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Erro ao obter dias consecutivos de estudo');
  }
}

