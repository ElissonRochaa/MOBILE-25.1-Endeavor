import 'package:flutter/material.dart';

enum Periodo {
  dia,
  semana,
  mes,
}

class PeriodoDropdown extends StatefulWidget {
  const PeriodoDropdown({super.key});

  @override
  State<PeriodoDropdown> createState() => _PeriodoDropdownState();
}

class _PeriodoDropdownState extends State<PeriodoDropdown> {
  Periodo _selecionado = Periodo.dia;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFCAF0F8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Periodo>(
          value: _selecionado,
          dropdownColor: const Color(0xFFCAF0F8),
          focusColor: const Color(0xFFCAF0F8),
          onChanged: (Periodo? novoValor) {
            if (novoValor != null) {
              setState(() {
                _selecionado = novoValor;
              });
            }
          },
          items: Periodo.values.map((Periodo periodo) {
            return DropdownMenuItem<Periodo>(
              value: periodo,
              child: Text(_label(periodo)),
            );
          }).toList(),
        ),
      ),
    );
}

  String _label(Periodo periodo) {
    switch (periodo) {
      case Periodo.dia:
        return "Dia";
      case Periodo.semana:
        return "Semana";
      case Periodo.mes:
        return "Mês";
    }
  }
}
