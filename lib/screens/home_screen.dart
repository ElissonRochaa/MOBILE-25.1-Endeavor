import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/home/areas_estudo.dart';
import 'package:endeavor/widgets/home/grupo_list.dart';
import 'package:endeavor/widgets/home/label.dart';
import 'package:endeavor/widgets/home/materia_list.dart';
import 'package:endeavor/widgets/home/search_bar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String usuarioId = dotenv.env["USUARIO_ID"]!;

class HomeScreen extends StatefulWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              onSeeAll: () => Navigator.of(context).pushNamed('/materias'),

              onAdd: () {
                Navigator.of(context).pushNamed('/materias/criar');
              },
            ),
            MateriaList(),
            SizedBox(height: 40),
            Label(
              title: "Meus grupos",
              onAdd: () async {
                final grupoCriado = await Navigator.of(
                  context,
                ).pushNamed('/grupos/criar');

                if (grupoCriado != null) {
                  setState(() {});
                }
              },
              onSeeAll: () => Navigator.of(context).pushNamed('/grupos'),
            ),
            GrupoList(getFn: () => getGruposFromUsuario(usuarioId)),
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
