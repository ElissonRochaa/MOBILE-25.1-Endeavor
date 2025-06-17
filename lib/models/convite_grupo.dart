class ConviteGrupo {
  final String token;

  ConviteGrupo({required this.token});

  String get conviteLink => "https://endeavorapp.com/invite/$token";
}
