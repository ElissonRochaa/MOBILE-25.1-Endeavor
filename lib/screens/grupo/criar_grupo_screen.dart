import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/area_estudo.dart';
import 'package:endeavor/widgets/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/area_estudo.dart';
import '../../services/grupo_service.dart' as grupo_service;

class CriarGrupoScreen extends ConsumerStatefulWidget {
  const CriarGrupoScreen({super.key});

  @override
  ConsumerState<CriarGrupoScreen> createState() => _CriarGrupoScreenState();
}

class _CriarGrupoScreenState extends ConsumerState<CriarGrupoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<AreaEstudo> _areasEstudo = [];
  late String token;
  late String usuarioId;

  String? area;
  int? capacidade;
  bool isPrivado = false;

  void loadAreasEstudo() async {
    final areas = await getAreasEstudo(token);
    setState(() {
      _areasEstudo = areas;
      if (_areasEstudo.isNotEmpty) {
        area = _areasEstudo.first.id;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    token = ref.read(authProvider).token!;
    usuarioId = ref.read(authProvider).id!;
    loadAreasEstudo();
  }

  void areaHandler(String novaArea) {
    setState(() {
      area = novaArea;
    });
  }

  void capacidadeHandler(int novaCapacidade) {
    setState(() {
      capacidade = novaCapacidade;
    });
  }

  void retornarHandler() {
    Navigator.pop(context, true);
  }

  void submitHandler() async {
    try {
      final isValido = _formKey.currentState!.validate();
      if (!isValido) return;

      _formKey.currentState!.save();

      final grupoCriado = await grupo_service.createGrupo(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        capacidade: capacidade!,
        privado: isPrivado,
        areaEstudo: area!,
        idCriador: usuarioId,
        token: token,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Grupo criado com sucesso!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(grupoCriado),
                  child: const Text('OK'),
                ),
              ],
            ),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      ErrorHandler.handleError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dropdown = Expanded(
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: area,
        decoration: InputDecoration(
          labelText: 'Área',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        hint:
            _areasEstudo.isEmpty
                ? const Text("Carregando...")
                : const Text("Selecione uma área"),
        items:
            _areasEstudo.map((area) {
              return DropdownMenuItem(value: area.id, child: Text(area.nome));
            }).toList(),
        onChanged:
            _areasEstudo.isEmpty
                ? null
                : (value) {
                  setState(() {
                    area = value;
                  });
                },
        validator: (value) {
          if (value == null) {
            return 'Selecione uma área';
          }
          return null;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Grupo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: "Titulo do grupo",
                    suffixIcon: Icon(
                      Icons.note_alt,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 4 ||
                        value.trim().isEmpty) {
                      return "O titulo do grupo deve conter, ao menos, 4 caracteres.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    suffixIcon: Icon(
                      Icons.note_alt,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return "A descrição não pode ser nula.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    dropdown,
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        menuMaxHeight: 384,
                        decoration: InputDecoration(
                          hintText: 'Capacidade',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: List.generate(
                          49,
                          (index) => DropdownMenuItem(
                            value: index + 2,
                            child: Text("${index + 2} pessoas"),
                          ),
                        ),
                        onChanged: (value) {
                          capacidade = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione a capacidade';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isPrivado,
                        onChanged: (value) {
                          setState(() {
                            isPrivado = !isPrivado;
                          });
                        },
                      ),
                      Text(
                        "Grupo é privado?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 56,
                    horizontal: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 72,
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
                      onPressed: () {
                        submitHandler();
                      },
                      child: Text(
                        "Criar Grupo",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
