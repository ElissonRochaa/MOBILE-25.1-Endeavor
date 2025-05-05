

import '../models/meta.dart';

List<Meta> _metasDummy = [
  Meta(
    id: 1,
    nome: 'Flutterzinho',
    descricao: 'Estudar Flutter',
    data: DateTime.now(),
    concluida: true,
  ),
  Meta(
    id: 2,
    nome: 'Meta',
    descricao: 'Meta muito top',
    data: DateTime.now(),
    concluida: true,
  ),

];

Future<List<Meta>> getMetas() async {

  return List<Meta>.from(_metasDummy);
}

void updateDummyData(List<Meta> newData) {
  _metasDummy = List<Meta>.from(newData);
}