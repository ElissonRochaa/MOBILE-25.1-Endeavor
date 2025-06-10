import 'dart:async';
import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/screens/materias/criar_meta.dart';
import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../screens/materias/materias_details_screen.dart';
import '../../services/tempo_materia_service.dart' as tempo_materia_service;

class MateriaItem extends StatefulWidget {
  final Materia materia;

  const MateriaItem({super.key, required this.materia});

  @override
  State<MateriaItem> createState() => _MateriaItemState();
}

class _MateriaItemState extends State<MateriaItem> {
  Timer? _timer;
  int _totalSeconds = 0;
  StatusCronometro? _status;
  String? _tempoMateriaId;
  DateTime? _inicioSessao;

  @override
  void initState() {
    super.initState();
    _initSessionData();
  }

  Future<void> _initSessionData() async {
    final tempoMateria = widget.materia.tempoMateria;
    final tempoTotalAcumulado = await tempo_materia_service.buscarSessaoAtiva(
      widget.materia.usuarioId,
      widget.materia.id,
    );

    if (tempoMateria != null) {
      _tempoMateriaId = tempoMateria.id;
      _status = tempoMateria.status;
      _totalSeconds = tempoTotalAcumulado?['tempoDecorrido'] ?? 0;

      if (_status == StatusCronometro.emAndamento) {
        _inicioSessao = tempoMateria.inicio;
        _totalSeconds += DateTime.now().difference(_inicioSessao!).inSeconds;
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _inicioSessao = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _inicioSessao == null) return;

      setState(() {
        _totalSeconds += 1;
      });
    });
  }


  void _stopTimer() {
    _timer?.cancel();

    _totalSeconds += DateTime.now().difference(_inicioSessao!).inSeconds;
  }

  Future<void> _handlePlayPause() async {
    try {
      if (_status == StatusCronometro.emAndamento) {
        // Pausar
        await tempo_materia_service.pausarSessao(_tempoMateriaId!);
        _stopTimer();
        setState(() => _status = StatusCronometro.pausado);
      } else {
        // Iniciar/Continuar
        if (_tempoMateriaId == null) {
          _tempoMateriaId = await tempo_materia_service.iniciarSessao(widget.materia);
        } else {
          await tempo_materia_service.continuarSessao(_tempoMateriaId!);
        }

        setState(() {
          _status = StatusCronometro.emAndamento;
          _startTimer();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MateriasDetailsScreen(materiaId: widget.materia.id),
        ),
      ),
      child: Card(
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.materia.nome,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handlePlayPause,
                    icon: Icon(
                      _status == StatusCronometro.emAndamento ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onTertiary,
                      size: 32,
                    ),
                  ),
                ],
              ),
              Text(
                widget.materia.descricao,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CriarMetaScreen()),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiary, size: 32),
                          const SizedBox(width: 4),
                          Text(
                            'Adicionar Meta',
                            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(_totalSeconds),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}