
import 'package:endeavor/models/tempo_materia.dart';

class Materia {
  final String id;
  String nome;
  String descricao;
  String usuarioId;
  TempoMateria? tempoMateria;


  Materia({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.usuarioId,
    this.tempoMateria,


});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      usuarioId: json['usuarioId'],
      tempoMateria: json['tempoMateria'] != null ? TempoMateria.fromJson(json['tempoMateria']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'usuarioId': usuarioId,
      'tempoMateria': tempoMateria?.toJson(),
    };
  }
}