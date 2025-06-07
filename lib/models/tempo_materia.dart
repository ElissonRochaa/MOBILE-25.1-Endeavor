enum StatusCronometro { emAndamento, pausado, finalizado }

StatusCronometro statusCronometroFromString(String status) {
  switch (status.toUpperCase()) {
    case 'EM_ANDAMENTO':
      return StatusCronometro.emAndamento;
    case 'PAUSADO':
      return StatusCronometro.pausado;
    case 'FINALIZADO':
      return StatusCronometro.finalizado;
    default:
      throw ArgumentError('status de cronômetro desconhecido: $status');
  }
}

class TempoMateria {
  final String id;
  final String usuarioId;
  final String materia;
  final DateTime? inicio;
  final DateTime? fim;
  final StatusCronometro status;
  final int tempoTotalAcumulado; // em segundos

  TempoMateria({
    required this.id,
    required this.usuarioId,
    required this.materia,
    this.inicio,
    this.fim,
    required this.status,
    required this.tempoTotalAcumulado,
  });

  factory TempoMateria.fromJson(Map<String, dynamic> json) {
    return TempoMateria(
      id: json['id'] as String,
      usuarioId: json['usuarioId'] as String,
      materia: json['materia'] as String,
      inicio:
          json['inicio'] != null
              ? DateTime.parse(json['inicio'] as String).toUtc()
              : null,
      fim: json['fim'] != null ? DateTime.parse(json['fim'] as String) : null,
      status: statusCronometroFromString(json['status'] as String),
      tempoTotalAcumulado: (json['tempoTotalAcumulado'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'materia': materia,
      'inicio': inicio?.toIso8601String(),
      'fim': fim?.toIso8601String(),
      'status': status.name,
      'tempoTotalAcumulado': tempoTotalAcumulado,
    };
  }

  Duration get tempoTotalAsDuration => Duration(seconds: tempoTotalAcumulado);
}
