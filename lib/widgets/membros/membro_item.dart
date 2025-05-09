import 'dart:async';

import 'package:endeavor/models/membro.dart';
import 'package:endeavor/widgets/membros/info_box.dart';
import 'package:flutter/material.dart';

class MembroItem extends StatefulWidget {
  final Membro membroDetails;
  const MembroItem({super.key, required this.membroDetails});

  @override
  State<MembroItem> createState() => _MembroItemState();
}

class _MembroItemState extends State<MembroItem> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corCard =
        widget.membroDetails.isAtivo
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.tertiary;
    final corInterna =
        widget.membroDetails.isAtivo
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.tertiaryContainer;
    final isAtivo = widget.membroDetails.isAtivo;
    return Card(
      color: corCard,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListTile(
          title: Text(
            widget.membroDetails.nome,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Image.asset(
                fit: BoxFit.contain,
                height: 50,
                widget.membroDetails.isAtivo
                    ? "assets/membro_estudando.png"
                    : "assets/membro_relaxando.png",
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 8,
                children: [
                  InfoBox(
                    corBackground: corInterna,
                    isAtivo: isAtivo,
                    titulo: "Matéria",
                    data: widget.membroDetails.materia,
                  ),
                  InfoBox(
                    corBackground: corInterna,
                    isAtivo: isAtivo,
                    titulo: "Total",
                    data: widget.membroDetails.tempoEstudoFormatado(),
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
}
