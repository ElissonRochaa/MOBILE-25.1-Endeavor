
class Meta {
  final String id;
  String nome;
  String descricao;
  String materiaId;
  DateTime data;
  bool concluida;


  Meta({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.materiaId,
    required this.data,
    required this.concluida,

  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      materiaId: json['materiaId'],
      data: DateTime.parse(json['data']),
      concluida: json['concluida'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'materiaId': materiaId,
      'data': data.toIso8601String(),
      'concluida': concluida,
    };
  }
}