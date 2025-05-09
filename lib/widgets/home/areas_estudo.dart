import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreasEstudo extends StatelessWidget {
  final String nome;

  const AreasEstudo({required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 140,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100),),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 24, 136, 180),
            const Color.fromARGB(255, 220, 253, 255)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 12,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary
              ),
            )),
          Positioned(
            bottom: 0,
            left: 12,
            child: SizedBox(
              width: 88,
              child: Text(nome, textAlign: TextAlign.center, style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white
              ),),
            )),
        ],
      ),
    );
  }
}
