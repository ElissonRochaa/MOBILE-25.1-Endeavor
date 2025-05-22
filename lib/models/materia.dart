
class Materia {
  final int id;
  String nome;
  String descricao;
  int? usuarioId;


  Materia({
    required this.id,
    required this.nome,
    required this.descricao,
    this.usuarioId,


});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'usuarioId': usuarioId,
    };
  }
}