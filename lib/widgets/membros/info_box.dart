import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String titulo;
  final String data;
  final bool isAtivo;
  final Color corBackground;
  final IconData? icone;

  const InfoBox({
    super.key,
    required this.corBackground,
    required this.titulo,
    required this.data,
    this.icone,
    required this.isAtivo,
  });

  @override
  Widget build(BuildContext context) {
    Color corDestaque = isAtivo ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: corBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: corDestaque,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Container(height: 2, width: 100, color: Colors.white),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(data, style: TextStyle(color: corDestaque)),
              if (icone != null) ...[
                const SizedBox(width: 8),
                Icon(icone, color: corDestaque, size: 20),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
