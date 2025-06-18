enum Escolaridade {
  ENSINO_FUNDAMENTAL,
  ENSINO_MEDIO,
  ENSINO_SUPERIOR,
  POS_GRADUACAO,
  MESTRADO,
  DOUTORADO,
  NAO_INFORMADO,
}

extension EscolaridadeExt on Escolaridade {
  String get label {
    switch (this) {
      case Escolaridade.ENSINO_FUNDAMENTAL:
        return "Ensino Fundamental";
      case Escolaridade.ENSINO_MEDIO:
        return "Ensino Médio";
      case Escolaridade.ENSINO_SUPERIOR:
        return "Ensino Superior";
      case Escolaridade.POS_GRADUACAO:
        return "Pós-graduação";
      case Escolaridade.MESTRADO:
        return "Mestrado";
      case Escolaridade.DOUTORADO:
        return "Doutorado";
      case Escolaridade.NAO_INFORMADO:
        return "Não informado";
    }
  }
}

class Usuario {
  final String? id;
  final String? nome;
  final String? email;
  final int? idade;
  final Escolaridade? escolaridade;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.idade,
    required this.escolaridade,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      idade: json['idade'],
      escolaridade: _escolaridadeFromString(json['escolaridade']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'idade': idade,
      'escolaridade': escolaridade!.name,
    };
  }

  static Escolaridade _escolaridadeFromString(String escolaridadeString) {
    return Escolaridade.values.firstWhere(
      (e) => e.name == escolaridadeString,
      orElse: () => Escolaridade.NAO_INFORMADO,
    );
  }
}
