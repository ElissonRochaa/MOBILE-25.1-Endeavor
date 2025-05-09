import 'package:endeavor/screens/login_screen.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/perfil/materia_box.dart';
import 'package:endeavor/widgets/perfil/number_box.dart';
import 'package:endeavor/widgets/perfil/perfil_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String dropdownValue = "diario";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const EndeavorTopBar(title: "Perfil"),
      bottomNavigationBar: const EndeavorBottomBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PerfilBanner(),
              Divider(
                color: Theme.of(context).colorScheme.surface,
                thickness: 1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberBox(title: "Grupos", value: "12"),
                    const SizedBox(width: 24),
                    NumberBox(title: "Materias", value: "28"),
                  ],
                ),
              ),
              Text(
                "Matéria mais estudada: Matemática",
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.surface,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tempo de estudo por matéria", style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),),
                    DropdownButton(
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      value: dropdownValue,
                      items: [DropdownMenuItem(value: "diario", child: Text("Diário")),
                      DropdownMenuItem(value: "semanal" ,child: Text("Semanal")),
                      DropdownMenuItem(value: "mensal" , child: Text("Mensal")),],
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
                  Column(
                  children: [
                    const MateriaBox(materia: "Matemática", tempo: "2 horas e 16 minutos"),
                    const MateriaBox(materia: "Física", tempo: "1 hora e 30 minutos"),
                    const MateriaBox(materia: "Química", tempo: "30 minutos"),
                    InkWell(
                      onTap:  () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),)),
                      child: Container(
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF373737),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("Desconectar",textAlign: TextAlign.center , style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
