import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class TemaToggleButton extends ConsumerWidget {
  const TemaToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
        color: Colors.white,
      ),
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        print('ThemeMode atual: $themeMode');
        print('Primary color: ${Theme.of(context).colorScheme.tertiary}');

      },
    );
  }
}
