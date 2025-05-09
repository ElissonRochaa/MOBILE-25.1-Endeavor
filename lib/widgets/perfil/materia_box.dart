import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MateriaBox extends StatelessWidget{

  final String materia;
  final String tempo;

  const MateriaBox({
    super.key,
    required this.materia,
    required this.tempo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            materia,
            style: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
          ),
          Text(
            tempo,
            style: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}