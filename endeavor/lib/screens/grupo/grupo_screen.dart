import 'package:endeavor/screens/grupo/criar_grupo_screen.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/grupo/grupo_list.dart';
import 'package:flutter/material.dart';

import '../../models/grupo.dart';

class GrupoScreen extends StatefulWidget {
  const GrupoScreen({super.key});

  @override
  State<GrupoScreen> createState() => _GrupoScreenState();
}

class _GrupoScreenState extends State<GrupoScreen> {
  late Future<List<Grupo>> _gruposFuture;

  @override
  void initState() {
    super.initState();
    _gruposFuture = grupo_service.getGrupos();
  }

  void _reloadGrupos() {
    setState(() {
      _gruposFuture = grupo_service.getGrupos();
    });
  }

  void _navigateToCriarGrupo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CriarGrupoScreen()),
    );

    if (result == true) {
      _reloadGrupos();
      sucessoHandler();
    }
  }

  void sucessoHandler() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grupo criado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Meus Grupos"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: FutureBuilder<List<Grupo>>(
        future: _gruposFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final grupos = snapshot.data!;
            return GrupoList(lista: grupos);
          } else {
            return const Center(child: Text('Nenhum grupo encontrado.'));
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: const CircleBorder(),
          onPressed: _navigateToCriarGrupo,
          child: const Icon(Icons.add, size: 36),
        ),
      ),
    );
  }
}
