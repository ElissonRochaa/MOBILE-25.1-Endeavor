import 'package:endeavor/widgets/geral/endeavorTopBar.dart';
import 'package:flutter/material.dart';

class Estatisticasscreen extends StatelessWidget {
  final String? nome;

  const Estatisticasscreen({super.key, this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Estatísticas"),
      body: Center(
        child: Text('Estatísticas', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
