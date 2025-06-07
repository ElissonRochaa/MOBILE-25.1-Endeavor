import 'dart:async';

import 'package:endeavor/screens/materias/criar_meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  int _secondsElapsed = 0;
  bool? _isRunning;
  String? _tempoMateriaId;
  bool _isFinalizado = false;
  DateTime? _inicioSessao;
  bool _sessionLoaded = false;

  @override
  void initState() {
    super.initState();
    print(
      'initState do MateriaItem chamado para materia: ${widget.materia.nome}',
    );
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final usuarioId =
        dotenv.env['USUARIO_ID'] ?? "e1e78a67-7ba6-4ebb-9330-084da088037f";

    final sessionData = await tempo_materia_service.buscarSessaoAtiva(
      usuarioId,
      widget.materia.id,
    );

    if (sessionData != null) {
      final status = sessionData['status']?.toString().toUpperCase().trim();
      final isRunning = status == 'EM_ANDAMENTO';

      setState(() {
        _secondsElapsed = sessionData['tempoTotalAcumulado'] ?? 0;
        _isRunning = isRunning;
        _tempoMateriaId = sessionData['id'];

        _inicioSessao =
            sessionData['inicio'] != null
                ? DateTime.tryParse(sessionData['inicio'].toString())
                : null;

        _sessionLoaded = true;
        print('Loaded session data. Status: $status, isRunning: $_isRunning');
      });

      if (_isRunning == true) {
        _startTimer();
      }
    } else {
      setState(() {
        _sessionLoaded = true;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _inicioSessao ??= DateTime.now();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final now = DateTime.now();

      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    print('Parando timer...');
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    return '${(seconds ~/ 3600).toString().padLeft(2, '0')}:'
        '${(seconds ~/ 60 % 60).toString().padLeft(2, '0')}:'
        '${(seconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _handlePlayPause() async {
    if (_isFinalizado) return;
    print(_secondsElapsed);
    print(_isRunning);
    print(_tempoMateriaId);
    print(_inicioSessao);

    try {
      if (_isRunning == true) {
        print(_tempoMateriaId);
        final success = await tempo_materia_service.pausarSessao(
          _tempoMateriaId!,
        );
        if (success != null) {
          setState(() {
            _isRunning = false;
          });
          _stopTimer();
        }
      } else if (_tempoMateriaId == null) {
        final id = await tempo_materia_service.iniciarSessao(widget.materia);
        if (id != null) {
          setState(() {
            _tempoMateriaId = id;
            _inicioSessao = DateTime.now();
            _isRunning = true;
            print("começar sessao");
          });
          _startTimer();
        }
      } else {
        final success = await tempo_materia_service.continuarSessao(
          _tempoMateriaId!,
        );
        if (success != null) {
          setState(() {
            _isRunning = true;
          });
          print("Continuar");
          _startTimer();
        }
      }
    } catch (e) {
      print('Error in _handlePlayPause: $e');
    }
  }

  Future<void> _handleFinalizar() async {
    if (_tempoMateriaId == null || _isFinalizado) return;
    final success = await tempo_materia_service.finalizarSessao(
      _tempoMateriaId!,
    );
    if (success != null) {
      _stopTimer();
      setState(() {
        _isFinalizado = true;
        _inicioSessao = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MateriasDetailsScreen(materia: widget.materia),
          ),
        );
      },
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
                    onPressed: () {
                      print("Clicou no botão");
                      print(_isRunning);
                      _handlePlayPause();
                    },
                    icon: Icon(
                      _isRunning == true ? Icons.pause : Icons.play_arrow,
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CriarMetaScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onTertiary,
                            size: 32,
                          ),
                          Text(
                            'Adicionar Meta',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_secondsElapsed > 0)
                    Text(
                      _formatTime(_secondsElapsed),
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
