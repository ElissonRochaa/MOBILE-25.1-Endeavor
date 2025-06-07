import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/screens/grupo/detalhes_grupo_screen.dart';
import 'package:endeavor/widgets/home/card_grupo.dart';
import 'package:flutter/material.dart';

class GrupoList extends StatelessWidget {
  const GrupoList({super.key, required this.getFn});

  final Future<List<Grupo>> Function() getFn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: 70,
      child: FutureBuilder(
        future: getFn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum grupo encontrado'));
          }

          final grupos = snapshot.data!;
          return ListView.builder(
            itemCount: grupos.length,
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (ctx, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                DetalhesGrupoScreen(grupoId: grupos[index].id),
                      ),
                    );
                  },
                  child: CardGrupo(grupo: grupos[index]),
                ),
          );
        },
      ),
    );
  }
}
