import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreasEstudo extends StatelessWidget {
  final String nome;

  const AreasEstudo({required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
        ),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 24, 136, 180),
            Color.fromARGB(255, 220, 253, 255),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            width: 88,
            child: Text(
              nome,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
