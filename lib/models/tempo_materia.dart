import 'package:flutter/cupertino.dart';

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
  final String materiaId;
  final DateTime? inicio;
  final DateTime? fim;
  final StatusCronometro status;
  final int tempoTotalAcumulado; // em segundos

  TempoMateria({
    required this.id,
    required this.usuarioId,
    required this.materiaId,
    this.inicio,
    this.fim,
    required this.status,
    required this.tempoTotalAcumulado,
  });

  factory TempoMateria.fromJson(Map<String, dynamic> json) {
    try {
      final statusString = json['status'] as String? ?? '';
      final statusEnum = statusCronometroFromString(statusString);

      DateTime? inicioDate = json['inicio'] != null
          ? DateTime.tryParse(json['inicio'] as String)?.toUtc()
          : null;

      int tempoAcumulado = (json['tempoTotalAcumulado'] as num?)?.toInt() ?? 0;

      if (statusEnum == StatusCronometro.emAndamento && inicioDate != null) {
        final agora = DateTime.now().toUtc();
        if (agora.isAfter(inicioDate)) {
          final diff = agora.difference(inicioDate);
          tempoAcumulado += diff.inSeconds;
          inicioDate = agora;
        }
      }

      return TempoMateria(
        id: json['id'] as String? ?? '',
        usuarioId: json['usuarioId'] as String? ?? '',
        materiaId: json['materiaId'] as String? ?? '',
        inicio: inicioDate,
        fim: json['fim'] != null
            ? DateTime.tryParse(json['fim'] as String)
            : null,
        status: statusEnum,
        tempoTotalAcumulado: tempoAcumulado,
      );
    } catch (e) {
      debugPrint('Erro ao desserializar TempoMateria: $e');
      debugPrint('JSON recebido: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'materiaId': materiaId,
      'inicio': inicio?.toIso8601String(),
      'fim': fim?.toIso8601String(),
      'status': status.name,
      'tempoTotalAcumulado': tempoTotalAcumulado,
    };
  }

  Duration get tempoTotalAsDuration => Duration(seconds: tempoTotalAcumulado);
}
