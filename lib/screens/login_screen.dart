import 'package:endeavor/screens/registro/registro_screen.dart';
import 'package:endeavor/screens/second_login_screen.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:endeavor/widgets/loginRegistro/linha_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:endeavor/providers/login_provider.dart';

import '../config/theme_app.dart';
import '../widgets/loginRegistro/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget{

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 40),
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
                      ref.read(loginProvider.notifier).setEmail(_emailController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondLoginScreen(),
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
                Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 25,
                    bottom: 25,
                  ),
                  child: LinhaWidget("ou"),
                ),
                GoogleSignInButton(),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeApp.theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(332, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistroScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Registrar',
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
