import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_game.dart';

class SudokuGameOptions extends StatefulWidget {
  const SudokuGameOptions({super.key});

  @override
  State<SudokuGameOptions> createState() => _SudokuGameOptionsState();
}

class _SudokuGameOptionsState extends State<SudokuGameOptions> {
  String difficulty = "easy";
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text('Bem-vindo ao João Sudoku!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink),
              textAlign: TextAlign.center),
          const Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Escolha seu nome:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black)),
                    labelText: 'Nome',
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Escolha o nível de dificuldade:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: <Widget>[
              RadioListTile(
                value: "easy",
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value.toString();
                  });
                },
                title: const Text('Fácil'),
                subtitle: const Text('Jogo padrão do Sudoku com 4x4'),
              ),
              RadioListTile(
                value: "medium",
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value.toString();
                  });
                },
                title: const Text('Médio'),
                subtitle: const Text('Jogo padrão do Sudoku com 9x9'),
              ),
              RadioListTile(
                value: "hard",
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value.toString();
                  });
                },
                title: const Text('Difícil'),
                subtitle: const Text('Jogo padrão do Sudoku com 16x16'),
              ),
              RadioListTile(
                value: "expert",
                groupValue: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value.toString();
                  });
                },
                title: const Text('Expert'),
                subtitle: const Text('Jogo padrão do Sudoku com 25x25'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameRootPage(
                              difficulty: difficulty,
                            )));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.pink),
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 50)),
                  ),
                  child: const Text(
                    'Iniciar jogo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )))
        ],
      ),
    ));
  }
}
