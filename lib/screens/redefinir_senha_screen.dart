import 'package:endeavor/config/theme_app.dart';
import 'package:endeavor/services/redefinir_senha_service.dart';
import 'package:endeavor/widgets/loginRegistro/senha_input.dart';
import 'package:flutter/material.dart';

class RedefinirSenhaScreen extends StatefulWidget {
  const RedefinirSenhaScreen({super.key});

  @override
  State<RedefinirSenhaScreen> createState() => _RedefinirSenhaScreenState();
}

class _RedefinirSenhaScreenState extends State<RedefinirSenhaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool codigoValidado = false;
  String email = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (email.isEmpty) {
      email = ModalRoute.of(context)!.settings.arguments as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir Senha')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: codigoValidado ? _buildNovaSenha() : _buildVerificarCodigo(),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificarCodigo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Recuperação de Senha',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Digite o código enviado para seu email.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextFormField(
            controller: _codigoController,
            decoration: InputDecoration(
              labelText: "Código de verificação",
              hintText: "Digite o código...",
              suffixIcon: Icon(
                Icons.verified,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Digite o código.";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeApp.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(332, 50),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final valido = await verificarCodigo(
                  email,
                  _codigoController.text.trim(),
                );

                if (valido) {
                  setState(() {
                    codigoValidado = true;
                  });
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Código inválido."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao verificar código."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Text(
            'Verificar Código',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNovaSenha() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Definir Nova Senha',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Digite sua nova senha abaixo.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: InputSenha(controller: _senhaController, label: "Nova senha"),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: InputSenha(
            controller: _confirmarSenhaController,
            label: "Confirmar senha",
            validator: (value) {
              if (value != _senhaController.text) {
                return "As senhas não coincidem.";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeApp.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(332, 50),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await alterarSenha(email, _senhaController.text.trim());
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Senha alterada com sucesso."),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao alterar senha."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Text(
            'Redefinir Senha',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
