import 'package:endeavor/screens/estatisticas_screen.dart';
import 'package:endeavor/screens/fallback_screen.dart';
import 'package:endeavor/screens/grupo/criar_grupo_screen.dart';
import 'package:endeavor/screens/grupo/detalhes_grupo_screen.dart';
import 'package:endeavor/screens/grupo/grupo_screen.dart';
import 'package:endeavor/screens/home_screen.dart';
import 'package:endeavor/screens/initial_screen.dart';
import 'package:endeavor/screens/login_screen.dart';
import 'package:endeavor/screens/materias/criar_materia.dart';
import 'package:endeavor/screens/materias/criar_meta.dart';
import 'package:endeavor/screens/materias/materias_details_screen.dart';
import 'package:endeavor/screens/materias/materias_screen.dart';
import 'package:endeavor/screens/quiz_screen.dart';
import 'package:endeavor/screens/registro/registro_screen.dart';
import 'package:endeavor/screens/second_login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';
    final uri = Uri.parse(name);

    if (uri.pathSegments.isNotEmpty) {
      final entity = uri.pathSegments[0];
      switch (entity) {
        case 'grupos':
          if (uri.pathSegments.length >= 2) {
            final secondSegment = uri.pathSegments[1];

            if (secondSegment == "criar") {
              return _authGuard(
                builder: (_) => const CriarGrupoScreen(),
                fallbackRoute: '/login',
              );
            } else if (secondSegment != "convite") {
              return _authGuard(
                builder: (_) => DetalhesGrupoScreen(grupoId: secondSegment),
                fallbackRoute: '/login',
              );
            }
            if (secondSegment == "convite" && uri.pathSegments.length == 3) {
              return _authGuard(
                builder:
                    (_) => DetalhesGrupoScreen(
                      grupoId: uri.pathSegments[2],
                      isConvite: true,
                    ),
                fallbackRoute: '/login',
              );
            }
          } else {
            return _authGuard(
              builder: (_) => const GrupoScreen(),
              fallbackRoute: '/login',
            );
          }

        case 'materias':
          if (uri.pathSegments.length == 2) {
            final materiaId = uri.pathSegments[1];

            if (materiaId.length < 30) {
              return _authGuard(
                builder: (_) => CriarMateriaScreen(),
                fallbackRoute: '/login',
              );
            }

            return _authGuard(
              builder: (_) => MateriasDetailsScreen(materiaId: materiaId),
              fallbackRoute: '/login',
            );
          } else {
            return _authGuard(
              builder: (_) => const MateriasScreen(),
              fallbackRoute: '/login',
            );
          }
      }
    }

    // Rotas fixas
    switch (name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const InitialScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/login-2':
        return MaterialPageRoute(builder: (_) => SecondLoginScreen());
      case '/registro':
        return MaterialPageRoute(builder: (_) => const RegistroScreen());
      case '/home':
        return _authGuard(
          builder: (_) => const HomeScreen(),
          fallbackRoute: '/login',
        );
      case '/quiz':
        return _authGuard(
          builder: (_) => const QuizScreen(),
          fallbackRoute: '/login',
        );
      case '/materias/meta':
        return _authGuard(
          builder: (_) => const CriarMetaScreen(materiaId: ''),
          fallbackRoute: '/login',
        );
      case '/estatisticas':
        return _authGuard(
          builder: (_) => const EstatisticasScreen(),
          fallbackRoute: '/login',
        );
      default:
        return MaterialPageRoute(builder: (_) => const FallbackScreen());
    }
  }

  static MaterialPageRoute _authGuard({
    required WidgetBuilder builder,
    String fallbackRoute = '/login',
  }) {
    return MaterialPageRoute(
      builder:
          (context) => FutureBuilder<bool>(
            future: _mockAuthenticationCheck(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data == true) {
                return builder(context);
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Atenção'),
                          content: const Text(
                            'Você precisa estar autenticado para acessar esta página.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(fallbackRoute);
                              },
                              child: const Text('Ir para Login'),
                            ),
                          ],
                        ),
                  );
                });
                return const SizedBox.shrink();
              }
            },
          ),
    );
  }

  static Future<bool> _mockAuthenticationCheck() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
