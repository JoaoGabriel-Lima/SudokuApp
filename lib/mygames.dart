import 'package:flutter/material.dart';
import 'package:sudoku/models/partida.dart';
import 'package:sudoku/services/database_service.dart';

class MyGames extends StatefulWidget {
  const MyGames({super.key});

  @override
  State<MyGames> createState() => _MyGamesState();
}

class _MyGamesState extends State<MyGames> {
  final DatabaseService databaseService = DatabaseService.instance;
  int _difficulty = -1;
  List<Partida> _partidas = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buscarPartidas();
    });
  }

  _buscarPartidas() async {
    List<Partida> dados = await databaseService.buscarPartidas();
    setState(() {
      _partidas = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Partidas'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Center(
          child: Column(
            children: [
              // create a list of checkboxes to filter the games by difficulty
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Filtrar por dificuldade:  ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton<int>(
                    value: _difficulty,
                    items: [
                      DropdownMenuItem(
                        value: -1,
                        child: const Text('Todas'),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: const Text('Fácil'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: const Text('Médio'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: const Text('Difícil'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: const Text('Expert'),
                      ),
                    ],
                    onChanged: (value) async {
                      List<Partida> dados = await databaseService
                          .buscarPartidas(dificuldade: _difficulty);
                      setState(() {
                        _difficulty = value!;
                        _partidas = dados;
                        // fetch the games from the database
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                          "Partidas Ganhas: ${_partidas.where((partida) => partida.result == 1).length ?? 0}"),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          "Partidas Perdidas: ${_partidas.where((partida) => partida.result == 0).length ?? 0}"),
                    ],
                  ),
                  FutureBuilder(
                      future: databaseService.buscarPartidas(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_partidas[index].name),
                              subtitle: Text(_partidas[index].date),
                              trailing: Text(_partidas[index].level.toString()),
                            );
                          },
                          itemCount: _partidas.length,
                        );
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
