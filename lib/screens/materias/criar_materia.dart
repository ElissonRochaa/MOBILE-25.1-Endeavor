import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';

import '../../services/materia_service.dart' as materia_service;

class CriarMateriaScreen extends StatefulWidget {
  const CriarMateriaScreen({super.key});

  @override
  State<CriarMateriaScreen> createState() => _CriarMateriaScreenState();
}

class _CriarMateriaScreenState extends State<CriarMateriaScreen> {
  final TextEditingController nomeMateriaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    bool isValido = _formKey.currentState!.validate();
    if (!isValido) return;

    _formKey.currentState!.save();

    try {
      await materia_service.createMateria(
        nome: nomeMateriaController.text,
        descricao: descricaoController.text,
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
      appBar: EndeavorTopBar(title: "Criar Matéria", hideLogo: true,),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: TextFormField(
                    controller: nomeMateriaController,
                    decoration: InputDecoration(
                        labelText: "Nome da matéria",
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        )
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
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: TextFormField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintStyle: TextStyle(color: Colors.black54),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      )
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

              SizedBox(height: 40,),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    criarMateriaHandler();
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
                    "Criar matéria",
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