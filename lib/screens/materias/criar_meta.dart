import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/meta_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CriarMetaScreen extends ConsumerStatefulWidget {
  final String materiaId;
  const CriarMetaScreen({super.key, required this.materiaId});

  @override
  ConsumerState<CriarMetaScreen> createState() => _CriarMetaScreenState();
}

class _CriarMetaScreenState extends ConsumerState<CriarMetaScreen> {
  final TextEditingController nomeMetaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _prazoSelecionado;
  late String token;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
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
        content: Text('Erro ao criar meta: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void criarMetaHandler() async {
    final isValido = _formKey.currentState!.validate();
    if (!isValido) return;

    _formKey.currentState!.save();

    print('Enviando meta para matéria ID: ${widget.materiaId}');
    try {
      final metaCriada = await createMeta(
          nome: nomeMetaController.text,
          descricao: descricaoController.text,
          materiaId: widget.materiaId,
          data: _prazoSelecionado,
          concluida: false,
          token: token,
          );

      print(metaCriada);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Meta criada com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(metaCriada),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      Navigator.pop(context, metaCriada);
    } catch (e) {
      print('materia: ${widget.materiaId}');
      if (mounted) {
        showError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    token = ref.watch(authProvider).token!;
    return Scaffold(
      appBar: EndeavorTopBar(title: "Criar Meta", hideLogo: true,),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: TextField(
                  controller: nomeMetaController,
                  decoration: InputDecoration(
                    labelText: "Nome da meta",
                    hintStyle: TextStyle(color: Colors.black54),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  )
                ),
              ),

              Padding(
                padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintStyle: TextStyle(color: Colors.black54),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    )
                ),
              ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 0)),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _prazoSelecionado = pickedDate;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        fixedSize: const Size(200, 50),
                        side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _prazoSelecionado != null
                                ? "Prazo: ${_formatDate(_prazoSelecionado!)}"
                                : "Selecionar prazo",
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.edit_calendar, size: 26),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40,),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    criarMetaHandler();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      fixedSize: Size(
                          MediaQuery.sizeOf(context).width,
                          50),
                      backgroundColor: Theme.of(context).colorScheme.tertiary
                  ),
                  child: Text(
                    "Criar meta",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: EndeavorBottomBar(),
    );
  }
}