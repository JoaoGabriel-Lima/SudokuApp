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
  Future<List<Partida>> _partidasFuture =
      DatabaseService.instance.buscarPartidas(dificuldade: -1);

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buscarPartidas();
    });
  }

  _buscarPartidas({int dificuldadeFiltro = -1}) async {
    List<Partida> dados =
        await databaseService.buscarPartidas(dificuldade: dificuldadeFiltro);
    setState(() {
      _partidas = dados;
      _partidasFuture =
          databaseService.buscarPartidas(dificuldade: dificuldadeFiltro);
    });
  }

  final difficultyMap = {
    0: "Fácil",
    1: "Médio",
    2: "Difícil",
    3: "Expert",
  };

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
      body: Padding(
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
                      setState(() {
                        _difficulty = value ?? -1;
                        _buscarPartidas(dificuldadeFiltro: value ?? -1);
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
                      future: _partidasFuture,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              title: Text(
                                  "Jogador: ${snapshot.data![index].name} | Dificuldade: ${difficultyMap[snapshot.data![index].level]}"),
                              subtitle: Text(snapshot.data![index].date),
                              trailing: Text(snapshot.data![index].result == 1
                                  ? 'Vitória'
                                  : 'Derrota'),
                            ));
                          },
                          itemCount: snapshot.data?.length ?? 0,
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
