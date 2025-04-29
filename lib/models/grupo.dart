class Grupo {
  final String id;
  String titulo;
  String descricao;
  int capacidade;
  bool privado;
  List<String> areasEstudo;
  List<String> membrosIds;

  Grupo({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.capacidade,
    required this.privado,
    required this.areasEstudo,
    required this.membrosIds,
  });

  int get membros => membrosIds.length;
}
