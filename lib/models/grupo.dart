import 'package:endeavor/models/area_estudo.dart';

class Grupo {
  final String id;
  String titulo;
  String descricao;
  int capacidade;
  bool privado;
  String criadorId;
  List<AreaEstudo> areasEstudo;
  List<String> membrosIds;

  Grupo({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.capacidade,
    required this.privado,
    required this.areasEstudo,
    required this.membrosIds,
    required this.criadorId,
  });

  int get membros => membrosIds.length;

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      capacidade: json['capacidade'],
      privado: json['privado'],
      areasEstudo: [
        AreaEstudo.fromJson(json['areaEstudo'] as Map<String, dynamic>),
      ],
      membrosIds: List<String>.from(json['usuariosIds']),
      criadorId: json["usuarioCriadorId"],
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
      "usuarioCriadorId": criadorId,
    };
  }
}
