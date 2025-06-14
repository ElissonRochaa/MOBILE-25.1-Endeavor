import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/materias/materia_list.dart';
import 'package:flutter/material.dart';

import '../../models/materia.dart';
import '../../services/materia_service.dart';

class MateriasScreen extends StatefulWidget {
  const MateriasScreen({super.key});

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  late Future<List<Materia>> _materiasFuture;

  @override
  void initState() {
    super.initState();
    _materiasFuture = buscarMateriasPorUsuario(usuarioId);
  }

  void _reloadMaterias() {
    setState(() {
      _materiasFuture = buscarMateriasPorUsuario(usuarioId);
    });
  }

  void _navigateToCriarMateria() async {
    final result = await Navigator.pushNamed(context, "/materias/criar");

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
      appBar: EndeavorTopBar(title: "Matérias"),
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
