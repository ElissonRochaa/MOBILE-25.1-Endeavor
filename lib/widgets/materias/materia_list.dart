import 'package:flutter/material.dart';
import '../../models/materia.dart';
import 'materia_item.dart';

class MateriaList extends StatelessWidget {
  final List<Materia> lista;

  const MateriaList({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: const Text(
        "Você não possui nenhuma matéria, experimente criar uma!",
      ),
    );

    if (lista.isNotEmpty) {
      content = ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return MateriaItem(materia: lista[index]);
        },
      );
    }

    return content;
  }
}
