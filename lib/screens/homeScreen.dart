import 'package:endeavor/widgets/geral/endeavorBottomBar.dart';
import 'package:endeavor/widgets/geral/endeavorTopBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Endeavor"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: Center(child: Text('Olá, $nome!', style: TextStyle(fontSize: 24))),
    );
  }
}
