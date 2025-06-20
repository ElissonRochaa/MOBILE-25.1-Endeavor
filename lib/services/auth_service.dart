import 'dart:convert';

import 'package:endeavor/models/auth_response.dart';
import 'package:endeavor/utils/error_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final _authUrl = '${dotenv.env['API_URL']}/auth';

Future<AuthResponse> login(String email, String senha) async {
  final response = await http.post(
    Uri.parse('$_authUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'senha': senha}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return AuthResponse(id: data['id'], token: data['token']);
  } else {
    handleHttpError(response);
  }
}

Future<String> registrar(
  String nome,
  String email,
  String senha,
  int idade,
  String escolaridade,
) async {
  final response = await http.post(
    Uri.parse('$_authUrl/registro'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'idade': idade,
      'escolaridade': escolaridade,
    }),
  );

  if (response.statusCode == 200) {
    return 'Usuário registrado com sucesso';
  } else {
    handleHttpError(response);
  }
}

Future<bool> tokenValido(String token) async {
  final response = await http.post(
    Uri.parse('$_authUrl/token-valido'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'token': token}),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else {
      handleHttpError(response);
    }  
}
Future<AuthResponse> loginComGoogle(String idToken) async {
  print("AAAAAAA: $idToken");
  final response = await http.post(
    Uri.parse('$_authUrl/google'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"idToken": idToken}),
  );
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    return AuthResponse.fromJson(jsonDecode(response.body));
  } else {
    return AuthResponse(id: null, token: null);
  }
}

