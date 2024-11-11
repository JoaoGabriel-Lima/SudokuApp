import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:tuple/tuple.dart';

class SudokuGamePage extends StatefulWidget {
  const SudokuGamePage(
      {super.key,
      this.dificuldadeSelecionada = "easy",
      required this.playerName});
  final String dificuldadeSelecionada;
  final String playerName;

  @override
  State<SudokuGamePage> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage> {
  Level getLevel() {
    switch (widget.dificuldadeSelecionada) {
      case "easy":
        return Level.easy;
      case "medium":
        return Level.medium;
      case "hard":
        return Level.hard;
      case "expert":
        return Level.expert;
      default:
        return Level.easy;
    }
  }

  late Level level;

  late List<List<int>> matrix;
  late List<Tuple2<int, int>> vazios;
  late List<int> quadradoSelecionado;

  @override
  void initState() {
    quadradoSelecionado = [-1, -1];

    level = getLevel();
    Sudoku sudoku = Sudoku.generate(level);

    matrix = List.generate(
        9, (i) => List.generate(9, (j) => sudoku.puzzle[i * 9 + j]));
    vazios = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (matrix[i][j] == -1) {
          vazios.add(Tuple2(i, j));
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              alignment: Alignment.center,
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dificuldade: ${widget.dificuldadeSelecionada}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Jogador: ${widget.playerName}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Container(
                padding: const EdgeInsets.all(4),
                margin: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext, quadrante) {
                    return Container(
                        padding: const EdgeInsets.all(4),
                        color: quadrante % 2 == 0 ? Colors.pink : Colors.purple,
                        alignment: Alignment.center,
                        child: GridView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                          ),
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext, numero) {
                            return InkWell(
                              mouseCursor:
                                  vazios.contains(Tuple2(quadrante, numero))
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                              onTap: () => {
                                print("Quadrante: $quadrante, Número: $numero"),
                                setState(() {
                                  if (vazios
                                      .contains(Tuple2(quadrante, numero))) {
                                    quadradoSelecionado = [quadrante, numero];
                                  }
                                })
                              },
                              child: Container(
                                color: quadradoSelecionado[0] == quadrante &&
                                        quadradoSelecionado[1] == numero
                                    ? Colors.pink.shade100
                                    : Colors.white,
                                alignment: Alignment.center,
                                child: Text(
                                  matrix[quadrante][numero] == -1
                                      ? ""
                                      : matrix[quadrante][numero].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                  },
                )),
          )
        ],
      ),
    );
  }
}
