import 'package:endeavor/models/area_estudo.dart';
import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/area_estudo_service.dart';
import 'package:endeavor/services/grupo_service.dart' as grupo_service;
import 'package:endeavor/widgets/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditarGrupoScreen extends ConsumerStatefulWidget {
  final Grupo grupo;

  const EditarGrupoScreen({super.key, required this.grupo});

  @override
  ConsumerState<EditarGrupoScreen> createState() => _EditarGrupoScreenState();
}

class _EditarGrupoScreenState extends ConsumerState<EditarGrupoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _novaAreaController = TextEditingController();

  List<AreaEstudo> _areasEstudo = [];
  late String token;
  late String usuarioId;
  late AreaEstudo areaGrupo;
  String? area;
  int? capacidade;
  bool isPrivado = false;
  bool isOutro = false;

  @override
  void initState() {
    super.initState();
    token = ref.read(authProvider).token!;
    usuarioId = ref.read(authProvider).id!;
    carregarDadosIniciais();
  }

  Future<void> carregarDadosIniciais() async {
    final areas = await getAreasEstudo(token);
    areaGrupo = widget.grupo.areasEstudo.first;
    setState(() {
      _areasEstudo = areas;
      _tituloController.text = widget.grupo.titulo;
      _descricaoController.text = widget.grupo.descricao;
      capacidade = widget.grupo.capacidade;
      isPrivado = widget.grupo.privado;

      if (areas.any((a) => a.id == areaGrupo.id)) {
        area = areaGrupo.id;
        isOutro = false;
      } else {
        area = 'OUTRO';
        isOutro = true;
        _novaAreaController.text =
            (areaGrupo.nome.isNotEmpty ? areaGrupo.nome : 'Minha Área');
      }
    });
  }

  void submitHandler() async {
    try {
      final isValido = _formKey.currentState!.validate();
      if (!isValido) return;

      _formKey.currentState!.save();

      String novaAreaId;
      if (isOutro) {
        final criada = await createAreaEstudo(
          nome: _novaAreaController.text.trim(),
          token: token,
        );
        novaAreaId = criada.id;
      } else {
        novaAreaId = area!;
      }

      final grupoAtualizado = Grupo(
        id: widget.grupo.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        capacidade: capacidade!,
        privado: isPrivado,
        membrosIds: widget.grupo.membrosIds,
        areasEstudo: [AreaEstudo(id: novaAreaId)],
        criadorId: "",
      );

      await grupo_service.atualizarGrupo(
        grupoId: widget.grupo.id,
        grupoData: grupoAtualizado,
        token: token,
      );

      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Grupo atualizado com sucesso!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (error) {
      ErrorHandler.handleError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Grupo')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 4 ||
                        value.trim().isEmpty) {
                      return "O título do grupo deve conter, ao menos, 4 caracteres.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return "A descrição não pode ser vazia.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: isOutro ? 'OUTRO' : area,
                        items: [
                          ..._areasEstudo.map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.nome),
                            ),
                          ),
                          const DropdownMenuItem(
                            value: 'OUTRO',
                            child: Text('Outro'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            area = value;
                            isOutro = value == 'OUTRO';
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Área'),
                        validator:
                            (value) =>
                                (value == null) ? 'Selecione a área' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: capacidade,
                        decoration: const InputDecoration(
                          labelText: 'Capacidade',
                        ),
                        items: List.generate(
                          49,
                          (index) => DropdownMenuItem(
                            value: index + 2,
                            child: Text("${index + 2} pessoas"),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            capacidade = value;
                          });
                        },
                        validator:
                            (value) =>
                                (value == null) ? 'Informe a capacidade' : null,
                      ),
                    ),
                  ],
                ),
                if (isOutro) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _novaAreaController,
                    decoration: const InputDecoration(
                      labelText: "Nome da nova área",
                    ),
                    validator:
                        (value) =>
                            (isOutro && (value == null || value.trim().isEmpty))
                                ? 'Informe o nome da nova área'
                                : null,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isPrivado,
                      onChanged: (value) {
                        setState(() {
                          isPrivado = !isPrivado;
                        });
                      },
                    ),
                    const Text('Grupo privado'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: submitHandler,
                    child: Text(
                      "Salvar Alterações",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
