import 'package:endeavor/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilBanner extends StatelessWidget {
  final Usuario? usuario;
  final String tempoTotal;

  const PerfilBanner({
    super.key,
    required this.usuario,
    required this.tempoTotal,
  });

  String get nome => usuario?.nome ?? "Carregando...";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://www.w3schools.com/howto/img_avatar.png',
            ),
          ),
          Text(
            nome,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,

            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$tempoTotal estudados hoje',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.only(top: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              child: Text(
                "Escolaridade: graduação\nÁrea de estudo: TI",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
