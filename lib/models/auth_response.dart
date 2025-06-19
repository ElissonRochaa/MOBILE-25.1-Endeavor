
class AuthResponse {
  final String? id;
  final String? token;

  AuthResponse({this.id, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'],
      token: json['token'],
    );
  }
}