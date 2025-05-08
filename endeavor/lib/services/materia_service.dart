import 'package:endeavor/models/materia.dart';

List<Materia> _materiasDummy = [
  Materia(
    id: 1,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
  ),
  Materia(
    id: 2,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
  ),
  Materia(
    id: 3,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
  ),
];

Future<List<Materia>> getMaterias() async {

  return List<Materia>.from(_materiasDummy);
}

void updateDummyData(List<Materia> newData) {
  _materiasDummy = List<Materia>.from(newData);
}