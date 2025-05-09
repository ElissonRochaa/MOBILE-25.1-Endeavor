import '../models/perfil.dart';

class PerfilService {
  static final PerfilService _instancia = PerfilService._interno();
  factory PerfilService() => _instancia;

  PerfilService._interno();

  Perfil? _perfilAtual;

  void salvarPerfil(Perfil perfil) {
    _perfilAtual = perfil;
  }

  Perfil? get perfilAtual => _perfilAtual;

  void atualizarPerfil({
    String? nome,
    int? idade,
    Escolaridade? escolaridade,
    String? areaEstudo,
    String? email,
    String? senha,
  }) {
    if (_perfilAtual == null) return;

    _perfilAtual = Perfil(
      id: _perfilAtual!.id,
      nome: nome ?? _perfilAtual!.nome,
      idade: idade ?? _perfilAtual!.idade,
      escolaridade: escolaridade ?? _perfilAtual!.escolaridade,
      areaEstudo: areaEstudo ?? _perfilAtual!.areaEstudo,
      email: email ?? _perfilAtual!.email,
      senha: senha ?? _perfilAtual!.senha,
    );
  }

  void limparPerfil() {
    _perfilAtual = null;
  }
}
