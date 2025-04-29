import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/screens/criar_grupo_screen.dart';
import 'package:endeavor/widgets/geral/endeavorBottomBar.dart';
import 'package:endeavor/widgets/geral/endeavorTopBar.dart';
import 'package:endeavor/widgets/grupo/grupo_list.dart';
import 'package:flutter/material.dart';

class GrupoScreen extends StatelessWidget {
  const GrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Meus Grupos"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: GrupoList(
        lista: [
          Grupo(
            id: "123",
            titulo: "dummy",
            descricao: "teste de um  dummy",
            capacidade: 5,
            membros: 2,
            privado: true,
            areasEstudo: ["Matemática", "Português", "aaaaaa"],
          ),
          Grupo(
            id: "123",
            titulo: "dummy",
            descricao: "teste de um  dummy",
            capacidade: 5,
            membros: 2,
            privado: true,
            areasEstudo: ["Matemática", "Português", "aaaaaa"],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CriarGrupoScreen()),
          );
        },
        child: Icon(Icons.add, size: 36),
      ),
    );
  }
}
