import 'package:endeavor/screens/grupo/criar_grupo_screen.dart';
import 'package:endeavor/screens/grupo/grupo_screen.dart';
import 'package:endeavor/screens/materias/criar_meta.dart';
import 'package:endeavor/screens/materias/materias_screen.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/home/grupo_list.dart';
import 'package:endeavor/widgets/home/areas_estudo.dart';
import 'package:endeavor/widgets/home/label.dart';
import 'package:endeavor/widgets/home/materia_list.dart';
import 'package:endeavor/widgets/home/search_bar_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Endeavor"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            SearchBarHome(),
            Label(
              title: "Minhas matérias",
              onSeeAll:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MateriasScreen()),
                  ),
              onAdd: () {}
            ),
            MateriaList(),
            SizedBox(height: 40),
            Label(
              title: "Meus grupos",
              onAdd:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CriarGrupoScreen()),
                  ),
              onSeeAll:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GrupoScreen()),
                  ),
            ),
            GrupoList(),
            SizedBox(height: 40),
            Label(title: "Áreas de estudo", onAdd: () {}, onSeeAll: () {}),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 140,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => AreasEstudo(nome: "Mobile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
