import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilBanner extends StatelessWidget {

  const PerfilBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/howto/img_avatar.png'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rony Rangel',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '12 horas estudadas hoje',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: 
                      [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    color: Colors.white, 
                  child: Text(
                    "Escolaridade: graduação\nÁrea de estudo: TI",
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            );
  }
}