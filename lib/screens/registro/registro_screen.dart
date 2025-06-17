import 'package:flutter/material.dart';
import 'package:endeavor/services/auth_service.dart';
import 'package:endeavor/widgets/loginRegistro/input_texto.dart';
import 'package:endeavor/widgets/loginRegistro/senha_input.dart';
import 'package:endeavor/screens/login_screen.dart';
import '../quiz_screen.dart';

enum Escolaridade {
  ENSINO_FUNDAMENTAL,
  ENSINO_MEDIO,
  ENSINO_SUPERIOR,
  POS_GRADUACAO,
  MESTRADO,
  DOUTORADO,
  NAO_INFORMADO,
}

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  Escolaridade? _escolaridadeSelecionada;
  bool _isLoading = false;

  void _registrarUsuario(String nome, String email, String senha, int idade, Escolaridade escolaridade) async {
    try {
      setState(() {
        _isLoading = true;
      });
      print("Registrando usuário: $nome, $email, $senha, $idade, ${escolaridade.name}");
      final response = await registrar(nome, email, senha, idade, escolaridade.name);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

  }


  @override
  Widget build(BuildContext context) {

    final content = [
              const SizedBox(height: 150),
              const Image(image: AssetImage("assets/flameLogo.png"), height: 160, width: 200),
              const Text("ENDEAVOR", style: TextStyle(fontSize: 48, fontFamily: "BebasNeue", fontWeight: FontWeight.bold)),
              const Text("Cadastre-se", style: TextStyle(fontSize: 24)),

              InputTexto(
                controller: _nomeController,
                label: "Nome",
                hint: "Digite seu nome",
                icon: Icons.person,
                validator: (value) => (value == null || value.trim().isEmpty) ? "O nome não pode estar vazio." : null,
              ),
              InputTexto(
                controller: _emailController,
                label: "Email",
                hint: "Digite seu email",
                icon: Icons.email,
                validator: (value) =>
                    (value == null || value.length < 4 || value.trim().isEmpty) ? "O email deve conter, ao menos, 4 caracteres." : null,
              ),
              InputTexto(
                controller: _idadeController,
                label: "Idade",
                hint: "Digite sua idade",
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Informe a idade.";
                  final idade = int.tryParse(value);
                  if (idade == null || idade < 12) return "Você deve ter, ao menos, 12 anos.";
                  return null;
                },
              ),

              InputSenha(
                controller: _senhaController,
                label: "Senha",
              ),
              InputSenha(
                controller: _confirmarSenhaController,
                label: "Confirmar Senha",
                validator: (value) {
                  if (value != _senhaController.text) return "As senhas não coincidem.";
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: DropdownButtonFormField<Escolaridade>(
                  value: _escolaridadeSelecionada,
                  decoration: InputDecoration(
                    labelText: "Escolaridade",
                    suffixIcon: Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                  ),
                  items: Escolaridade.values.map((escolaridade) {
                    return DropdownMenuItem(
                      value: escolaridade,
                      child: Text(escolaridade.name.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (Escolaridade? novaEscolaridade) {
                    setState(() {
                      _escolaridadeSelecionada = novaEscolaridade;
                    });
                  },
                  validator: (value) => value == null ? "Selecione sua escolaridade." : null,
                ),
              ),

              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registrarUsuario(
                        _nomeController.text,
                        _emailController.text,
                        _senhaController.text,
                        int.tryParse(_idadeController.text) ?? 0,
                        _escolaridadeSelecionada ?? Escolaridade.NAO_INFORMADO,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Registrar",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    const Text("Já possui conta? "),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                      child: Text(
                        "Faça o login!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: _isLoading 
              ? [const SizedBox(height: 150),
              const Image(image: AssetImage("assets/flameLogo.png"), height: 160, width: 200),
              const Text("ENDEAVOR", style: TextStyle(fontSize: 48, fontFamily: "BebasNeue", fontWeight: FontWeight.bold)),
              const Text("Cadastre-se", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
                const CircularProgressIndicator()] 
              : content,
            ),
          ),
        ),
      ),
    );
  }
}
