class Grupo {
  final String id;
  String titulo;
  String descricao;
  int capacidade;
  int membros;
  bool privado;
  List<String> areasEstudo;

  Grupo({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.capacidade,
    required this.membros,
    required this.privado,
    required this.areasEstudo,
  });
}
