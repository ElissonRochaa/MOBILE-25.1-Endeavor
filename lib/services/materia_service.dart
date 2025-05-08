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