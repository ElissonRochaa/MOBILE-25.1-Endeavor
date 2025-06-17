import 'package:endeavor/widgets/estatisticas/dropdown_button_periodo.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/evolucao_model.dart';
import '../services/estatistica_service.dart';
import '../widgets/estatisticas/bar_chart.dart' as bar_chart;

final String usuarioId = dotenv.env["USUARIO_ID"]!;

class EstatisticasScreen extends StatefulWidget {
  final String? nome;

  const EstatisticasScreen({super.key, this.nome});

  @override
  State<EstatisticasScreen> createState() => _EstatisticasScreenState();
}

class _EstatisticasScreenState extends State<EstatisticasScreen> {
  List<EvolucaoModel> evolucao = [];
  int diasConsecutivos = 0;
  Periodo periodoSelecionado = Periodo.dia;

  Duration definirIntervalo(Periodo periodo) {
    switch (periodo) {
      case Periodo.dia:
        return Duration(days: 6);
      case Periodo.semana:
        return Duration(days: 6);
      case Periodo.mes:
        return DateTime.now().difference(
          DateTime.parse('${DateTime.now().year}-01-01'),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    carregarEstatisticas();
  }

  Future<void> carregarEstatisticas() async {
    try {
      String periodoToString(Periodo p) {
        switch (p) {
          case Periodo.dia:
            return "DAYS";
          case Periodo.semana:
            return "WEEKS";
          case Periodo.mes:
            return "MONTHS";
        }
      }

      final List<EvolucaoModel> evolucaoPeriodo = await getEvolucao(
        usuarioId: "e1e78a67-7ba6-4ebb-9330-084da088037f",
        inicio:
            periodoSelecionado == Periodo.mes
                ? DateTime.parse("${DateTime.now().year}-01-01")
                : DateTime.now().subtract(definirIntervalo(periodoSelecionado)),
        fim:
            periodoSelecionado == Periodo.mes
                ? DateTime.parse("${DateTime.now().year}-12-31")
                : DateTime.now(),
        unidade: periodoToString(periodoSelecionado),
        intervalo: 1,
      );

      final strike = await getDiasConsecutivosDeEstudo(usuarioId: usuarioId);

      setState(() {
        evolucao = evolucaoPeriodo;
        diasConsecutivos = strike;
      });
    } catch (e) {
      print('Erro ao carregar estatísticas: $e');
    }
  }

  List<String> gerarLabels(List<EvolucaoModel> evolucao) {
    return evolucao.map((e) {
      switch (periodoSelecionado) {
        case Periodo.dia:
          return '${e.data.day}';
        case Periodo.semana:
          return semana[e.data.weekday - 1];
        case Periodo.mes:
          return meses[e.data.month - 1];
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Estatísticas"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Seu Strike", style: TextStyle(fontSize: 20)),
            Text("Seu Strike", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Container(
              height: 140,
              width: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue Assim!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          "$diasConsecutivos dias consecutivos!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Image.asset("assets/flameLogo.png"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Estatísticas", style: TextStyle(fontSize: 20)),
                  PeriodoDropdown(
                    onChanged: (Periodo novoPeriodo) {
                      setState(() {
                        periodoSelecionado = novoPeriodo;
                      });
                      carregarEstatisticas();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200,
                width: 340,
                child: bar_chart.SimpleBarChart(
                  evolucao: evolucao,
                  animate: true,
                  labels: gerarLabels(evolucao),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> meses = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez',
];
const List<String> semana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
