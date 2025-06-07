import 'package:endeavor/main.dart';
import 'package:endeavor/models/exception_body.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(Object error) {
    if (error is ExceptionBody) {
      _showExceptionDialog(error);
    } else {
      _showGenericErrorDialog(error.toString());
    }
  }

  static void handleFlutterError(Object error) {
    handleError(error);
  }

  static bool _isDialogShowing = false;

  static void _showExceptionDialog(ExceptionBody exception) {
    final context = navigatorKey.currentContext;
    if (context != null && !_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(exception.error),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mensagem: ${exception.message}'),
                    const SizedBox(height: 8),
                    Text('Status HTTP: ${exception.httpStatus}'),
                    const SizedBox(height: 8),
                    Text('Requisição: ${exception.request}'),
                    const SizedBox(height: 8),
                    Text('Data/Hora: ${exception.timeStamp}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      ).whenComplete(() {
        _isDialogShowing = false;
      });
    }
  }

  static void _showGenericErrorDialog(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && !_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Erro desconhecido'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      ).whenComplete(() {
        _isDialogShowing = false;
      });
    }
  }
}
