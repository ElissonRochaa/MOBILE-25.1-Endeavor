import 'package:endeavor/widgets/estatisticas/dropdown_button_periodo.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Estatisticasscreen extends StatelessWidget {
  final String? nome;

  const Estatisticasscreen({super.key, this.nome});

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
                        Text("16 dias conssecutivos!", style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),)
                      ]
                    ),
                    Image.asset("assets/flameLogo.png")
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
                  PeriodoDropdown(),
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
                            const dias = [
                              'S',
                              'T',
                              'Q',
                              'Q',
                              'S',
                              'S',
                              'D',
                            ];
                            return Text(
                              dias[value.toInt()],
                              style: const TextStyle(color: Colors.black),
                            );
                          },
                          interval: 1,
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(toY: 5, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 7, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 6, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 4, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 3, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(toY: 8, color: Colors.black, width: 12)
                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(toY: 2, color: Colors.black, width: 12)
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
