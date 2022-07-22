import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:cttw_selection/src/selection/teams_database.dart';
import 'package:flutter/material.dart';

/// Tableau affichant les joueurs sélectionnés dans une équipe donnée
class PlayersTable extends StatelessWidget {
  /// La base de données des équipes
  final TeamsDatabase database;

  /// L'équipe pour laquelle les joueurs sélectionnés doivent être affichés
  final Team team;

  const PlayersTable({super.key, required this.database, required this.team});

  @override
  Widget build(BuildContext context) {
    // Récupère les joueurs en base de données
    return FutureBuilder<List<Player>>(
      future: database.getPlayers(team),
      builder: (context, snapshot) {
        // Une erreur ?
        if (snapshot.hasError) {
          return const Center(
            child: Text("Une erreur s'est produite :/"),
          );
        }

        // Chargement...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Création de la liste des lignes du tableau
        final rows = <TableRow>[];

        // Ajout de la première ligne contenant les titres des colonnes
        rows.add(
          const TableRow(
            children: [
              _TableTitle(title: 'Code'),
              _TableTitle(title: 'Nom et prénom'),
              _TableTitle(title: 'Classement'),
              _TableTitle(title: 'Index'),
            ],
          ),
        );

        // Ajout des lignes contenant les données de chaque joueur sélectionné.
        // Chaque ligne correspond à un joueur.
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

        // Le tableau
        return Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,

          // Les lignes créées précédemment
          children: rows,
        );
      },
    );
  }
}

/// Le titre d'une colonne pour le tableau de sélection
class _TableTitle extends StatelessWidget {
  /// Le titre à afficher
  final String title;

  const _TableTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}