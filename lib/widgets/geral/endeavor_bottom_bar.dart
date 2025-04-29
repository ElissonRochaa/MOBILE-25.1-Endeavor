import 'package:endeavor/config/themeApp.dart';
import 'package:endeavor/screens/grupo/grupo_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/estatisticasScreen.dart';
import '../../screens/homeScreen.dart';

class EndeavorBottomBar extends StatelessWidget {
  const EndeavorBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ThemeApp.theme.primaryColor,
      elevation: 0,
      notchMargin: 14,
      height: 64,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GrupoScreen()),
              );
            },
            icon: Icon(Icons.group, color: Colors.white, size: 34),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: Icon(Icons.home, color: Colors.white, size: 34),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Estatisticasscreen(),
                ),
              );
            },
            icon: Icon(Icons.bar_chart, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }
}
