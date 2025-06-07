class Usuario {
  final String id;
  final String nome;

  Usuario({required this.id, required this.nome});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(id: json['id'] as String, nome: json['nome'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}
