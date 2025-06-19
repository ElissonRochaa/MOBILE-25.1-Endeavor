import 'package:endeavor/config/theme_app.dart';
import 'package:endeavor/screens/redefinir_senha_screen.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:flutter/material.dart';


class RecuperarSenhaScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  RecuperarSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Para recuperar sua senha, digite seu email abaixo que será enviado um link para redefinição.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Digite seu email",
                        suffixIcon: Icon(
                          Icons.note_alt,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4 ||
                            value.trim().isEmpty) {
                          return "O email deve conter, ao menos, 4 caracteres.";
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate())  {
            
                        bool existe = await usuarioJaCadastrado(_emailController.text);
                        
                        if (!existe) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email não cadastrado."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RedefinirSenhaScreen(),
                          ),
                        );
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