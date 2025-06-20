import 'package:endeavor/config/theme_app.dart';
import 'package:endeavor/screens/redefinir_senha_screen.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:flutter/material.dart';

import '../services/redefinir_senha_service.dart';

class RecuperarSenhaScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  RecuperarSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recuperação de Senha',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Para recuperar sua senha, digite seu email abaixo. Enviaremos um código de verificação.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Digite seu email",
                      suffixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 4 ||
                          !value.contains("@")) {
                        return "Digite um email válido.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(332, 50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text.trim();

                      try {
                        final existe = await usuarioJaCadastrado(email);

                        if (!existe) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email não cadastrado."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        await recuperarSenha(email);
                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RedefinirSenhaScreen(),
                            settings: RouteSettings(arguments: email),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Erro ao enviar código de verificação.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
