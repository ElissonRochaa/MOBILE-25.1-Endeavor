class AreaEstudo {
  String id;
  String nome;
  List<String> grupoDeEstudosIds;

  AreaEstudo({
    required this.id,
    required this.nome,
    required this.grupoDeEstudosIds,
  });

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
