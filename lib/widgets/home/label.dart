import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Label extends StatelessWidget {
  final String title; 

  const Label({required this.title ,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.nunito(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold
            
          ),),
          IconButton(onPressed: () {}, icon: Icon(Icons.add_rounded)),
          TextButton(onPressed: () {}, child: Text(title == "Minhas matérias" ? "ver todas" : "ver todos",  style: GoogleFonts.nunito(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w400
          ),))
        ],
      ),
    );
  }
}