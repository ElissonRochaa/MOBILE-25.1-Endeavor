import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/materias/materiaWidget.dart';
import 'package:flutter/material.dart';

class MateriasScreen extends StatelessWidget {
  const MateriasScreen({super.key, listaMaterias});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Matérias"),
      body: Center(
        child: Column(
          children: [
            MateriaWidget(
              nome: "Flutter",
              descricao:
                  "Estudar flutter, olha o que Elisson faz a gente fazer",
            ),
          ],
        ),
      ),
      bottomNavigationBar: EndeavorBottomBar(),
    );
  }
}
