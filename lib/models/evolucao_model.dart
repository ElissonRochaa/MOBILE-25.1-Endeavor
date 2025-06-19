class EvolucaoModel {
  final DateTime data;
  final double tempo;

  EvolucaoModel({required this.data, required this.tempo});

  factory EvolucaoModel.fromJson(Map<String, dynamic> json) {
    return EvolucaoModel(
      data: DateTime.parse(json['data']),
      tempo: (json['tempo'] as num).toDouble(),
    );
  }
}
