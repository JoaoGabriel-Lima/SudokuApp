import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_game.dart';

class SudokuGameOptions extends StatefulWidget {
  const SudokuGameOptions({super.key});

  @override
  State<SudokuGameOptions> createState() => _SudokuGameOptionsState();
}

class _SudokuGameOptionsState extends State<SudokuGameOptions> {
  String difficulty = "easy";
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text('Bem-vindo ao Marinho Sudoku!',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                      textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Escolha seu nome:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Nome',
                          ),
                          controller: nameController,
                          onChanged: (value) {
                            setState(() {});
                          },
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
                        subtitle: const Text('Jogo padrão do Sudoku Fácil'),
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
                        subtitle: const Text('Jogo padrão do Sudoku Médio'),
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
                        subtitle: const Text('Jogo padrão do Sudoku Difícil'),
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
                        subtitle: const Text('Jogo padrão do Sudoku Expert'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: FilledButton(
                          onPressed: nameController.text == ""
                              ? null
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => GameRootPage(
                                            difficulty: difficulty,
                                            playerName: nameController.text,
                                          )));
                                },
                          style: FilledButton.styleFrom(
                            // backgroundColor: Colors.pink,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Iniciar jogo',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )))
                ],
              ),
            )));
  }
}
