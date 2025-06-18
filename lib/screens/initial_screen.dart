import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:endeavor/models/auth_response.dart';
import 'package:endeavor/models/usuario.dart';
import 'package:endeavor/providers/usuario_provider.dart';
import 'package:endeavor/screens/home_screen.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:endeavor/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:endeavor/providers/auth_provider.dart';
import 'package:endeavor/services/auth_storage_service.dart';

class InitialScreen extends ConsumerStatefulWidget {
  const InitialScreen({super.key});

  @override
  ConsumerState<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {
  double _opacity = 1.0;
  bool estaLogado = false;
  
  @override
void initState() {
  super.initState();
  _checarAutenticacao();
}

Future<void> _checarAutenticacao() async {
  //Isso é para limpar os dados de autenticação
  ref.watch(authProvider.notifier).clearAuth();
  AuthStorageService().clearAuthData();
  bool value = await AuthStorageService().isAuthenticated();

  if (value) {
    String? id = await AuthStorageService().getId();
    String? token = await AuthStorageService().getToken();
    ref.watch(authProvider.notifier).setAuth(
      AuthResponse(id: id, token: token),
    );
  }

  setState(() {
    estaLogado = value;
  });


    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _opacity = 0.0;
      });
    });

    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await _mockAuthenticationCheck();

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<bool> _mockAuthenticationCheck() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Center(
          child: Stack(
            children: [
              LottieBuilder.asset("assets/animation.json"),
              Positioned(
                left: 120,
                bottom: 30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: _opacity,
                  child: Text(
                    "Endeavor",
                    style: const TextStyle(
                      fontSize: 48,
                      fontFamily: 'BebasNeue',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        nextScreen: estaLogado ? HomeScreen() : LoginScreen(),
        animationDuration: const Duration(milliseconds: 2200),
        splashIconSize: 400,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        duration: 2400,
      ),
    );
  }
}
