import 'package:flutter/material.dart';

import '../../../models/meta.dart';
import 'meta_item.dart';

class MetaList extends StatelessWidget {
  final List<Meta> lista;

  const MetaList({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: const Text(
        "Você não possui nenhuma meta, experimente criar uma!",
      ),
    );

    if (lista.isNotEmpty) {
      content = ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return MetaItem(meta: lista[index]);
        },
      );
    }

    return content;
  }
}
