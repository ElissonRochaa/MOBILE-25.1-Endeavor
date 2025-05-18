import 'package:endeavor/models/materia.dart';

List<Materia> _materiasDummy = [
  Materia(
    id: 1,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
  ),
  Materia(
    id: 2,
    nome: 'Verificação e validação de testes',
    descricao: 'cadeira de testes',
    ),
  Materia(
    id: 3,
    nome: 'Outra matéria',
    descricao: 'É uma outra matéria',
  ),
];

Future<List<Materia>> getMaterias() async {

  return List<Materia>.from(_materiasDummy);
}

void updateDummyData(List<Materia> newData) {
  _materiasDummy = List<Materia>.from(newData);
}

Future<Materia> getMateriaById(String id) async {
  return _materiasDummy.where((materia) => materia.id.toString() == id).single;
}

Future<Materia> createMateria({
  required String nome,
  required String descricao,
}) async {
  final novaMateria = Materia(
    id: DateTime.now().microsecond,
    nome: nome,
    descricao: descricao,
  );
  _materiasDummy.insert(0, novaMateria);
  return novaMateria;
}

Future<Materia?> updateMateria({
  required String id,
  String? nome,
  String? descricao,
}) async {
  final materia = _materiasDummy.firstWhere(
        (m) => m.id.toString() == id,
    orElse: () => throw Exception('Matéria não encontrada'),
  );

  if (nome != null) materia.nome = nome;
  if (descricao != null) materia.descricao = descricao;

  return materia;
}

Future<void> deleteMateria(String id) async {
  _materiasDummy.removeWhere((m) => m.id.toString() == id);
}
