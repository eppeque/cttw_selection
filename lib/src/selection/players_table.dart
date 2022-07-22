import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:cttw_selection/src/selection/teams_database.dart';
import 'package:flutter/material.dart';

class PlayersTable extends StatelessWidget {
  final TeamsDatabase database;
  final Team team;
  
  const PlayersTable({super.key, required this.database, required this.team});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: database.getPlayers(team),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Une erreur s'est produite :/"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final rows = <TableRow>[];

        rows.add(
          const TableRow(
            children: [
              Text(
                'Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nom et prénom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Classement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Index',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );

        rows.addAll(snapshot.data!.map(
          (player) {
            return TableRow(
              children: [
                Text(
                  player.id.toString(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${player.firstName} ${player.lastName}'.toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  player.ranking,
                  textAlign: TextAlign.center,
                ),
                Text(
                  player.index.toString(),
                  textAlign: TextAlign.center,
                )
              ],
            );
          },
        ).toList());

        return Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rows,
        );
      },
    );
  }
}