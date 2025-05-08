import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/perfil/materia_box.dart';
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
            const SizedBox(height: 24),
            Row(
              children: [
                NumberBox(title: "Grupos", value: "12"),
                const SizedBox(width: 24),
                NumberBox(title: "Materias", value: "28"),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Matéria mais estudada: Matemática",
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text("Tempo de estudo por matéria"),
                DropdownButton(
                  items: [DropdownMenuItem(child: Text("Diário")),
                  DropdownMenuItem(child: Text("Semanal")),
                  DropdownMenuItem(child: Text("Mensal")),],
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  const MateriaBox(materia: "Matemática", tempo: "2 horas e 16 minutos"),
                  const MateriaBox(materia: "Física", tempo: "1 hora e 30 minutos"),
                  const MateriaBox(materia: "Química", tempo: "30 minutos"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
