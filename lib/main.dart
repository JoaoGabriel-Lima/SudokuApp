import 'package:flutter/material.dart';
import 'package:sudoku/sudoku_game_options.dart';
// import 'package:sudoku/sudoku_game_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      theme: ThemeData(
          primaryColor: Colors.pink,
          // primarySwatch: Colors.pink,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink),
          // scaffoldBackgroundColor: const Color.fromARGB(255, 255, 246, 249),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.pink,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('João Sudoku'),
        shadowColor: Colors.black,
        // backgroundColor: Colors.blue,
      ),
      body: const SudokuGameOptions(),
    );
  }
}
