import 'package:endeavor/screens/home_screen.dart';
import 'package:flutter/material.dart';

const escolaridade = [
  [
    "Fundamental 1",
    "Fundamental 2",
    "Ensino médio",
    "Graduação",
    "Pós-graduação",
  ],
  ["Tecnologia", "Ciências", "Culinária"],
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _opcaoSelecionada;
  int passo = 0;

  void _avancarPasso() {
    if (passo < escolaridade.length - 1) {
      setState(() {
        passo++;
        _opcaoSelecionada = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final opcoes = escolaridade[passo];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        surfaceTintColor: Colors.transparent,
        leading:
            passo > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      passo--;
                      _opcaoSelecionada = null;
                    });
                  },
                )
                : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Column(
                children: [
                  Image.asset("assets/flameLogo.png", width: 300),
                  const Text(
                    "Endeavor",
                    style: TextStyle(fontSize: 48, fontFamily: 'BebasNeue'),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  passo == 0
                      ? "Qual sua escolaridade?"
                      : "Qual área você mais se interessa?",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: opcoes.length,
                itemBuilder: (context, index) {
                  final item = opcoes[index];
                  return InkWell(
                    splashColor: Theme.of(context).colorScheme.tertiary,
                    onTap: () {
                      setState(() {
                        _opcaoSelecionada = item;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          Radio<String>(
                            value: item,
                            groupValue: _opcaoSelecionada,
                            onChanged: (value) {
                              setState(() {
                                _opcaoSelecionada = value;
                              });
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: InkWell(
                onTap: _opcaoSelecionada != null ? _avancarPasso : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        _opcaoSelecionada != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                  ),
                  child: Text(
                    passo < escolaridade.length - 1 ? 'Continuar' : 'Finalizar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(escolaridade.length, (index) {
                    final isSelected = index <= passo;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
