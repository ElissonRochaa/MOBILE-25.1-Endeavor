import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/perfil/number_box.dart';
import 'package:endeavor/widgets/perfil/perfil_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends StatelessWidget {

  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EndeavorTopBar(title: "Perfil"),
      bottomNavigationBar: const EndeavorBottomBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(child: PerfilBanner()),
            const SizedBox(height: 16),
            Row(
              children: [
                NumberBox(title: "Grupos", value: "12"),
                const SizedBox(width: 24),
                NumberBox(title: "Materias", value: "28"),
              ],
            )
          ],
        ),
      ),

      );
  }
}