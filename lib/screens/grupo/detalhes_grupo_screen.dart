import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/models/membro_com_tempo.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/membros/membro_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final apiUrl = dotenv.env['API_URL'];

class DetalhesGrupoScreen extends ConsumerStatefulWidget {
  final String grupoId;
  final bool isConvite;

  const DetalhesGrupoScreen({
    super.key,
    required this.grupoId,
    this.isConvite = false,
  });

  @override
  ConsumerState<DetalhesGrupoScreen> createState() =>
      _DetalhesGrupoScreenState();
}

class _DetalhesGrupoScreenState extends ConsumerState<DetalhesGrupoScreen> {
  late Future<Grupo?> _grupoFuture;
  late Future<List<MembroComTempo>> _membrosFuture;

  String? usuarioId;
  String? token;

  bool _navegarParaHome = false;

  @override
  void initState() {
    super.initState();

    final auth = ref.read(authProvider);
    usuarioId = auth.id;
    token = auth.token;

    if (usuarioId == null || token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      });
      return;
    }

    _carregarDados();
  }

  void _carregarDados() {
    _grupoFuture = grupo_service.getGrupoById(widget.grupoId, token!);
    _membrosFuture = grupo_service.getMembrosDoGrupo(widget.grupoId, token!);

    _grupoFuture.then((grupo) {
      if (grupo != null &&
          widget.isConvite &&
          !grupo.membrosIds.contains(usuarioId)) {
        _mostrarDialogConvite(grupo);
      }
    });
  }

  void _mostrarDialogConvite(Grupo grupo) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                        usuarioId!,
                        token!,
                      );
                      if (!mounted) return;
                      grupo.membrosIds.add(usuarioId!);
                      setState(() {
                        _membrosFuture = grupo_service.getMembrosDoGrupo(
                          widget.grupoId,
                          token!,
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
    });
  }

  void _abrirCompartilhamento() async {
    final link = "${dotenv.env['API_URL']}/abrir-grupo/${widget.grupoId}";
    final mensagem =
        "Olá! Junte-se a mim no meu grupo de estudos no Endeavor! $link";

    await Share.share(mensagem);
  }

  @override
  Widget build(BuildContext context) {
    if (usuarioId == null || token == null) {
      return const Scaffold();
    }

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text("Grupo não encontrado"),
                    content: const Text(
                      "O grupo que você tentou acessar não existe mais ou foi apagado.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
            );
          });

          return const Scaffold();
        }

        final grupo = grupoSnapshot.data!;
        final podeEntrarOuSair =
            !grupo.privado ||
            grupo.membrosIds.contains(usuarioId) ||
            widget.isConvite;

        final estaNoGrupo = grupo.membrosIds.contains(usuarioId);

        return Scaffold(
          appBar: EndeavorTopBar(
            title: "Endeavor",
            hideLogo: true,
            icone: Row(
              children: [
                grupo.criadorId == usuarioId ||
                        (grupo.membros == 1 && grupo.membrosIds[0] == usuarioId)
                    ? IconButton(
                      onPressed: () async {
                        final atualizado = await Navigator.pushNamed(
                          context,
                          'grupos/editar',
                          arguments: grupo,
                        );
                        if (atualizado == true) {
                          setState(() {
                            _carregarDados();
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    )
                    : const SizedBox.shrink(),
                estaNoGrupo
                    ? IconButton(
                      onPressed: _abrirCompartilhamento,
                      icon: const Icon(Icons.share, color: Colors.white),
                    )
                    : const SizedBox.shrink(),
              ],
            ),
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
                const SizedBox(height: 24),

                Text(
                  "Áreas de estudo",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(grupo.areasEstudo.map((area) => area.nome).join(", ")),
                const SizedBox(height: 40),

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
                            estaNoGrupo
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        _confirmarEntradaOuSaida(grupo, estaNoGrupo);
                      },
                      child: Text(
                        estaNoGrupo ? "Sair do grupo" : "Entrar no grupo",
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

  void _confirmarEntradaOuSaida(Grupo grupo, bool estaNoGrupo) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(estaNoGrupo ? "Sair do grupo" : "Entrar no grupo"),
            content: Text(
              estaNoGrupo
                  ? "Tem certeza que deseja sair do grupo '${grupo.titulo}'?"
                  : "Tem certeza que deseja entrar no grupo '${grupo.titulo}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    if (estaNoGrupo) {
                      await grupo_service.removerMembroDoGrupo(
                        grupo.id,
                        usuarioId!,
                        token!,
                      );
                      grupo.membrosIds.remove(usuarioId!);

                      if (!mounted) return;
                      setState(() {
                        _navegarParaHome = true;
                      });
                      return;
                    } else {
                      await grupo_service.adicionarMembroAoGrupo(
                        grupo.id,
                        usuarioId!,
                        token!,
                      );
                      grupo.membrosIds.add(usuarioId!);
                    }

                    if (!mounted) return;
                    setState(() {
                      _membrosFuture = grupo_service.getMembrosDoGrupo(
                        widget.grupoId,
                        token!,
                      );
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(estaNoGrupo ? "Sair" : "Entrar"),
              ),
            ],
          ),
    );
  }
}
