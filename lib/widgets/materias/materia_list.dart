import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../geral/search_bar.dart';
import 'materia_item.dart';

class MateriaList extends StatefulWidget {
  final List<Materia> lista;

  const MateriaList({super.key, required this.lista});

  @override
  State<MateriaList> createState() => _MateriaListState();
}

class _MateriaListState extends State<MateriaList> {
  String busca = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Materia> materiasFiltradas = widget.lista
        .where((materia) =>
        materia.nome.toLowerCase().contains(busca.toLowerCase()))
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SearchFilterBar(
              controller: _searchController,
              onSearch: (value) {
                setState(() {
                  busca = value.trim();
                });
              },
            ),
          ),
        ),
        Expanded(
          child: materiasFiltradas.isEmpty
              ? Center(
            child: Text(
              "Nenhuma matéria ${busca.isNotEmpty ? "chamada '$busca'" : ''} foi encontrada.",
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: materiasFiltradas.length,
            itemBuilder: (context, index) {
              return MateriaItem(materia: materiasFiltradas[index]);
            },
          ),
        ),
      ],
    );
  }
}
