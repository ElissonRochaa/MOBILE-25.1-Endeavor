import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/materia_service.dart';

class CriarMateriaScreen extends ConsumerStatefulWidget {
  const CriarMateriaScreen({super.key});

  @override
  ConsumerState<CriarMateriaScreen> createState() => _CriarMateriaScreenState();
}

class _CriarMateriaScreenState extends ConsumerState<CriarMateriaScreen> {
  final TextEditingController nomeMateriaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String token;
  late String usuarioId;

  void retornarHandler() {
    Navigator.pop(context, true);
  }

  void showError(Object e) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Erro ao criar matéria: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void criarMateriaHandler() async {
    final isValido = _formKey.currentState!.validate();
    if (!isValido) return;

    _formKey.currentState!.save();

    try {
      final materiaCriada = await createMateria(
        nome: nomeMateriaController.text,
        descricao: descricaoController.text,
        usuarioId: usuarioId,
        token: token,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Matéria criada com sucesso!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(materiaCriada),
                  child: const Text('OK'),
                ),
              ],
            ),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        showError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    token = ref.watch(authProvider).token!;
    usuarioId = ref.watch(authProvider).id!;
    return Scaffold(
      appBar: EndeavorTopBar(title: "Criar Matéria", hideLogo: true),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 15.0,
                  ),
                  child: TextFormField(
                    controller: nomeMateriaController,
                    decoration: InputDecoration(
                      labelText: "Nome da matéria",
                      hintStyle: const TextStyle(color: Colors.black54),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 4 ||
                          value.trim().isEmpty) {
                        return "O nome da matéria deve conter, ao menos, 4 caracteres.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 15.0,
                  ),
                  child: TextFormField(
                    controller: descricaoController,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      hintStyle: const TextStyle(color: Colors.black54),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
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
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 15.0,
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
                      onPressed: criarMateriaHandler,
                      child: Text(
                        "Criar Matéria",
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
