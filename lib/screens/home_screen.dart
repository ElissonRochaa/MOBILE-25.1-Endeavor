import 'package:endeavor/services/grupo_service.dart';
import 'package:endeavor/services/materia_service.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:endeavor/widgets/home/areas_estudo.dart';
import 'package:endeavor/widgets/home/card_grupo.dart';
import 'package:endeavor/widgets/home/label.dart';
import 'package:endeavor/widgets/materias/materia_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;

class HomeScreen extends StatelessWidget {
  final String? nome;

  const HomeScreen({super.key, this.nome});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: EndeavorTopBar(title: "Endeavor"),
      bottomNavigationBar: EndeavorBottomBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            child: SearchBar(
              
              leading: Icon(Icons.search, size: 24, color: Colors.grey[600]),
              padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surface,
              ),
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              trailing: [
                Icon(Icons.reorder, size: 24, color: Colors.grey[600]),
              ],
            ),
          ),
          Label(title: "Minhas matérias"),
          SizedBox(
            height: 200,
            child: FutureBuilder(
              future: getMaterias(),
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
                options: CarouselOptions(height: 400.0),
                items: materias.map((materia) {
                  return Builder(
                    builder: (BuildContext context) {
                      return MateriaItem(materia: materia);
                    },
                  );
                }).toList(),
              );
              } 
            )
          ),
          SizedBox(height: 40),
          Label(title: "Meus grupos"),
          Container(
            padding: EdgeInsets.only(left: 20),
            height: 70,
            child: FutureBuilder(
              future: getGrupos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum grupo encontrado'));
                }

                final grupos = snapshot.data!;

                return ListView.builder(
                  itemCount: grupos.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) => CardGrupo(grupo: grupos[index]),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Label(title: "Áreas de estudo"),
          Container(
            padding: EdgeInsets.only(left: 20),
            height: 140,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => AreasEstudo(nome: "Mobile"),
            ),
          ),
        ],
      ),
    );
  }
}
