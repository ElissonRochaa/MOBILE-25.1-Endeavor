import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/materias/materia_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:endeavor/providers/auth_provider.dart';
import '../../models/materia.dart';
import '../../services/materia_service.dart';
import 'criar_materia.dart';

class MateriasScreen extends ConsumerStatefulWidget {
  const MateriasScreen({super.key});
  

  @override
  ConsumerState<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends ConsumerState<MateriasScreen> {
  late Future<List<Materia>> _materiasFuture;
  late String _token;

  @override
  void initState() {
    _token = ref.watch(authProvider).token!;
    super.initState();
    _materiasFuture = getMaterias(_token.toString());
  }

  void _reloadMaterias() {
    setState(() {
      _materiasFuture = getMaterias(_token.toString());
    });
  }

  void _navigateToCriarMateria() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CriarMateriaScreen()),
    );

    if (result == true) {
      _reloadMaterias();
      sucessoHandler();
    }
  }

  void sucessoHandler() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Matéria criada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Matérias",),
      bottomNavigationBar: EndeavorBottomBar(),
      body: FutureBuilder<List<Materia>>(
        future: _materiasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar matérias: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadMaterias,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return MateriaList(lista: snapshot.data!);
          } else {
            return const Center(child: Text('Nenhuma matéria encontrada.'));
          }
        },
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: const CircleBorder(),
          onPressed: _navigateToCriarMateria,
          child: const Icon(Icons.add, size: 36),
        ),
      ),

    );
  }
}