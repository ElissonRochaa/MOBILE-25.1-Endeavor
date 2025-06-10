import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/materia.dart';
import 'package:endeavor/models/tempo_materia.dart';
import 'package:endeavor/models/usuario.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/services/materia_service.dart';
import 'package:endeavor/services/tempo_materia_service.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/perfil/materia_box.dart';
import 'package:endeavor/widgets/perfil/number_box.dart';
import 'package:endeavor/widgets/perfil/perfil_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

final String usuarioId = dotenv.env["USUARIO_ID"]!;

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String dropdownValue = "diario";
  Usuario? _usuario;
  List<Grupo> _gruposUsuario = [];
  List<Materia> _materias = [];
  List<TempoMateria> _tempoMaterias = [];

  @override
  void initState() {
    super.initState();
    getGruposFromUsuario(usuarioId).then((value) {
      setState(() {
        _gruposUsuario = value;
      });
    });
    buscarUsuarioPorId(usuarioId).then((value) {
      setState(() {
        _usuario = value;
      });
    });
    buscarMateriasPorUsuario(usuarioId).then((value) {
      setState(() {
        _materias = value;
      });
    });
    buscarSessoesDeHojePorUsuario(usuarioId).then((value) {
      setState(() {
        _tempoMaterias = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Perfil"),
      bottomNavigationBar: const EndeavorBottomBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PerfilBanner(usuario: _usuario),
              Divider(
                color: Theme.of(context).colorScheme.surface,
                thickness: 1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberBox(
                      title: "Grupos",
                      value: _gruposUsuario.length.toString(),
                    ),
                    const SizedBox(width: 24),
                    NumberBox(
                      title: "Materias",
                      value: _materias.length.toString(),
                    ),
                  ],
                ),
              ),
              Text(
                _tempoMaterias.isNotEmpty
                    ? "Matéria mais estudada: ${getMateriaById(_tempoMaterias[0].materiaId)}"
                    : "Nenhuma matéria registrada hoje",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
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
                    Text(
                      "Tempo de estudo por matéria",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    DropdownButton(
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      value: dropdownValue,
                      items: [
                        DropdownMenuItem(
                          value: "diario",
                          child: Text("Diário"),
                        ),
                        DropdownMenuItem(
                          value: "semanal",
                          child: Text("Semanal"),
                        ),
                        DropdownMenuItem(
                          value: "mensal",
                          child: Text("Mensal"),
                        ),
                      ],
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
                  ..._tempoMaterias.map((tMateria) async {
                    return MateriaBox(
                      materia: await getMateriaById(tMateria.materiaId).then((value) => value.nome),
                      tempo: tMateria.tempoTotalAcumulado.toString(),
                    );
                  } as Widget Function(TempoMateria e)),

                  InkWell(
                    onTap:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        ),
                    child: Container(
                      width: 330,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF373737),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Desconectar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
