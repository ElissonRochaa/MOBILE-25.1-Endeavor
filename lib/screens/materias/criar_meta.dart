import 'package:endeavor/screens/materias/materias_details_screen.dart';
import 'package:endeavor/widgets/geral/endeavor_bottom_bar.dart';
import 'package:endeavor/widgets/geral/endeavor_top_bar.dart';
import 'package:flutter/material.dart';

class CriarMetaScreen extends StatefulWidget {
  const CriarMetaScreen({super.key});

  @override
  State<CriarMetaScreen> createState() => _CriarMetaScreenState();
}

class _CriarMetaScreenState extends State<CriarMetaScreen> {
  final TextEditingController nomeMetaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EndeavorTopBar(title: "Criar Meta", hideLogo: true,),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: TextField(
                controller: nomeMetaController,
                decoration: InputDecoration(
                  labelText: "Nome da meta",
                  hintStyle: TextStyle(color: Colors.black54),
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )
                )
              ),
            ),

            Padding(
              padding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: "Descrição",
                hintStyle: TextStyle(color: Colors.black54),
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )
              ),
            ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        fixedSize: Size(170, 50),
                        side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary,)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Selecionar prazo"),
                          SizedBox(width: 5,),
                          Icon(Icons.edit_calendar, size: 26,)
                        ],
                      )
                  ),
                ],
              ),
            ),

            SizedBox(height: 40,),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    fixedSize: Size(
                        MediaQuery.sizeOf(context).width,
                        50),
                    backgroundColor: Theme.of(context).colorScheme.tertiary
                ),
                child: Text(
                  "Criar meta",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EndeavorBottomBar(),
    );
  }
}