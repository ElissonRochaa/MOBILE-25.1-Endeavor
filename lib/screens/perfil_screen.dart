import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/materia.dart';
import 'package:endeavor/models/usuario.dart';
import 'package:endeavor/providers/auth_provider.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  Usuario? _usuario;
  late String usuarioId;
  late String token;
  String dropdownValue = "diario";
  List<Grupo> _gruposUsuario = [];
  List<Materia> _materias = [];
  List<Map<String, dynamic>> _tempoMateriaComNome = [];
  String? _materiaMaisEstudada;
  int _tempoTotalHoje = 0;

  @override
  void initState() {
    super.initState();
    usuarioId = ref.read(authProvider).id!;
    token = ref.read(authProvider).token!;
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await Future.wait([
      _carregarUsuario(),
      _carregarGrupos(),
      _carregarMaterias(),
      _carregarTempoMaterias(),
    ]);
  }

  Future<void> _carregarUsuario() async {
    final usuario = await buscarUsuarioPorId(usuarioId, token);
    setState(() {
      _usuario = usuario;
    });
  }

  Future<void> _carregarGrupos() async {
    final grupos = await getGruposFromUsuario(usuarioId, token);
    setState(() {
      _gruposUsuario = grupos;
    });
  }

  Future<void> _carregarMaterias() async {
    final materias = await buscarMateriasPorUsuario(usuarioId, token);
    setState(() {
      _materias = materias;
    });
  }

  Future<void> _carregarTempoMaterias() async {
    final sessoes = await buscarSessoesDeHojePorUsuario(usuarioId, token);

    Map<String, int> tempoPorMateria = {};

    for (var sessao in sessoes) {
      final materia = await getMateriaById(sessao.materiaId, token);

      final nomeMateria = materia.nome;

      tempoPorMateria.update(
        nomeMateria,
        (valorAtual) => valorAtual + sessao.tempoTotalAcumulado,
        ifAbsent: () => sessao.tempoTotalAcumulado,
      );
    }

    final listaOrdenada =
        tempoPorMateria.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      _tempoMateriaComNome =
          listaOrdenada
              .map((e) => {'materiaNome': e.key, 'tempo': e.value})
              .toList();

      _materiaMaisEstudada =
          listaOrdenada.isNotEmpty ? listaOrdenada.first.key : 'Nenhuma';
    });
    _tempoTotalHoje = tempoPorMateria.values.fold(
      0,
      (sum, value) => sum + value,
    );
  }

  String _formatarTempo(int segundos) {
    final duracao = Duration(seconds: segundos);
    final horas = duracao.inHours.toString().padLeft(2, '0');
    final minutos = (duracao.inMinutes % 60).toString().padLeft(2, '0');
    final segundosRestantes = (duracao.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    return '$horas:$minutos:$segundosRestantes';
  }

  @override
  Widget build(BuildContext context) {
    if (_usuario == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: EndeavorTopBar(title: "Perfil"),
      bottomNavigationBar: const EndeavorBottomBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PerfilBanner(
                usuario: _usuario!,
                tempoTotal: _formatarTempo(_tempoTotalHoje),
              ),
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
                      onTap: () => Navigator.pushNamed(context, "/grupos"),
                    ),
                    const SizedBox(width: 24),
                    NumberBox(
                      title: "Matérias",
                      value: _materias.length.toString(),
                      onTap: () => Navigator.pushNamed(context, "/materias"),
                    ),
                  ],
                ),
              ),
              Text(
                _tempoMateriaComNome.isNotEmpty
                    ? "Matéria mais estudada: $_materiaMaisEstudada"
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ...(_tempoMateriaComNome.isNotEmpty
                      ? _tempoMateriaComNome.map((item) {
                        return MateriaBox(
                          materia: item['materiaNome'],
                          tempo: _formatarTempo(item['tempo']),
                        );
                      }).toList()
                      : [
                        const Text(
                          "Nenhuma matéria estudada",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ]),
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
                        color: const Color(0xFF373737),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
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
