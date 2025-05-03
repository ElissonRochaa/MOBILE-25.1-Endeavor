import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/widgets/grupo/grupo_item.dart';
import 'package:flutter/material.dart';

enum Ordenacao { nome, membros, privado }

class GrupoList extends StatefulWidget {
  final List<Grupo> lista;

  const GrupoList({super.key, required this.lista});

  @override
  State<GrupoList> createState() => _GrupoListState();
}

class _GrupoListState extends State<GrupoList> {
  String busca = "";
  Ordenacao ordenarPor = Ordenacao.nome;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Grupo> gruposFiltrados =
        widget.lista
            .where(
              (grupo) =>
                  grupo.titulo.toLowerCase().contains(busca.toLowerCase()),
            )
            .toList();

    gruposFiltrados.sort(
      (g1, g2) => switch (ordenarPor) {
        Ordenacao.membros => g2.membros.compareTo(g1.membros),
        Ordenacao.privado =>
          g1.privado == g2.privado ? 0 : (g1.privado ? 1 : -1),
        _ => g1.titulo.compareTo(g2.titulo),
      },
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SearchBar(
              controller: _searchController,
              elevation: WidgetStatePropertyAll(8),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.onTertiary,
              ),
              onSubmitted: (value) {
                String textoBusca = value.trim();
                if (textoBusca.isNotEmpty) {
                  setState(() {
                    busca = textoBusca;
                  });
                } else {
                  setState(() {
                    busca = "";
                  });
                }
              },
              trailing: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => _buildFilterOptions(),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    final textoBusca = _searchController.text.trim();
                    if (textoBusca.isNotEmpty) {
                      setState(() {
                        busca = textoBusca;
                      });
                    } else {
                      setState(() {
                        busca = "";
                      });
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child:
              gruposFiltrados.isEmpty
                  ? Center(
                    child: Text(
                      "Não foi encontrado nenhum grupo ${busca.isNotEmpty ? "chamado '$busca'" : ''}. Tente novamente!",
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: gruposFiltrados.length,
                    itemBuilder: (context, index) {
                      return GrupoItem(grupoData: gruposFiltrados[index]);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildFilterOptions() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Ordenar por nome"),
            leading: Radio<Ordenacao>(
              value: Ordenacao.nome,
              groupValue: ordenarPor,
              onChanged: (value) {
                setState(() {
                  ordenarPor = value!;
                  Navigator.pop(context);
                });
              },
            ),
            onTap: () {
              setState(() {
                ordenarPor = Ordenacao.nome;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            title: const Text("Ordenar por quantidade de membros"),
            leading: Radio<Ordenacao>(
              value: Ordenacao.membros,
              groupValue: ordenarPor,
              onChanged: (value) {
                setState(() {
                  ordenarPor = value!;
                  Navigator.pop(context);
                });
              },
            ),
            onTap: () {
              setState(() {
                ordenarPor = Ordenacao.membros;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            title: const Text("Ordenar por visibilidade"),
            leading: Radio<Ordenacao>(
              value: Ordenacao.privado,
              groupValue: ordenarPor,
              onChanged: (value) {
                setState(() {
                  ordenarPor = value!;
                  Navigator.pop(context);
                });
              },
            ),
            onTap: () {
              setState(() {
                ordenarPor = Ordenacao.privado;
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
