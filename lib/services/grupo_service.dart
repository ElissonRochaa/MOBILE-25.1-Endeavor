import 'package:endeavor/models/grupo.dart';

final List<Grupo> _gruposDummy = [
  Grupo(
    id: '1',
    titulo: 'Matemática Básica',
    descricao: 'Grupo para revisar conceitos básicos de matemática.',
    capacidade: 10,
    membros: 5,
    privado: false,
    areasEstudo: ['Matemática'],
  ),
  Grupo(
    id: '2',
    titulo: 'Programação em Dart',
    descricao: 'Vamos aprender Dart do zero ao avançado.',
    capacidade: 15,
    membros: 8,
    privado: false,
    areasEstudo: ['Programação', 'Dart'],
  ),
  Grupo(
    id: '3',
    titulo: 'História Geral',
    descricao: 'Discussões sobre eventos históricos importantes.',
    capacidade: 12,
    membros: 6,
    privado: true,
    areasEstudo: ['História'],
  ),
  Grupo(
    id: '4',
    titulo: 'Física para Engenharia',
    descricao: 'Fórmulas, conceitos e exercícios de física aplicada.',
    capacidade: 20,
    membros: 12,
    privado: false,
    areasEstudo: ['Física', 'Engenharia'],
  ),
  Grupo(
    id: '5',
    titulo: 'Inglês Intermediário',
    descricao: 'Praticar inglês para conversação e escrita.',
    capacidade: 8,
    membros: 7,
    privado: true,
    areasEstudo: ['Idiomas', 'Inglês'],
  ),
  Grupo(
    id: '6',
    titulo: 'Desenvolvimento Web',
    descricao: 'HTML, CSS, JavaScript e frameworks modernos.',
    capacidade: 18,
    membros: 10,
    privado: false,
    areasEstudo: ['Tecnologia', 'Desenvolvimento Web'],
  ),
  Grupo(
    id: '7',
    titulo: 'Biologia Celular',
    descricao: 'Estudo aprofundado da célula e seus componentes.',
    capacidade: 14,
    membros: 9,
    privado: false,
    areasEstudo: ['Biologia'],
  ),
  Grupo(
    id: '8',
    titulo: 'Redação para ENEM',
    descricao: 'Dicas, práticas e correções de redações para o ENEM.',
    capacidade: 10,
    membros: 10,
    privado: true,
    areasEstudo: ['Redação', 'ENEM'],
  ),
];

Future<List<Grupo>> getGrupos() async {
  return _gruposDummy;
}

Future<Grupo> getGrupoById(String id) async {
  return _gruposDummy.where((grupo) => grupo.id == id).single;
}

Future<Grupo> createGrupo({
  required String titulo,
  required String descricao,
  required int capacidade,
  required bool privado,
  required List<String> areasEstudo,
}) async {
  final novoGrupo = Grupo(
    id: DateTime.now().toIso8601String(),
    titulo: titulo,
    descricao: descricao,
    capacidade: capacidade,
    membros: 0,
    privado: privado,
    areasEstudo: areasEstudo,
  );
  _gruposDummy.insert(0, novoGrupo);
  return novoGrupo;
}

Future<Grupo?> updateGrupo({
  required String id,
  String? titulo,
  String? descricao,
  int? capacidade,
  bool? privado,
  List<String>? areasEstudo,
}) async {
  final grupo = _gruposDummy.firstWhere(
    (g) => g.id == id,
    orElse: () => throw Exception('Grupo não encontrado'),
  );

  if (titulo != null) grupo.titulo = titulo;
  if (descricao != null) grupo.descricao = descricao;
  if (capacidade != null) grupo.capacidade = capacidade;
  if (privado != null) grupo.privado = privado;
  if (areasEstudo != null) grupo.areasEstudo = areasEstudo;

  return grupo;
}

Future<void> deleteGrupo(String id) async {
  _gruposDummy.removeWhere((g) => g.id == id);
}
