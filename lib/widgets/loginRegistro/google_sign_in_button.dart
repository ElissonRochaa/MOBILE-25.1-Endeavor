import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/auth_response.dart';
import '../../providers/auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../services/auth_service.dart';
import '../../services/auth_storage_service.dart';
class GoogleSignInButton extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;

  const GoogleSignInButton({super.key, this.onLoginSuccess});

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(332, 50),
      ),
      onPressed: _isLoading ? null : () async {
        setState(() => _isLoading = true);
        try {
          final googleSignIn = GoogleSignIn(
            scopes: ['email'],
            serverClientId: '1043691935132-fait3hv3u1jgt6nv69boq8ue6o0jh33k.apps.googleusercontent.com',
          );

          final user = await googleSignIn.signIn();

          if (user == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login cancelado")),
              );
            }
            setState(() => _isLoading = false);
            return;
          }

          final googleAuth = await user.authentication;
          final idToken = googleAuth.idToken;

          if (idToken == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Falha ao obter token do Google")),
              );
            }
            setState(() => _isLoading = false);
            return;
          }

          final authResponse = await loginComGoogle(idToken);

          if (authResponse.id != null && authResponse.token != null) {
            ref.read(authProvider.notifier).setAuth(authResponse);
            await AuthStorageService().saveAuthData(authResponse.id!, authResponse.token!);

            if (widget.onLoginSuccess != null) {
              widget.onLoginSuccess!();
            } else if (context.mounted) {
              await Navigator.pushReplacement(
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Erro inesperado no login com Google")),
            );
          }
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.black)
          : Row(
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
