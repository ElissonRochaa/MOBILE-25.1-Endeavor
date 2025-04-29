import 'package:flutter/material.dart';

import '../../services/grupo_service.dart' as grupo_service;

final List<String> _areasEstudo = [
  'Matemática',
  'Português',
  'História',
  'Ciências',
  'Geografia',
];

class CriarGrupoScreen extends StatefulWidget {
  const CriarGrupoScreen({super.key});

  @override
  State<CriarGrupoScreen> createState() => _CriarGrupoScreenState();
}

class _CriarGrupoScreenState extends State<CriarGrupoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? area;
  int? capacidade;
  bool isPrivado = false;

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

  void showError(Object e) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Erro ao criar grupo: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void submitHandler() async {
    bool isValido = _formKey.currentState!.validate();
    if (!isValido) return;

    _formKey.currentState!.save();

    try {
      await grupo_service.createGrupo(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        capacidade: capacidade!,
        privado: isPrivado,
        areasEstudo: [area!],
        idCriador: "placeholder idCriador",
      );

      if (context.mounted) {
        retornarHandler();
      }
    } catch (e) {
      if (context.mounted) {
        showError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    if (value == null || value.isEmpty || value.length < 4) {
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
                    if (value == null || value.isEmpty) {
                      return "A descrição não pode ser nula.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Área',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items:
                              _areasEstudo.map((area) {
                                return DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                );
                              }).toList(),
                          onChanged: (value) {
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<int>(
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
