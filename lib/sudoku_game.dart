import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_game_page.dart';

class SudokuGameMain extends StatelessWidget {
  const SudokuGameMain({super.key, this.difficulty = "easy"});
  final String difficulty;

  get dificuldade => difficulty;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jogo Sudoku",
      debugShowCheckedModeBanner: false,
      home: GameRootPage(
        difficulty: dificuldade,
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
  const GameRootPage({super.key, this.difficulty = "easy"});
  final String difficulty;

  @override
  State<GameRootPage> createState() => _GameRootPageState();
}

class _GameRootPageState extends State<GameRootPage> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Botão pressionado');
        },
        child: const Icon(Icons.pause),
      ),
      body: SudokuGamePage(
        dificuldadeSelecionada: widget.difficulty,
      ),
    );
  }
}
