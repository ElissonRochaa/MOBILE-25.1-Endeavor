import 'package:endeavor/models/grupo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardGrupo extends StatelessWidget {
  final Grupo grupo;

  const CardGrupo({required this.grupo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 160,
      height: 75,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  grupo.titulo,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              grupo.privado
                  ? Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.surface,
                  )
                  : Icon(
                    Icons.lock_open,
                    color: Theme.of(context).colorScheme.surface,
                  ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                grupo.areasEstudo.join(", "),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              Text(
                "${grupo.membros}/${grupo.capacidade}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
