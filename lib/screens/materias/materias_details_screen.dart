import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/materias/metas/meta_list.dart';
import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../models/meta.dart';
import '../../services/meta_service.dart' as meta_service;
import 'criar_meta.dart';

class MateriasDetailsScreen extends StatefulWidget {
  final Materia materia;

  const MateriasDetailsScreen({super.key, required this.materia});

  @override
  State<MateriasDetailsScreen> createState() => _MateriasDetailsScreenState();
  }

class _MateriasDetailsScreenState extends State<MateriasDetailsScreen> {
  late Future<List<Meta>> _materiasFuture;

  @override
  void initState() {
    super.initState();
    _materiasFuture = meta_service.getMetas();
  }

  void _reloadMaterias() {
    setState(() {
      _materiasFuture = meta_service.getMetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: EndeavorTopBar(title: "Matéria"),
      body: FutureBuilder<List<Meta>>(
        future: _materiasFuture,
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
            final materia = widget.materia;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Text(
                    materia.nome,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                  child: Text(
                    materia.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CriarMetaScreen(),
                          ),
                        ).then((_) => _reloadMaterias()); // atualiza ao voltar
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: Colors.black, size: 28),
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
                Expanded(child: MetaList(lista: snapshot.data!)),
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
