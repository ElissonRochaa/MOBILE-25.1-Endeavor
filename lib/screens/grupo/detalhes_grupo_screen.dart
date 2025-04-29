import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/geral/endeavorBottomBar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';

class DetalhesGrupoScreen extends StatefulWidget {
  final String grupoId;
  const DetalhesGrupoScreen({super.key, required this.grupoId});

  @override
  State<DetalhesGrupoScreen> createState() => _DetalhesGrupoScreenState();
}

class _DetalhesGrupoScreenState extends State<DetalhesGrupoScreen> {
  Grupo? _grupo;

  void loadDetalhesGrupo() async {
    final grupoCarregado = await grupo_service.getGrupoById(widget.grupoId);
    setState(() {
      _grupo = grupoCarregado;
    });
  }

  @override
  void initState() {
    loadDetalhesGrupo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("Não foi possivel localizar as informações do grupo"),
    );

    if (_grupo != null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Text(
              _grupo!.titulo,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              "Informações do grupo",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(_grupo!.descricao),
            const SizedBox(height: 64),
            Text(
              "Estudando 04/10",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: EndeavorTopBar(title: "Endeavor"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: content,
    );
  }
}
