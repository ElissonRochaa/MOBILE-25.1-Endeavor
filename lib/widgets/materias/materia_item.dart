import 'dart:async';
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
  int _secondsElapsed = 0;
  bool _isRunning = false;
  int? _tempoMateriaId;
  bool _isFinalizado = false;
  DateTime? _inicioSessao;

  @override
  void initState() {
    super.initState();
    print('initState do MateriaItem chamado para materia: ${widget.materia.nome}');
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final usuarioId = 1;
    print("loadData");
    final sessionData = await tempo_materia_service.buscarSessaoAtiva(usuarioId, widget.materia.id);

    if (sessionData != null) {
      setState(() {
        _secondsElapsed = sessionData['tempoDecorrido'];
        _isRunning = sessionData['isRunning'];
        _tempoMateriaId = sessionData['tempoMateriaId'];
        _inicioSessao = DateTime.parse(sessionData['inicioSessao']);
      });

      print(sessionData);
      if (_isRunning) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _inicioSessao ??= DateTime.now();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final now = DateTime.now();

      if (_inicioSessao != null &&
          (now.year != _inicioSessao!.year ||
              now.month != _inicioSessao!.month ||
              now.day != _inicioSessao!.day)) {
        await _handleFinalizar();
        return;
      }

      setState(() {
        _secondsElapsed++;
      });
    });

    setState(() {
      _isRunning = true;
    });
  }


  void _stopTimer() {
    print('Parando timer...');
    _timer?.cancel();
    setState(() {
      _isRunning = false;

    });
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

  //dependente de exisitr usuário
  Future<void> _handlePlayPause() async {
    if (_isFinalizado) return ;

    if (_isRunning) {
      final success = await tempo_materia_service.pausarSessao(_tempoMateriaId!);
      print("pausou");
      if (success) _stopTimer();
    } else {
      if (_tempoMateriaId == null) {
        final id = await tempo_materia_service.iniciarSessao(widget.materia);
        setState(() {
          _tempoMateriaId = id;
          _inicioSessao = DateTime.now();
          print("começar sessao");
        });

      } else {
        await tempo_materia_service.continuarSessao(_tempoMateriaId!);
        print("Continuar");
      }
      _startTimer();
    }
  }

  Future<void> _handleFinalizar() async {
    if (_tempoMateriaId == null || _isFinalizado) return;
    final success = await tempo_materia_service.finalizarSessao(_tempoMateriaId!);
    if (success) {
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
              builder: (context) => MateriasDetailsScreen(materia: widget.materia),
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
                child: Text(widget.materia.nome, style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
                IconButton(
                  onPressed: () {
                    print("Clicou no botão, isRunning=$_isRunning");
                    _handlePlayPause();
                  },
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onTertiary,
                      size: 32),
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
                            child: InkWell(onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CriarMetaScreen(),
                                  ),
                              );
                            }, child: Row(
                              children: [
                                Icon(Icons.add,
                                    color: Theme.of(context).colorScheme.onTertiary,
                                    size: 32),
                                Text('Adicionar Meta',
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
                            )
                        ],
                      ),
                      ]
                  )
          ),
        ),
      );
  }
}