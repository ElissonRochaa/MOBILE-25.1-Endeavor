import 'package:flutter/material.dart';

final List<String> _areasEstudo = [
  'Matemática',
  'Português',
  'História',
  'Ciências',
  'Geografia',
];

class CriarGrupoScreen extends StatelessWidget {
  const CriarGrupoScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nome do grupo",

                  suffixIcon: Icon(
                    Icons.note_alt,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Descrição",
                  suffixIcon: Icon(
                    Icons.note_alt,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<String>(
                        width: 200,
                        hintText: 'Área',
                        textStyle: const TextStyle(
                          overflow: TextOverflow.visible,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        dropdownMenuEntries:
                            _areasEstudo
                                .map(
                                  (area) => DropdownMenuEntry(
                                    value: area,
                                    label: area,
                                  ),
                                )
                                .toList(),
                        onSelected: (value) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<int>(
                        width: 200,
                        hintText: 'Capacidade',
                        textStyle: const TextStyle(
                          overflow: TextOverflow.visible,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        dropdownMenuEntries: List.generate(
                          50,
                          (index) => DropdownMenuEntry(
                            value: index + 1,
                            label: "${index + 1} pessoa(s)",
                          ),
                        ),
                        onSelected: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Checkbox(value: false, onChanged: (value) {}),
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
                    onPressed: () {},
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
    );
  }
}
