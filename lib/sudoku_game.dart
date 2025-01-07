import 'package:flutter/material.dart';
import 'package:sudoku/models/partida.dart';
import 'package:sudoku/services/database_service.dart';
import 'package:sudoku/sudoku_game_page.dart';

class SudokuGameMain extends StatelessWidget {
  const SudokuGameMain(
      {super.key, this.difficulty = "easy", this.playerName = "Jogador 1"});
  final String difficulty;
  final String playerName;

  get dificuldade => difficulty;
  get nomeJogador => playerName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jogo Sudoku",
      debugShowCheckedModeBanner: false,
      home: GameRootPage(
        difficulty: dificuldade,
        playerName: nomeJogador,
      ),
      theme: ThemeData(
          primaryColor: Colors.pink,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.pink,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}

class GameRootPage extends StatefulWidget {
  const GameRootPage(
      {super.key, this.difficulty = "easy", this.playerName = "Jogador 1"});
  final String difficulty;
  final String playerName;

  @override
  State<GameRootPage> createState() => _GameRootPageState();
}

class _GameRootPageState extends State<GameRootPage> {
  get playerName => widget.playerName;

  final DatabaseService databaseService = DatabaseService.instance;
  int? partidaId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createPartida();
    });
  }

  _createPartida() async {
    final difficultyMap = {
      "easy": 0,
      "medium": 1,
      "hard": 2,
      "expert": 3,
    };

    Partida partidaCriada = await databaseService.criarPartida(
        widget.playerName, difficultyMap[widget.difficulty]!);

    setState(() {
      partidaId = partidaCriada.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Jogo Sudoku ${partidaId != null ? '(ID: $partidaId)' : ''}'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.black,
      ),
      body: SudokuGamePage(
        dificuldadeSelecionada: widget.difficulty,
        playerName: playerName,
        partidaId: partidaId,
      ),
    );
  }
}
