import "package:endeavor/models/usuario.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class UsuarioProvider extends StateNotifier<Usuario> {
  UsuarioProvider() : super(Usuario(id: null, nome: null, email: null, idade: null, escolaridade: null));

  void setUsuario(Usuario usuario) {
    state = usuario;
    
 }

  void clearAuth() {
    state = Usuario(id: null, nome: null, email: null, idade: null, escolaridade: null);
  }
  
}

final usuarioProvider = StateNotifierProvider<UsuarioProvider, Usuario>(
  (ref) => UsuarioProvider(),
);