import 'package:endeavor/models/grupo.dart';
import 'package:endeavor/services/membro_service.dart';

import '../models/membro.dart';

final List<Grupo> _gruposDummy = [
  Grupo(
    id: '1',
    titulo: 'Matemática Básica',
    descricao: 'Grupo para revisar conceitos básicos de matemática.',
    capacidade: 10,
    privado: false,
    areasEstudo: ['Matemática'],
    membrosIds: ['m1', 'm7', 'm4', 'm3'],
  ),
  Grupo(
    id: '2',
    titulo: 'Programação em Dart',
    descricao: 'Vamos aprender Dart do zero ao avançado.',
    capacidade: 15,
    privado: false,
    areasEstudo: ['Programação', 'Dart'],
    membrosIds: ['m5', 'm6'],
  ),
  Grupo(
    id: '3',
    titulo: 'História Geral',
    descricao: 'Discussões sobre eventos históricos importantes.',
    capacidade: 12,
    privado: true,
    areasEstudo: ['História'],
    membrosIds: ['m2'],
  ),
  Grupo(
    id: '4',
    titulo: 'Física para Engenharia',
    descricao: 'Fórmulas, conceitos e exercícios de física aplicada.',
    capacidade: 20,
    privado: false,
    areasEstudo: ['Física', 'Engenharia'],
    membrosIds: ['m3'],
  ),
  Grupo(
    id: '5',
    titulo: 'Inglês Intermediário',
    descricao: 'Praticar inglês para conversação e escrita.',
    capacidade: 8,
    privado: true,
    areasEstudo: ['Idiomas', 'Inglês'],
    membrosIds: ['m8'],
  ),
  Grupo(
    id: '6',
    titulo: 'Desenvolvimento Web',
    descricao: 'HTML, CSS, JavaScript e frameworks modernos.',
    capacidade: 18,
    privado: false,
    areasEstudo: ['Tecnologia', 'Desenvolvimento Web'],
    membrosIds: ['m5', 'm6'],
  ),
  Grupo(
    id: '7',
    titulo: 'Biologia Celular',
    descricao: 'Estudo aprofundado da célula e seus componentes.',
    capacidade: 14,
    privado: false,
    areasEstudo: ['Biologia'],
    membrosIds: ['m4'],
  ),
  Grupo(
    id: '8',
    titulo: 'Redação para ENEM',
    descricao: 'Dicas, práticas e correções de redações para o ENEM.',
    capacidade: 10,
    privado: true,
    areasEstudo: ['Redação', 'ENEM'],
    membrosIds: ['m2'],
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
  required String idCriador,
}) async {
  final novoGrupo = Grupo(
    id: DateTime.now().toIso8601String(),
    titulo: titulo,
    descricao: descricao,
    capacidade: capacidade,
    membrosIds: [idCriador],
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

Future<List<Grupo>> getGruposByMembroNome(String nome) async {
  return _gruposDummy.where((g) => g.membrosIds.contains(nome)).toList();
}

Future<void> adicionarMembroAoGrupo(String grupoId, String nomeMembro) async {
  final grupo = _gruposDummy.firstWhere((g) => g.id == grupoId);
  if (!grupo.membrosIds.contains(nomeMembro)) {
    grupo.membrosIds.add(nomeMembro);
  }
}

Future<void> removerMembroDoGrupo(String grupoId, String nomeMembro) async {
  final grupo = _gruposDummy.firstWhere((g) => g.id == grupoId);
  grupo.membrosIds.remove(nomeMembro);
}

Future<List<Membro>> getMembrosDoGrupo(String grupoId) async {
  final grupo = _gruposDummy.firstWhere(
    (g) => g.id == grupoId,
    orElse: () => throw Exception('Grupo não encontrado'),
  );

  final todosMembros = await getMembros();

  final membros =
      todosMembros.where((m) => grupo.membrosIds.contains(m.id)).toList();

  return membros;
}
