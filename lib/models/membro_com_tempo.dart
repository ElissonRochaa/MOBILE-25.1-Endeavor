import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/models/usuario.dart';

class MembroComTempo {
  Usuario usuario;
  TempoMateria? tempoMateria;

  MembroComTempo({required this.usuario, required this.tempoMateria});

  factory MembroComTempo.fromJson(Map<String, dynamic> json) {
    return MembroComTempo(
      usuario: Usuario.fromJson(json['usuario']),
      tempoMateria:
          json['tempoMateria'] != null
              ? TempoMateria.fromJson(json['tempoMateria'])
              : null,
    );
  }

  bool get isAtivo => tempoMateria?.status == StatusCronometro.emAndamento;
}
