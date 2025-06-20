import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/error_handler.dart';
import '../models/email_dto.dart';
import '../models/codigo_verificacao_request_dto.dart';

final apiUrl = '${dotenv.env['API_URL']}/usuarios';

Future<void> recuperarSenha(String email) async {
  final body = jsonEncode(EmailDTO(email: email).toJson());

  final response = await http.post(
    Uri.parse('$apiUrl/recuperar-senha'),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode != 200) {
    handleHttpError(response);
  }
}

Future<bool> verificarCodigo(String email, String codigo) async {
  final body = jsonEncode(CodigoVerificacaoRequestDTO(email: email, codigo: codigo).toJson());

  final response = await http.post(
    Uri.parse('$apiUrl/verificar-codigo'),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as bool;
  } else {
    handleHttpError(response);
  }
}
