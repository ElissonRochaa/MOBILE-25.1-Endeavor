import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
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
