import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/widgets/membros/membro_item.dart';
import 'package:flutter/material.dart';

class MembroList extends StatelessWidget {
  final List<MembroComTempo> membros;
  const MembroList({super.key, required this.membros});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: membros.length,
        itemBuilder:
            (context, index) => MembroItem(membroDetails: membros[index]),
      ),
    );
  }
}
