import "package:endeavor/models/login.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginProvider extends StateNotifier<Login> {
  LoginProvider() : super(Login(email: null, senha: null));

  void setEmail(String email) {
    state = Login(email: email, senha: state.senha);
  }

  void setSenha(String senha) {
    state = Login(email: state.email, senha: senha);
  }
  
}

final loginProvider = StateNotifierProvider<LoginProvider, Login>(
  (ref) => LoginProvider(),
);