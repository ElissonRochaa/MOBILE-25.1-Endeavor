import 'package:endeavor/models/grupo.dart';
import 'package:flutter/material.dart';
import '../../services/grupo_service.dart' as grupo_service;
import '../../services/area_estudo.dart' as area_service;

import '../login_screen.dart';

const areasDeEstudo = ["Tecnologia", "Ciências", "Culinária"];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _areaSelecionada;
  Grupo? _grupoSelecionado;
  List<Grupo> _grupos = [];
  int passo = 0;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
  }

  void _avancarPasso() async {
    if (passo == 0 && _areaSelecionada != null) {
      setState(() {
        carregando = true;
      });

      print(_areaSelecionada);
      final area = await area_service.findAreaEstudoByNome(_areaSelecionada!);
      print(area.first.id);
      final grupos = await grupo_service.getGrupoByAreaEstudo(area.first.id).catchError((error) => print(error));

      setState(() {
        _grupos = grupos;
        passo = 1;
        carregando = false;
        _grupoSelecionado = null;
      });
    } else if (passo == 1 && _grupoSelecionado != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selecionado = passo == 0 ? _areaSelecionada : _grupoSelecionado?.titulo;
    final opcoes = passo == 0
        ? areasDeEstudo
        : _grupos.map((g) => g.titulo).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        surfaceTintColor: Colors.transparent,
        leading: passo > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              passo = 0;
              _grupoSelecionado = null;
            });
          },
        )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  Image.asset("assets/flameLogo.png", width: 300),
                  const Text(
                    "Endeavor",
                    style: TextStyle(fontSize: 48, fontFamily: 'BebasNeue'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                passo == 0
                    ? "Qual área você mais se interessa?"
                    : "Escolha um grupo de estudo em $_areaSelecionada",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (carregando)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: opcoes.length,
                  itemBuilder: (context, index) {
                    final item = opcoes[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (passo == 0) {
                            _areaSelecionada = item;
                          } else {
                            _grupoSelecionado = _grupos[index];
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                          Theme.of(context).colorScheme.tertiary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiary,
                              ),
                            ),
                            Radio<String>(
                              value: item,
                              groupValue: selecionado,
                              onChanged: (value) {
                                setState(() {
                                  if (passo == 0) {
                                    _areaSelecionada = value;
                                  } else {
                                    _grupoSelecionado = _grupos[index];
                                  }
                                });
                              },
                              activeColor:
                              Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            Center(
              child: InkWell(
                onTap:
                selecionado != null && !carregando ? _avancarPasso : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selecionado != null && !carregando
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  child: Text(
                    passo == 0 ? 'Continuar' : 'Finalizar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}