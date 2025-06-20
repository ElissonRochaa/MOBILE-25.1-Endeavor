import 'package:endeavor/models/area_estudo.dart';
import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/services/area_estudo_service.dart';
import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/widgets/grupo/grupo_list.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _opcaoSelecionada;
  int passo = 0;

  List<AreaEstudo> areas = [];
  List<Grupo> grupos = [];
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarAreas();
  }

  Future<void> _carregarAreas() async {
    setState(() => carregando = true);
    try {
      areas = await getAreasEstudo("");
    } catch (e) {
      debugPrint('Erro ao buscar áreas: $e');
    }
    setState(() => carregando = false);
  }

  Future<void> _carregarGruposPorArea(String areaId) async {
    setState(() => carregando = true);
    try {
      grupos = await getGruposPorArea(areaId);
    } catch (e) {
      debugPrint('Erro ao buscar grupos: $e');
    }
    setState(() => carregando = false);
  }

  void _avancarPasso() async {
    if (passo == 0 && _opcaoSelecionada != null) {
      await _carregarGruposPorArea(_opcaoSelecionada!);
      setState(() {
        passo++;
      });
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final opcoes =
        passo == 0
            ? areas.map((a) => {'id': a.id, 'nome': a.nome}).toList()
            : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        surfaceTintColor: Colors.transparent,
        leading:
            passo > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      passo--;
                      _opcaoSelecionada = null;
                    });
                  },
                )
                : null,
      ),
      body:
          carregando
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child:
                    passo == 0
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: const Text(
                                  "Qual área você mais se interessa?",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: opcoes.length,
                                itemBuilder: (context, index) {
                                  final item = opcoes[index];
                                  return _buildOpcao(
                                    item['nome']!,
                                    item['id']!,
                                  );
                                },
                              ),
                            ),
                            _buildBotaoContinuar(),
                            _buildIndicador(),
                          ],
                        )
                        : Column(
                          children: [
                            _buildHeader(),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Grupos disponíveis nessa área",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: GrupoList(lista: grupos)),
                            _buildBotaoContinuar(),
                            _buildIndicador(),
                          ],
                        ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/flameLogo.png", width: 120, height: 120),
          const SizedBox(width: 12),
          const Text(
            "Endeavor",
            style: TextStyle(fontSize: 32, fontFamily: 'BebasNeue'),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcao(String nome, String id) {
    final selecionado = _opcaoSelecionada == id;
    return InkWell(
      splashColor: Theme.of(context).colorScheme.tertiary,
      onTap: () {
        setState(() {
          _opcaoSelecionada = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nome,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _opcaoSelecionada,
              onChanged: (value) {
                setState(() {
                  _opcaoSelecionada = value;
                });
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoContinuar() {
    return Center(
      child: InkWell(
        onTap: _opcaoSelecionada != null ? _avancarPasso : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                _opcaoSelecionada != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
          ),
          child: Text(
            passo < 1 ? 'Continuar' : 'Finalizar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicador() {
    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            final isSelected = index <= passo;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
