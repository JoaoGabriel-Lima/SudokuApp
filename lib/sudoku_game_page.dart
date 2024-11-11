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

  List<List<int>> changeMatrix(int value) {
    int pos1 = quadradoSelecionado[0];
    int pos2 = quadradoSelecionado[1];
    if (!vazios.contains(Tuple2(pos1, pos2))) return matrix;
    setState(() {
      matrix[pos1][pos2] = value;
    });
    return matrix;
  }

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
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Center(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      Container(
                        child: Text(
                          "Dificuldade: ${widget.dificuldadeSelecionada}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Jogador: ${widget.playerName == "" ? "Anônimo" : widget.playerName}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
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
                            color: quadrante % 2 == 0
                                ? Colors.pink
                                : Colors.purple,
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
                                    print(
                                        "Quadrante: $quadrante, Número: $numero"),
                                    setState(() {
                                      if (vazios.contains(
                                          Tuple2(quadrante, numero))) {
                                        quadradoSelecionado = [
                                          quadrante,
                                          numero
                                        ];
                                      }
                                    })
                                  },
                                  child: Container(
                                    color:
                                        quadradoSelecionado[0] == quadrante &&
                                                quadradoSelecionado[1] == numero
                                            ? Colors.pink.shade100
                                            : vazios.contains(
                                                    Tuple2(quadrante, numero))
                                                ? Colors.white
                                                : Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: Text(
                                      matrix[quadrante][numero] == -1
                                          ? ""
                                          : matrix[quadrante][numero]
                                              .toString(),
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
              ),
              SizedBox(height: 20),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton(
                      onPressed: () {
                        changeMatrix(1);
                      },
                      child: Text(
                        "1",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(2);
                      },
                      child: Text(
                        "2",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(3);
                      },
                      child: Text(
                        "3",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(4);
                      },
                      child: Text(
                        "4",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(5);
                      },
                      child: Text(
                        "5",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(6);
                      },
                      child: Text(
                        "6",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(7);
                      },
                      child: Text(
                        "7",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(8);
                      },
                      child: Text(
                        "8",
                      )),
                  FilledButton(
                      onPressed: () {
                        changeMatrix(9);
                      },
                      child: Text(
                        "9",
                      )),
                  OutlinedButton(
                      onPressed: () {
                        changeMatrix(-1);
                      },
                      child: const Icon(Icons.clear_rounded)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text("Novo Jogo")),
            ],
          ),
        ));
  }
}
