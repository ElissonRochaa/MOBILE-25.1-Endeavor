import 'package:carousel_slider/carousel_slider.dart';
import 'package:endeavor/models/materia.dart';
import 'package:endeavor/widgets/materias/materia_item.dart';
import 'package:flutter/material.dart';

class MateriaList extends StatelessWidget {
  const MateriaList({super.key, required this.getFn});

  final Future<List<Materia>> Function() getFn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FutureBuilder(
        future: getFn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma matéria encontrado'));
          }

          final materias = snapshot.data!;

          return CarouselSlider(
            options: CarouselOptions(height: 180.0),
            items:
                materias.map((materia) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: MateriaItem(materia: materia),
                      );
                    },
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
