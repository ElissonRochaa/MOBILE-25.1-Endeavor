class ExceptionBody implements Exception {
  final int httpStatus;
  final String error;
  final String message;
  final String request;
  final DateTime timeStamp;

  ExceptionBody({
    required this.httpStatus,
    required this.error,
    required this.message,
    required this.request,
    required this.timeStamp,
  });

  factory ExceptionBody.fromJson(Map<String, dynamic> json) {
    return ExceptionBody(
      httpStatus: json['httpStatus'],
      error: json['error'],
      message: json['message'],
      request: json['request'],
      timeStamp: DateTime.parse(json['timeStamp']),
    );
  }

  @override
  String toString() {
    return '''
- httpStatus: $httpStatus
- error: $error
- message: $message
- request: $request
- timeStamp: $timeStamp
''';
  }
}
