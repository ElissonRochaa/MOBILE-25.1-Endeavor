import 'dart:async';

import 'package:endeavor/models/materia.dart';
import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/widgets/membros/info_box.dart';
import 'package:flutter/material.dart';

import '../../services/materia_service.dart';

class MembroItem extends StatefulWidget {
  final MembroComTempo membroDetails;

  const MembroItem({super.key, required this.membroDetails});

  @override
  State<MembroItem> createState() => _MembroItemState();
}

class _MembroItemState extends State<MembroItem> {
  late Timer _timer;
  String? _materiaNome;
  bool _loadingMateria = false;

  Duration get tempoTotal {
    final tempoMateria = widget.membroDetails.tempoMateria;
    if (tempoMateria == null) return Duration.zero;

    Duration acumulado = Duration(seconds: tempoMateria.tempoTotalAcumulado);

    if (tempoMateria.status == StatusCronometro.emAndamento &&
        tempoMateria.inicio != null) {
      final agora = DateTime.now().toUtc();
      final tempoCorrendo = agora.difference(tempoMateria.inicio!);
      return acumulado + tempoCorrendo;
    } else {
      return acumulado;
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    _carregarNomeMateria();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _carregarNomeMateria() async {
    if (_materiaNome != null || _loadingMateria) return;

    setState(() => _loadingMateria = true);
    try {
      Materia? materia;

      if (widget.membroDetails.tempoMateria != null) {
        materia = await getMateriaById(
          widget.membroDetails.tempoMateria!.materiaId,
        );
      }
      setState(
        () => _materiaNome = materia != null ? materia.nome : "Nenhuma matéria",
      );
    } catch (e) {
      setState(() => _materiaNome = 'Erro ao carregar');
    } finally {
      setState(() => _loadingMateria = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAtivo = widget.membroDetails.isAtivo;
    final corCard =
        isAtivo
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.tertiary;
    final corInterna =
        isAtivo
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.tertiaryContainer;

    final tempoFormatado = _formatarTempo(tempoTotal);

    return Card(
      color: corCard,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListTile(
          title: Text(
            widget.membroDetails.usuario.nome!,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Image.asset(
                fit: BoxFit.contain,
                height: 50,
                isAtivo
                    ? "assets/membro_estudando.png"
                    : "assets/membro_relaxando.png",
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  InfoBox(
                    corBackground: corInterna,
                    isAtivo: isAtivo,
                    titulo: "Matéria",
                    data:
                        _loadingMateria
                            ? 'Carregando...'
                            : _materiaNome ?? 'Não informado',
                  ),
                  const SizedBox(width: 8),
                  InfoBox(
                    corBackground: corInterna,
                    isAtivo: isAtivo,
                    titulo: "Total",
                    data: tempoFormatado,
                    icone: Icons.timer_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarTempo(Duration duracao) {
    final horas = duracao.inHours.toString().padLeft(2, '0');
    final minutos = (duracao.inMinutes % 60).toString().padLeft(2, '0');
    final segundos = (duracao.inSeconds % 60).toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }
}
