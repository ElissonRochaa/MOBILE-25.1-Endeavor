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

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      capacidade: json['capacidade'],
      privado: json['privado'],
      areasEstudo: [json['areaEstudo']],
      membrosIds: List<String>.from(json['usuariosIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'capacidade': capacidade,
      'privado': privado,
      'areasEstudo': areasEstudo,
      'membrosIds': membrosIds,
    };
  }
}
