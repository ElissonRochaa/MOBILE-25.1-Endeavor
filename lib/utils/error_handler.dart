import 'dart:convert';

import 'package:endeavor/models/exception_body.dart';
import 'package:http/http.dart' as http;

Never handleHttpError(http.Response response) {
  final Map<String, dynamic> jsonBody = jsonDecode(response.body);
  if (jsonBody.containsKey('httpStatus')) {
    throw ExceptionBody.fromJson(jsonBody);
  } else {
    throw Exception('Erro desconhecido');
  }
}
