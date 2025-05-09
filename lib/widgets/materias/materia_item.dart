import 'dart:async';
import 'package:endeavor/screens/materias/criar_meta.dart';
import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../screens/materias/materias_details_screen.dart';

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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
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
                  if (_isRunning) {
                    _stopTimer();
                  } else {
                    _startTimer();
                  }
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