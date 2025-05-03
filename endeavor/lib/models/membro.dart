class Membro {
  String id;
  String nome;
  String materia;
  bool isAtivo;
  DateTime? inicioEstudo;
  Duration tempoTotalEstudado;

  Membro({
    required this.id,
    required this.nome,
    required this.isAtivo,
    required this.materia,
    this.inicioEstudo,
    Duration? tempoTotalEstudado,
  }) : tempoTotalEstudado = tempoTotalEstudado ?? Duration.zero;

  String tempoEstudoFormatado() {
    final total =
        isAtivo
            ? tempoTotalEstudado + DateTime.now().difference(inicioEstudo!)
            : tempoTotalEstudado;

    final horas = total.inHours.toString().padLeft(2, '0');
    final minutos = (total.inMinutes % 60).toString().padLeft(2, '0');
    final segundos = (total.inSeconds % 60).toString().padLeft(2, '0');
    return "$horas:$minutos:$segundos";
  }
}
