class EvolucaoModel {
  final DateTime data;
  final int tempo;

  EvolucaoModel({required this.data, required this.tempo});

  factory EvolucaoModel.fromJson(Map<String, dynamic> json) {
    return EvolucaoModel(
      data: DateTime.parse(json['data']),
      tempo: json['tempo'],
    );
  }
}
