import 'package:endeavor/widgets/estatisticas/dropdown_button_periodo.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/estatistica_service.dart';

class Estatisticasscreen extends StatefulWidget {
  final String? nome;

  const Estatisticasscreen({super.key, this.nome});

  @override
  State<Estatisticasscreen> createState() => _EstatisticasscreenState();
}

  class _EstatisticasscreenState extends State<Estatisticasscreen> {
  List<int> evolucaoSemanal = [];
  int diasConsecutivos = 0;
  Periodo periodoSelecionado = Periodo.dia;

  Duration definirIntervalo(Periodo periodo) {
    switch (periodo) {
      case Periodo.dia:
        return Duration(days: 6);
      case Periodo.semana:
        return Duration(days: 6);
      case Periodo.mes:
        return Duration(days: 365);
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

    final evolucao = await getEvolucao(
    usuarioId: "e1e78a67-7ba6-4ebb-9330-084da088037f",
    inicio: DateTime.now().subtract(definirIntervalo(periodoSelecionado)),
    fim: DateTime.now(),
    unidade: periodoToString(periodoSelecionado),
    intervalo: 1,

  );

  final strike = await getDiasConsecutivosDeEstudo(usuarioId: "e1e78a67-7ba6-4ebb-9330-084da088037f");

  setState(() {
    evolucaoSemanal = evolucao;
    diasConsecutivos = strike;
    });
  } catch (e) {
    print('Erro ao carregar estatísticas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Estatísticas"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Seu Strike", textAlign: TextAlign.left, style: TextStyle(fontSize: 20,)),
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
                      spacing: 24.0,
                      children: [
                        Text("Continue Assim!", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),),
                        Text("$diasConsecutivos dias conssecutivos!", style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),)
                      ]
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        
                      ),
                        child: Image.asset("assets/flameLogo.png")
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Estatísticas", textAlign: TextAlign.left, style: TextStyle(fontSize: 20,)),
                  PeriodoDropdown(
                    onChanged: (Periodo novoPeriodo) {
                      setState(() {
                        periodoSelecionado = novoPeriodo;
                      });
                      carregarEstatisticas();
                    },
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200,
                width: 340,
                child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              DateTime dataInicio = DateTime.now().subtract(definirIntervalo(periodoSelecionado));
                              DateTime dia = dataInicio.add(Duration(days: index));

                              if (value.toInt() < evolucaoSemanal.length) {
                                switch (periodoSelecionado) {
                                  case Periodo.dia:
                                    DateTime dataAtual = dataInicio.add(Duration(days: value.toInt()));
                                    String dia = '${dataAtual.day}';
                                    return Text(dia, style: const TextStyle(color: Colors.black));

                                  case Periodo.semana:
                                    DateTime dia = DateTime.now().subtract(Duration(days: evolucaoSemanal.length - index - 1));
                                    const diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                                    return Text(diasSemana[dia.weekday - 1], style: TextStyle(color: Colors.black));

                                  case Periodo.mes:
                                    const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
                                    return Text(meses[index % 12], style: TextStyle(color: Colors.black));
                                }
                              }
                              return const SizedBox.shrink();
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      barGroups: evolucaoSemanal.asMap().entries.map((entry) {
                        int idx = entry.key;
                        int valor = entry.value;
                        return BarChartGroupData(
                          x: idx,
                          barRods: [
                            BarChartRodData(
                              toY: valor.toDouble(),
                              color: Colors.black,
                              width: 12,
                            ),
                          ],
                        );
                      }).toList(),
                    )
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

}
