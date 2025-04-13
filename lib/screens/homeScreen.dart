import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo')),
      body: Center(
        child: Text('Olá, $nome!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
