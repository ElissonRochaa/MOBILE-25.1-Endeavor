import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';

class CriarMetaScreen extends StatelessWidget {
  const CriarMetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Criar Meta"),
      body: Center(
        child: Column(
          children: [

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Nome da meta",
                  hintStyle: TextStyle(color: Colors.black54),
                )
              ),
            ),

            Padding(
              padding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Descrição",
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EndeavorBottomBar(),
    );
  }
}
