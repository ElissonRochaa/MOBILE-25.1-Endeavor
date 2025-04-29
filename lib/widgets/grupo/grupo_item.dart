import 'package:endeavor/models/grupo.dart';
import 'package:flutter/material.dart';

class GrupoItem extends StatelessWidget {
  final Grupo grupoData;

  const GrupoItem({super.key, required this.grupoData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  Text(
                    grupoData.titulo,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    color: Theme.of(context).colorScheme.onTertiary,
                    grupoData.privado
                        ? Icons.lock_outline_rounded
                        : Icons.lock_open_outlined,
                  ),
                ],
              ),
              Text(
                grupoData.descricao,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                "Área de estudo: ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      grupoData.areasEstudo.join(', '),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.group,
                          size: 24,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        Text(
                          '${grupoData.membros}/${grupoData.capacidade}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
