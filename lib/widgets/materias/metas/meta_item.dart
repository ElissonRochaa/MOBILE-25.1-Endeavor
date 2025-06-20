import 'package:endeavor/models/meta.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/meta_service.dart';

class MetaItem extends ConsumerStatefulWidget {
  final Meta meta;

  const MetaItem({super.key, required  this.meta});

  @override
  ConsumerState<MetaItem> createState() => _MetaItemState();
}

class _MetaItemState extends ConsumerState<MetaItem> {
  late bool done;
  late String token;

  @override
  void initState() {
    super.initState();
    token = ref.read(authProvider).token!;
    done = widget.meta.concluida;
  }

  Future<void> _toggleDone(bool? value) async {
    setState(() {
      done = value ?? false;
    });

    await updateMeta(id: widget.meta.id, concluida: done, token: token);
  }

  Future<void> _confirmarExcluirMeta() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir meta'),
        content: const Text('Tem certeza que deseja excluir esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      try {
        await deleteMeta(widget.meta.id, token);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meta excluída com sucesso')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.tertiaryContainer,
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.meta.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _confirmarExcluirMeta,
                  icon: Icon(
                    Icons.delete,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.meta.descricao,
                        style: TextStyle(
                          color: Color(0xFF474747),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 4),
                      Text(
                        widget.meta.data.toIso8601String().substring(0, 10),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: done,
                  onChanged: _toggleDone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
