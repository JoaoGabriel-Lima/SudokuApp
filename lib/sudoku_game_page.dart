import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class SudokuGamePage extends StatefulWidget {
  const SudokuGamePage({super.key, this.dificuldadeSelecionada = "easy"});
  final String dificuldadeSelecionada;

  @override
  State<SudokuGamePage> createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage> {
  Sudoku sudoku = Sudoku.generate(Level.easy);

  @override
  Widget build(BuildContext context) {
    sudoku.debug();
    // sudoku.puzzle is a int array with 81 elements (9x9), transform into a matrix with 3x3 sub-matrix
    List<List<int>> matrix = List.generate(
        9, (i) => List.generate(9, (j) => sudoku.puzzle[i * 9 + j]));
    print(matrix);

    return Center(
      child: Column(
        children: [
          Text("Dificuldade: ${widget.dificuldadeSelecionada}"),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
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
                            return Container(
                              color: Colors.white,
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
