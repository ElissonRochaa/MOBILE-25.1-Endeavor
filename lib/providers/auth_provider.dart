import "package:endeavor/models/auth_response.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AuthProvider extends StateNotifier<AuthResponse> {
  AuthProvider() : super(AuthResponse(id: null, token: null));

  void setAuth(AuthResponse authResponse) {
    state = authResponse;
    
 }

  void clearAuth() {
    state = AuthResponse(id: null, token: null);
  }
  
}

final authProvider = StateNotifierProvider<AuthProvider, AuthResponse>(
  (ref) => AuthProvider(),
);