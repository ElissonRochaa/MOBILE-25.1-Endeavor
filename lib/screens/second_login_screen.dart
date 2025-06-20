import 'package:endeavor/config/theme_app.dart';
import 'package:endeavor/models/auth_response.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/providers/login_provider.dart';
import 'package:endeavor/screens/recuperar_senha_screen.dart';
import 'package:endeavor/services/auth_service.dart';
import 'package:endeavor/services/auth_storage_service.dart';
import 'package:endeavor/widgets/loginRegistro/senha_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/loginRegistro/linha_widget.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SecondLoginScreen extends ConsumerStatefulWidget {
  const SecondLoginScreen({super.key});

  @override
  ConsumerState<SecondLoginScreen> createState() => _SecondLoginScreenState();
}

class _SecondLoginScreenState extends ConsumerState<SecondLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  void fazerLogin() {
    setState(() {
      _isLoading = true;
    });

    ref.read(loginProvider.notifier).setSenha(_senhaController.text);

    login(ref.read(loginProvider).email!, ref.read(loginProvider).senha!)
        .then((value) async {
          if (value.id != null && value.token != null) {
            ref
                .read(authProvider.notifier)
                .setAuth(AuthResponse(id: value.id, token: value.token));
            await AuthStorageService().saveAuthData(value.id!, value.token!);
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login falhou. Tente novamente.")),
            );
          }
        })
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                      width: 400,
                      child: InputSenha(
                        controller: _senhaController,
                        label: "Senha",
                        hint: "exemplo1234",
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

                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecuperarSenhaScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Esqueceu sua senha? ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Clique aqui',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
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
                        if (_formKey.currentState!.validate() && !_isLoading) {
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
                      onPressed:
                          _isLoading
                              ? null
                              : () {
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

          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    "Carregando...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
