import 'package:endeavor/services/materia_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';

import '../../models/materia.dart';
import '../../models/meta.dart';
import '../../services/meta_service.dart';
import '../../widgets/materias/metas/meta_list.dart';

class MateriasDetailsScreen extends StatefulWidget {
  final String materiaId;

  const MateriasDetailsScreen({super.key, required this.materiaId});

  @override
  State<MateriasDetailsScreen> createState() => _MateriasDetailsScreenState();
}

class _MateriasDetailsScreenState extends State<MateriasDetailsScreen> {
  late Materia _materia;
  late Future<List<Meta>> _metasFuture;

  @override
  void initState() {
    super.initState();
    getMateriaById(widget.materiaId).then((value) => _materia = value);
    _metasFuture = getMetas();
  }

  void _reloadMaterias() {
    setState(() {
      _metasFuture = getMetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: EndeavorTopBar(title: "Matéria", hideLogo: true),
      body: FutureBuilder<List<Meta>>(
        future: _metasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar matéria: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadMaterias,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final metas = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Text(
                    _materia.nome,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 2,
                  ),
                  child: Text(
                    'Tempo acumulado de estudo: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 2,
                  ),
                  child: Text(
                    _materia.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 2,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/materias/criar",
                        ).then((_) => _reloadMaterias()); // atualiza ao voltar
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Adicionar Meta',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 16),
                Expanded(child: MetaList(lista: metas)),
              ],
            );
          } else {
            return const Center(child: Text('Nenhuma meta encontrada.'));
          }
        },
      ),
      bottomNavigationBar: const EndeavorBottomBar(),
    );
  }
}
