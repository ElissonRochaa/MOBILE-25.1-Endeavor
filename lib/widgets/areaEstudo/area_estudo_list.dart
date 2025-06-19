import 'package:endeavor/models/area_estudo.dart';
import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/screens/grupo_modal_screen.dart';
import 'package:endeavor/services/area_estudo_service.dart';
import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/widgets/geral/label.dart';
import 'package:endeavor/widgets/home/areas_estudo.dart';
import 'package:flutter/material.dart';

class AreasEstudoList extends StatefulWidget {
  final String token;

  const AreasEstudoList({super.key, required this.token});

  @override
  State<AreasEstudoList> createState() => _AreasEstudoListState();
}

class _AreasEstudoListState extends State<AreasEstudoList> {
  late Future<List<AreaEstudo>> futureAreas;
  late Future<List<Grupo>> futureGrupos;
  late Future<(List<AreaEstudo>, List<Grupo>)> futureDados;

  @override
  void initState() {
    super.initState();
    futureDados = Future.wait([
      getAreasEstudo(widget.token),
      getGrupos(widget.token),
    ]).then(
      (values) => (values[0] as List<AreaEstudo>, values[1] as List<Grupo>),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(List<AreaEstudo>, List<Grupo>)>(
      future: futureDados,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Nenhum dado encontrado'));
        }

        final (areas, grupos) = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Label(title: "Áreas de estudo"),
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 200,
              child: ListView.builder(
                itemCount: areas.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  final area = areas[index];
                  final gruposDaArea =
                      grupos
                          .where(
                            (g) => g.areasEstudo.any((a) => a.id == area.id),
                          )
                          .toList();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (ctx) => GrupoModalScreen(
                                lista: gruposDaArea,
                                titulo: 'Grupos de ${area.nome}',
                              ),
                        ),
                      );
                    },
                    child: AreasEstudo(nome: area.nome),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
