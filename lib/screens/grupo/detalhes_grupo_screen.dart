import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/membros/membro_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';

final apiUrl = dotenv.env['API_URL'];
final String usuarioId = dotenv.env["USUARIO_ID"]!;

class DetalhesGrupoScreen extends StatefulWidget {
  final String grupoId;
  final bool isConvite;

  const DetalhesGrupoScreen({
    super.key,
    required this.grupoId,
    this.isConvite = false,
  });

  @override
  State<DetalhesGrupoScreen> createState() => _DetalhesGrupoScreenState();
}

class _DetalhesGrupoScreenState extends State<DetalhesGrupoScreen> {
  late Future<Grupo?> _grupoFuture;
  late Future<List<MembroComTempo>> _membrosFuture;

  bool _navegarParaHome = false;

  @override
  void initState() {
    super.initState();
    _grupoFuture = grupo_service.getGrupoById(widget.grupoId);
    _membrosFuture = grupo_service.getMembrosDoGrupo(widget.grupoId);

    _grupoFuture.then((grupo) {
      if (grupo != null &&
          widget.isConvite &&
          !grupo.membrosIds.contains(usuarioId)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mostrarDialogConvite(grupo);
        });
      }
    });
  }

  void _mostrarDialogConvite(Grupo grupo) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Convite para grupo"),
            content: Text(
              "Você foi convidado para o grupo '${grupo.titulo}'. Deseja entrar?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Não"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await grupo_service.adicionarMembroAoGrupo(
                      grupo.id,
                      usuarioId,
                    );
                    if (!mounted) return;
                    grupo.membrosIds.add(usuarioId);
                    setState(() {
                      _membrosFuture = grupo_service.getMembrosDoGrupo(
                        widget.grupoId,
                      );
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("Sim, entrar"),
              ),
            ],
          ),
    );
  }

  void _abrirCompartilhamento() async {
    final link = "$apiUrl/abrir-grupo/${widget.grupoId}";
    final mensagem =
        "Olá! Junte-se a mim no meu grupo de estudos no Endeavor! $link";

    await SharePlus.instance.share(
      ShareParams(text: mensagem, subject: 'Convite para grupo de estudos'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_navegarParaHome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
      return const Scaffold();
    }

    return FutureBuilder<Grupo?>(
      future: _grupoFuture,
      builder: (context, grupoSnapshot) {
        if (grupoSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (grupoSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Erro ao carregar grupo: ${grupoSnapshot.error}"),
            ),
          );
        } else if (!grupoSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Grupo não encontrado.")),
          );
        }

        final grupo = grupoSnapshot.data!;

        final podeEntrarOuSair =
            !grupo.privado ||
            grupo.membrosIds.contains(usuarioId) ||
            widget.isConvite;

        return Scaffold(
          appBar: EndeavorTopBar(
            title: "Endeavor",
            hideLogo: true,
            icone:
                grupo.membrosIds.contains(usuarioId)
                    ? IconButton(
                      onPressed: _abrirCompartilhamento,
                      icon: const Icon(Icons.share, color: Colors.white),
                    )
                    : null,
          ),
          bottomNavigationBar: EndeavorBottomBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        grupo.titulo,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Icon(
                      grupo.privado
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Informações do grupo",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(grupo.descricao),
                const SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FutureBuilder<List<MembroComTempo>>(
                        future: _membrosFuture,
                        builder: (context, membroSnapshot) {
                          if (membroSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Estudando...");
                          } else if (membroSnapshot.hasError) {
                            return const Text(
                              "Erro ao carregar informações dos membros",
                            );
                          } else if (!membroSnapshot.hasData) {
                            return const Text("Estudando 0");
                          }

                          final membrosAtivos =
                              membroSnapshot.data!
                                  .where((m) => m.isAtivo)
                                  .length;

                          return Text(
                            "Estudando $membrosAtivos/${grupo.membros}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      "Capacidade: ${grupo.capacidade}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<MembroComTempo>>(
                    future: _membrosFuture,
                    builder: (context, membroSnapshot) {
                      if (membroSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (membroSnapshot.hasError) {
                        return Center(
                          child: Text(
                            "Erro ao carregar membros: ${membroSnapshot.error}",
                          ),
                        );
                      } else if (!membroSnapshot.hasData ||
                          membroSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Nenhum membro encontrado."),
                        );
                      }
                      return MembroList(membros: membroSnapshot.data!);
                    },
                  ),
                ),
                if (podeEntrarOuSair)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            grupo.membrosIds.contains(usuarioId)
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        final estaNoGrupo = grupo.membrosIds.contains(
                          usuarioId,
                        );
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  estaNoGrupo
                                      ? "Sair do grupo"
                                      : "Entrar no grupo",
                                ),
                                content: Text(
                                  estaNoGrupo
                                      ? "Tem certeza que deseja sair do grupo '${grupo.titulo}'?"
                                      : "Tem certeza que deseja entrar no grupo '${grupo.titulo}'?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      try {
                                        if (estaNoGrupo) {
                                          await grupo_service
                                              .removerMembroDoGrupo(
                                                grupo.id,
                                                usuarioId,
                                              );
                                          grupo.membrosIds.remove(usuarioId);

                                          if (!mounted) return;
                                          setState(() {
                                            _navegarParaHome = true;
                                          });
                                          return;
                                        } else {
                                          await grupo_service
                                              .adicionarMembroAoGrupo(
                                                grupo.id,
                                                usuarioId,
                                              );
                                          grupo.membrosIds.add(usuarioId);
                                        }

                                        if (!mounted) return;
                                        setState(() {
                                          _membrosFuture = grupo_service
                                              .getMembrosDoGrupo(
                                                widget.grupoId,
                                              );
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      estaNoGrupo ? "Sair" : "Entrar",
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Text(
                        grupo.membrosIds.contains(usuarioId)
                            ? "Sair do grupo"
                            : "Entrar no grupo",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
