import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/widgets/grupo/grupo_item.dart';
import 'package:flutter/material.dart';

class GrupoList extends StatelessWidget {
  final List<Grupo> lista;

  const GrupoList({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: const Text(
        "Você não possui nenhum  grupo, experimente entrar em um ou criar seu próprio!",
      ),
    );

    if (lista.isNotEmpty) {
      content = ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return GrupoItem(grupoData: lista[index]);
        },
      );
    }

    return content;
  }
}
