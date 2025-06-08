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
    print(uri);

    if (uri.pathSegments.isNotEmpty) {
      final entity = uri.pathSegments[0];
      switch (entity) {
        case 'grupos':
          if (uri.pathSegments.length >= 2) {
            final grupoId = uri.pathSegments[1];
            return _authGuard(
              builder: (_) => DetalhesGrupoScreen(grupoId: grupoId),
              fallbackRoute: '/login',
            );
          } else {
            return _authGuard(
              builder: (_) => const GrupoScreen(),
              fallbackRoute: '/login',
            );
          }
        case 'materias':
          if (uri.pathSegments.length == 2) {
            final materiaId = uri.pathSegments[1];
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
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/login-2':
        return MaterialPageRoute(builder: (_) => const SecondLoginScreen());
      case '/registro':
        return MaterialPageRoute(builder: (_) => const RegistroScreen());

      // Rotas protegidas
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
      case '/grupos/criar':
        return _authGuard(
          builder: (_) => const CriarGrupoScreen(),
          fallbackRoute: '/login',
        );
      case '/materias/criar':
        return _authGuard(
          builder: (_) => const CriarMateriaScreen(),
          fallbackRoute: '/login',
        );
      case '/materias/meta':
        return _authGuard(
          builder: (_) => const CriarMetaScreen(),
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
