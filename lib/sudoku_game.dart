import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo Sudoku'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.black,
        // backgroundColor: Colors.blue,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     debugPrint('Botão pressionado');
      //   },
      //   child: const Icon(Icons.pause),
      // ),
      body: SudokuGamePage(
        dificuldadeSelecionada: widget.difficulty,
        playerName: playerName,
      ),
    );
  }
}
