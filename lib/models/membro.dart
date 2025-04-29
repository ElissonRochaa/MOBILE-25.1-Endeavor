class Membro {
  String nome;
  String materia;
  bool isAtivo;
  DateTime inicioEstudo;

  Membro({
    required this.nome,
    required this.isAtivo,
    required this.materia,
    required this.inicioEstudo,
  });

  String tempoEstudoFormatado() {
    final ducacao = DateTime.now().difference(inicioEstudo);
    final horas = ducacao.inHours.toString().padLeft(2, '0');
    final minutos = (ducacao.inMinutes % 60).toString().padLeft(2, '0');
    final segundos = (ducacao.inSeconds % 60).toString().padLeft(2, '0');
    return "$horas:$minutos:$segundos";
  }
}
