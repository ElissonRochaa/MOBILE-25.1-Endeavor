import 'package:endeavor/models/meta.dart';
import 'package:flutter/material.dart';

class MetaItem extends StatefulWidget {

  const MetaItem({super.key, required Meta meta});

  @override
  State<MetaItem> createState() => _MetaItemState();
}

class _MetaItemState extends State<MetaItem> {
  bool done = false;

  void _toggleDone(bool? value) {
    setState(() {
      done = value ?? false;
    });
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
              "Meta",
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
                        "Descrição",
                        style: TextStyle(
                          color: Color(0xFF474747),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 4),
                      Text(
                        "Data",
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
