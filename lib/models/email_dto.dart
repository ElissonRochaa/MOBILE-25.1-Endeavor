class EmailDTO {
  final String email;

  EmailDTO({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  factory EmailDTO.fromJson(Map<String, dynamic> json) {
    return EmailDTO(email: json['email']);
  }
}
