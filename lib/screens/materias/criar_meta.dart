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

          ],
        ),
      ),
      bottomNavigationBar: EndeavorBottomBar(),
    );
  }
}
