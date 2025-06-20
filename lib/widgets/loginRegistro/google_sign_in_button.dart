import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as ref;

import '../../models/auth_response.dart';
import '../../providers/auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../services/auth_service.dart';
import '../../services/auth_storage_service.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(332, 50),
      ),
      onPressed: () async {
        try {
          final user = await GoogleSignIn().signIn();

          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login cancelado")),
            );
            return;
          }

          final googleAuth = await user.authentication;
          final idToken = googleAuth.idToken;

          if (idToken == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Falha ao obter token do Google")),
            );
            return;
          }

          final authResponse = await loginComGoogle(idToken);

          if (authResponse.id != null && authResponse.token != null) {
            ref.read(authProvider.notifier).setAuth(authResponse);
            await AuthStorageService().saveAuthData(authResponse.id!, authResponse.token!);

            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login com Google falhou")),
              );
            }
          }
        } catch (e, stack) {
          debugPrint("Erro ao fazer login com Google: $stack");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro inesperado no login com Google")),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/googleLogo.png",
            height: 24.0,
            width: 24.0,
          ),
          const SizedBox(width: 8),
          const Text(
            "Continuar com Google",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
