enum Escolaridade {
  fundamental1,
  fundamental2,
  ensinoMedio,
  universitario,
}

class Perfil {
  final int id;
  final String nome;
  final int idade;
  final Escolaridade escolaridade;
  final String areaEstudo;
  final String email;
  final String senha;

  Perfil({
    required this.id,
    required this.nome,
    required this.idade,
    required this.escolaridade,
    required this.areaEstudo,
    required this.email,
    required this.senha,
  });
}
