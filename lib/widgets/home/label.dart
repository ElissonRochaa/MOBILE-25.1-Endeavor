import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Label extends StatelessWidget {
  final String title;
  final void Function() onAdd;
  final void Function() onSeeAll; 

  const Label({required this.title , required this.onAdd, required this.onSeeAll ,super.key});

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
          IconButton(onPressed: onAdd, icon: Icon(Icons.add_rounded)),
          TextButton(onPressed: onSeeAll, child: Text(title == "Minhas matérias" ? "ver todas" : "ver todos",  style: GoogleFonts.nunito(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w400
          ),))
        ],
      ),
    );
  }
}