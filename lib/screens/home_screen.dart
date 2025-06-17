import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/services/materia_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/home/areas_estudo.dart';
import 'package:endeavor/widgets/home/grupo_list.dart';
import 'package:endeavor/widgets/home/label.dart';
import 'package:endeavor/widgets/home/materia_list.dart';
import 'package:endeavor/widgets/home/search_bar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String usuarioId;
  late String token;

  @override
  void initState() {
    usuarioId = ref.read(authProvider).id!;
    token = ref.read(authProvider).token!;
    super.initState();
  }
  
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
            MateriaList(getFn: () => buscarMateriasPorUsuario(usuarioId, token),),
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
            GrupoList(getFn: () => getGruposFromUsuario(usuarioId, token)),
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
