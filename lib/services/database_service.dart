import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sudoku/models/partida.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'sudoku_db.db');

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE sudoku(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              result INTEGER,
              date VARCHAR NOT NULL,
              level INTEGER
          );
        ''');
      },
    );
    return database;
  }

  Future<Partida> criarPartida(String nome_jogador, int dificuldade) async {
    final db = await database;
    final dataAtual = DateTime.now();
    final dataFormatada =
        "${dataAtual.day}/${dataAtual.month}/${dataAtual.year} ${dataAtual.hour}:${dataAtual.minute}:${dataAtual.second}";

    await db.rawInsert(
        'INSERT INTO sudoku(name, result, date, level) VALUES(?, ?, ?, ?)',
        [nome_jogador, 0, dataFormatada, dificuldade]);

    final partidaCriada = await db.rawQuery(
        'SELECT id FROM sudoku WHERE name = ? AND date = ? AND level = ?',
        [nome_jogador, dataFormatada, dificuldade]);

    final partida = Partida(
      id: partidaCriada[0]['id'] as int,
      name: nome_jogador,
      result: 0,
      date: dataFormatada,
      level: dificuldade,
    );
    return partida;
  }

  void atualizarResultadoPartida(int id, int resultado) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE sudoku SET result = ? WHERE id = ?', [resultado, id]);
  }

  Future<List<Partida>> buscarPartidas({int dificuldade = -1}) async {
    final db = await database;

    if (dificuldade != -1) {
      final partidas = await db.rawQuery(
          'SELECT * FROM sudoku WHERE level = ? ORDER BY date DESC',
          [dificuldade]);
      final listaPartidas = partidas.map((partida) {
        return Partida(
          id: partida['id'] as int,
          name: partida['name'] as String,
          result: partida['result'] as int,
          date: partida['date'] as String,
          level: partida['level'] as int,
        );
      }).toList();
      return listaPartidas;
    }
    final partidas = await db.rawQuery('SELECT * FROM sudoku');
    final listaPartidas = partidas.map((partida) {
      return Partida(
        id: partida['id'] as int,
        name: partida['name'] as String,
        result: partida['result'] as int,
        date: partida['date'] as String,
        level: partida['level'] as int,
      );
    }).toList();
    return listaPartidas;
  }
}
