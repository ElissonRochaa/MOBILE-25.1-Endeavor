import 'package:endeavor/models/auth_response.dart';
import 'package:endeavor/models/usuario.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/providers/login_provider.dart';
import 'package:endeavor/providers/usuario_provider.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/themeApp.dart';
import '../widgets/loginRegistro/linha_widget.dart';
import 'package:endeavor/services/auth_service.dart';
import 'package:endeavor/services/auth_storage_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SecondLoginScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  SecondLoginScreen({super.key});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void fazerLogin() {
      ref.read(loginProvider.notifier).setSenha(_senhaController.text);
        login(
          ref.read(loginProvider).email!,
          ref.read(loginProvider).senha!,
        ).then((value) async {
          if (value.id != null && value.token != null) {
            ref.read(authProvider.notifier).setAuth(AuthResponse(
              id: value.id,
              token: value.token,));
            Usuario usuario = await buscarUsuarioPorId(value.id!, value.token!);
            ref.read(usuarioProvider.notifier).setUsuario(usuario);
            AuthStorageService().saveAuthData(value.id!, value.token!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login falhou. Tente novamente.")),
            );
          }
        });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Image(
                  image: AssetImage("assets/flameLogo.png"),
                  height: 160,
                  width: 200,
                  alignment: Alignment.center,
                ),
                Text(
                  "Endeavor",
                  style: TextStyle(fontSize: 48, fontFamily: 'BebasNeue'),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _senhaController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscuringCharacter: '*',
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Senha",
                      hintText: "Digite sua senha",
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
                        return "A senha deve conter, ao menos, 4 caracteres.";
                      }
                      return null;
                    },      
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(332, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      fazerLogin();
                    }
                  },
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 25,
                    bottom: 25,
                  ),
                  child: LinhaWidget("ou"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(332, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      color: Colors.black,
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
