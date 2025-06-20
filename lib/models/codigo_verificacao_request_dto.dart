class CodigoVerificacaoRequestDTO {
  final String email;
  final String codigo;

  CodigoVerificacaoRequestDTO({required this.email, required this.codigo});

  Map<String, dynamic> toJson() => {
    'email': email,
    'codigo': codigo,
  };

  factory CodigoVerificacaoRequestDTO.fromJson(Map<String, dynamic> json) {
    return CodigoVerificacaoRequestDTO(
      email: json['email'],
      codigo: json['codigo'],
    );
  }
}
