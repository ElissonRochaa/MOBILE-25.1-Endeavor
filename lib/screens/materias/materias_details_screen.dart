import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/materia_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/materia.dart';
import '../../models/meta.dart';
import '../../services/meta_service.dart';
import '../../widgets/materias/metas/meta_list.dart';
import 'criar_meta.dart';

class MateriasDetailsScreen extends ConsumerStatefulWidget {
  final String materiaId;

  const MateriasDetailsScreen({super.key, required this.materiaId});

  @override
  ConsumerState<MateriasDetailsScreen> createState() => _MateriasDetailsScreenState();
}

class _MateriasDetailsScreenState extends ConsumerState<MateriasDetailsScreen> {
  late Future<Materia> _materiaFuture;
  late Future<List<Meta>> _metasFuture;
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = ref.read(authProvider).token!;
    _materiaFuture = getMateriaById(widget.materiaId);
    _metasFuture = getMetaByMateria(widget.materiaId, _token);
  }

  void _reloadMaterias() {
    setState(() {
      _metasFuture = getMetaByMateria(widget.materiaId, _token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: EndeavorTopBar(title: "Matéria", hideLogo: true),
      body: FutureBuilder<Materia>(
        future: _materiaFuture,
        builder: (context, materiaSnapshot) {
          if (materiaSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (materiaSnapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar matéria: ${materiaSnapshot.error}'),
            );
          } else if (materiaSnapshot.hasData) {
            final materia = materiaSnapshot.data!;
            return FutureBuilder<List<Meta>>(
              future: _metasFuture,
              builder: (context, metasSnapshot) {
                if (metasSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (metasSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erro ao carregar metas: ${metasSnapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _reloadMaterias,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                } else if (metasSnapshot.hasData) {
                  final metas = metasSnapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: Text(
                          materia.nome,
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 2,
                        ),
                        child: Text(
                          materia.descricao,
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
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CriarMetaScreen(
                                            materiaId: materia.id,
                                          ),
                                    ),
                                  )
                                  .then((_) => _reloadMaterias());
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        height: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Expanded(child: MetaList(lista: metas)),
                    ],
                  );
                } else {
                  return const Center(child: Text('Nenhuma meta encontrada.'));
                }
              },
            );
          } else {
            return const Center(child: Text('Erro inesperado.'));
          }
        },
      ),
      bottomNavigationBar: const EndeavorBottomBar(),
    );
  }
}
