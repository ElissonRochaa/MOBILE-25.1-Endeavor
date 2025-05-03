import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/membro.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/membros/membro_list.dart';
import 'package:flutter/material.dart';

class DetalhesGrupoScreen extends StatefulWidget {
  final String grupoId;
  const DetalhesGrupoScreen({super.key, required this.grupoId});

  @override
  State<DetalhesGrupoScreen> createState() => _DetalhesGrupoScreenState();
}

class _DetalhesGrupoScreenState extends State<DetalhesGrupoScreen> {
  late Future<Grupo?> _grupoFuture;
  late Future<List<Membro>> _membrosFuture;

  @override
  void initState() {
    super.initState();
    _grupoFuture = grupo_service.getGrupoById(widget.grupoId);
    _membrosFuture = grupo_service.getMembrosDoGrupo(widget.grupoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Endeavor", hideLogo: true),
      bottomNavigationBar: EndeavorBottomBar(),
      body: FutureBuilder<Grupo?>(
        future: _grupoFuture,
        builder: (context, grupoSnapshot) {
          if (grupoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (grupoSnapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar grupo: ${grupoSnapshot.error}"),
            );
          } else if (!grupoSnapshot.hasData || grupoSnapshot.data == null) {
            return const Center(child: Text("Grupo não encontrado."));
          }

          final grupo = grupoSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grupo.titulo,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Informações do grupo",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(grupo.descricao),
                const SizedBox(height: 64),
                Text(
                  "Estudando 04/10",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Membro>>(
                    future: _membrosFuture,
                    builder: (context, membroSnapshot) {
                      if (membroSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (membroSnapshot.hasError) {
                        return Center(
                          child: Text(
                            "Erro ao carregar membros: ${membroSnapshot.error}",
                          ),
                        );
                      } else if (!membroSnapshot.hasData ||
                          membroSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Nenhum membro encontrado."),
                        );
                      }

                      return MembroList(membros: membroSnapshot.data!);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
