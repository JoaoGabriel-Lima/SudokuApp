import 'package:flutter/material.dart';
import 'package:sudoku/main.dart';
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
  late List<List<int>> matrizSolucao;
  late List<Tuple2<int, int>> vazios;
  late List<int> quadradoSelecionado;
  ValueNotifier<int> dialogTrigger = ValueNotifier(0);

  List<List<int>> changeMatrix(int value) {
    int pos1 = quadradoSelecionado[0];
    int pos2 = quadradoSelecionado[1];
    if (!vazios.contains(Tuple2(pos1, pos2))) return matrix;
    setState(() {
      matrix[pos1][pos2] = value;
    });
    return matrix;
  }

  bool verificarErro(int quadrante, int numero) {
    // verificando quadrante
    for (int i = 0; i < 9; i++) {
      if (matrix[quadrante][i] == matrix[quadrante][numero] &&
          i != numero &&
          matrix[quadrante][i] != -1) {
        return true;
      }
    }

    // verificando linha
    int numeroAtual = matrix[quadrante][numero];
    int inicioDaLinha = (quadrante ~/ 3) * 3;
    int linhaDoQuadrante = (numero ~/ 3) * 3;

    for (int i = inicioDaLinha; i < inicioDaLinha + 3; i++) {
      if (numeroAtual == -1) continue;
      for (int j = linhaDoQuadrante; j < linhaDoQuadrante + 3; j++) {
        if (matrix[i][j] == matrix[quadrante][numero] &&
            (Tuple2(i, j) != Tuple2(quadrante, numero)) &&
            matrix[i][j] != -1) {
          return true;
        }
      }
    }

    int coluna = (quadrante % 3) * 3 + (numero % 3);
    int linha = (quadrante ~/ 3) * 3 + (numero ~/ 3);
    for (int r = 0; r < 9; r++) {
      if (matrix[r ~/ 3 * 3 + coluna ~/ 3][coluna % 3 + r % 3 * 3] ==
              matrix[quadrante][numero] &&
          r != linha &&
          matrix[r ~/ 3 * 3 + coluna ~/ 3][coluna % 3 + r % 3 * 3] != -1) {
        return true;
      }
    }

    return false;
  }

  Color coresSudoku(int quadrante, int numero) {
    if (quadradoSelecionado[0] == quadrante &&
        quadradoSelecionado[1] == numero) {
      if (verificarErro(quadrante, numero)) {
        return Colors.red.shade800;
      }

      return Colors.pink.shade100;
    }

    if (vazios.contains(Tuple2(quadrante, numero))) {
      if (verificarErro(quadrante, numero)) {
        return Colors.red;
      }
      return Colors.white;
    } else {
      if (verificarErro(quadrante, numero)) {
        return Colors.red.shade300;
      }

      return Colors.grey.shade200;
    }
  }

  bool verificarVitoria() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (matrix[i][j] != matrizSolucao[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  void initState() {
    quadradoSelecionado = [-1, -1];

    level = getLevel();
    Sudoku sudoku = Sudoku.generate(level);

    List<List<int>> indices = [
      [0, 1, 2, 9, 10, 11, 18, 19, 20],
      [3, 4, 5, 12, 13, 14, 21, 22, 23],
      [6, 7, 8, 15, 16, 17, 24, 25, 26],
      [27, 28, 29, 36, 37, 38, 45, 46, 47],
      [30, 31, 32, 39, 40, 41, 48, 49, 50],
      [33, 34, 35, 42, 43, 44, 51, 52, 53],
      [54, 55, 56, 63, 64, 65, 72, 73, 74],
      [57, 58, 59, 66, 67, 68, 75, 76, 77],
      [60, 61, 62, 69, 70, 71, 78, 79, 80],
    ];
    matrix = [];
    matrizSolucao = [];
    for (var indice in indices) {
      List<int> sublista = indice.map((i) => sudoku.puzzle[i]).toList();
      matrix.add(sublista);
    }
    for (var indice in indices) {
      List<int> sublista = indice.map((i) => sudoku.solution[i]).toList();
      matrizSolucao.add(sublista);
    }

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
                                    color: coresSudoku(quadrante, numero),
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
                spacing: 5,
                runSpacing: 5,
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
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(context);
                      },
                      child: Text("Novo Jogo")),
                  FilledButton(
                    onPressed: !verificarVitoria()
                        ? null
                        : () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Parabéns!'),
                                content: const Text('Você venceu o jogo!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Fechar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RootPage())),
                                    child: const Text('Novo Jogo'),
                                  ),
                                ],
                              ),
                            ),
                    child: const Text('Verificar'),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
