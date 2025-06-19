import 'package:endeavor/config/theme_app.dart';
import 'package:endeavor/widgets/loginRegistro/senha_input.dart';
import 'package:flutter/material.dart';

class RedefinirSenhaScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  RedefinirSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
                  'Recuperação de Senha',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Agora digite a sua nova senha.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    child: InputSenha(controller: _senhaController, label: "Nova senha")
                  ),
                SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    child: InputSenha(
                controller: _confirmarSenhaController,
                label: "Confirmar Senha",
                validator: (value) {
                  if (value != _senhaController.text) return "As senhas não coincidem.";
                  return null;
                },
                ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeApp.theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(332, 50),
                    ),
                    onPressed: () {
                      
                  },
                  child: Text(
                      'Redefinir senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
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
                  'Agora digite o código de verificação enviado para o seu email.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Código de verificação",
                        hintText: "Digite o código...",
                        suffixIcon: Icon(
                          Icons.note_alt,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return "Digite o código de verificação.";
                        }
                        return null;
                      },      
                    ),
                  ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeApp.theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(332, 50),
                    ),
                    onPressed: () {
                      
                  },
                  child: Text(
                      'Enviar código',
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