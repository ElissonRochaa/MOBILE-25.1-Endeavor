class AreaEstudo {
  String id;
  String nome;
  bool padrao;
  List<String> grupoDeEstudosIds;

  AreaEstudo({
    required this.id,
    this.nome = "",
    this.padrao = false,
    List<String>? grupoDeEstudosIds,
  }) : grupoDeEstudosIds = grupoDeEstudosIds ?? [];

  factory AreaEstudo.fromJson(Map<String, dynamic> json) {
    return AreaEstudo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      grupoDeEstudosIds:
          (json['grupoDeEstudosIds'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
  }
}
