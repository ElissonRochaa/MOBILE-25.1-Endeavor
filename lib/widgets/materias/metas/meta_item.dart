import 'package:endeavor/models/meta.dart';
import 'package:flutter/material.dart';

import '../../../services/meta_service.dart';

class MetaItem extends StatefulWidget {
  final Meta meta;

  const MetaItem({super.key, required  this.meta});

  @override
  State<MetaItem> createState() => _MetaItemState();
}

class _MetaItemState extends State<MetaItem> {
  late bool done;

  @override
  void initState() {
    super.initState();
    done = widget.meta.concluida;
  }

  Future<void> _toggleDone(bool? value) async {
    setState(() {
      done = value ?? false;
    });

    await updateMeta(id: widget.meta.id, concluida: done);
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
            Text(
              widget.meta.nome,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
