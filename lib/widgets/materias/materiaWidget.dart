import 'package:endeavor/config/themeApp.dart';
import 'package:flutter/material.dart';

class MateriaWidget extends StatefulWidget {
  final String nome;
  String descricao;

  MateriaWidget({super.key, required this.nome, this.descricao = ""});

  @override
  State<MateriaWidget> createState() => _CronometroState();
}

class _CronometroState extends State<MateriaWidget> {
  int _cronometro = 0;

  void _comecarCronometro() {
    setState(() {
      // Inicia o cronômetro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 117,
      width: 344,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.tertiary
      ),
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.nome, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Nunito')),
          Text(widget.descricao, style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.normal)),
        ],
      )
    );
  }
}