import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/screens/grupo/detalhes_grupo_screen.dart';
import 'package:flutter/material.dart';

class GrupoItem extends StatelessWidget {
  final Grupo grupoData;

  const GrupoItem({super.key, required this.grupoData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetalhesGrupoScreen(grupoId: grupoData.id),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Theme.of(context).colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        grupoData.titulo,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      grupoData.privado
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  grupoData.descricao,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 24),

                Text(
                  "Área de estudo:",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        grupoData.areasEstudo.join(', '),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                          ),
                        ),
                        Text(
                          '${grupoData.membros}/${grupoData.capacidade}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
