import 'package:endeavor/models/membro.dart';

final List<Membro> _membrosDummy = [
  Membro(
    id: 'm1',
    nome: 'Fulano',
    materia: 'Matemática',
    isAtivo: true,
    inicioEstudo: DateTime.now().subtract(
      const Duration(hours: 2, minutes: 30, seconds: 15),
    ),
    tempoTotalEstudado: const Duration(hours: 1, minutes: 45, seconds: 10),
  ),
  Membro(
    id: 'm2',
    nome: 'Ciclano',
    materia: 'Português',
    isAtivo: false,
    inicioEstudo: null,
    tempoTotalEstudado: const Duration(hours: 2, minutes: 5, seconds: 30),
  ),
  Membro(
    id: 'm3',
    nome: 'Maria',
    materia: 'Física',
    isAtivo: true,
    inicioEstudo: DateTime.now().subtract(
      const Duration(hours: 3, minutes: 5, seconds: 20),
    ),
    tempoTotalEstudado: const Duration(minutes: 30, seconds: 50),
  ),
  Membro(
    id: 'm4',
    nome: 'João',
    materia: 'Química',
    isAtivo: false,
    inicioEstudo: null,
    tempoTotalEstudado: const Duration(hours: 1, minutes: 15, seconds: 0),
  ),
  Membro(
    id: 'm5',
    nome: 'Ana',
    materia: 'Mobile',
    isAtivo: true,
    inicioEstudo: DateTime.now().subtract(
      const Duration(hours: 1, minutes: 50, seconds: 10),
    ),
    tempoTotalEstudado: const Duration(minutes: 20, seconds: 5),
  ),
  Membro(
    id: 'm6',
    nome: 'Carlos',
    materia: 'Paradigmas',
    isAtivo: false,
    inicioEstudo: null,
    tempoTotalEstudado: const Duration(hours: 2, minutes: 30, seconds: 45),
  ),
  Membro(
    id: 'm7',
    nome: 'Luana',
    materia: 'Matemática',
    isAtivo: true,
    inicioEstudo: DateTime.now().subtract(
      const Duration(hours: 0, minutes: 30, seconds: 45),
    ),
    tempoTotalEstudado: const Duration(minutes: 10, seconds: 15),
  ),
  Membro(
    id: 'm8',
    nome: 'Bruno',
    materia: 'Inglês',
    isAtivo: true,
    inicioEstudo: DateTime.now().subtract(
      const Duration(hours: 1, minutes: 20, seconds: 15),
    ),
    tempoTotalEstudado: const Duration(hours: 1, minutes: 0, seconds: 0),
  ),
];

Future<List<Membro>> getMembros() async {
  return _membrosDummy;
}

Future<void> addMembro(Membro membro) async {
  _membrosDummy.add(membro);
}

Future<void> removeMembro(String nome) async {
  _membrosDummy.removeWhere((m) => m.nome == nome);
}
