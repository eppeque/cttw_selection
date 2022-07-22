import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/players_listing/players_database.dart';
import 'package:cttw_selection/src/selection/team.dart';

/// Représente la base de données des équipes.
/// Utilisée pour la sélection des joueurs.
class TeamsDatabase {
  /// L'instance de la base de données
  static final _db = FirebaseFirestore.instance;

  /// La collection des équipes
  final teamsCol = _db.collection('teams').withConverter(
        fromFirestore: Team.fromFirestore,
        toFirestore: (Team team, _) => team.toFirestore(),
      );

  /// Récupère la liste des joueurs sélectionnés dans une équipe
  Future<List<Player>> getPlayers(Team team) async {
    final playersDatabase = PlayersDatabase();

    final result = <Player>[];

    result.add(await playersDatabase.getPlayer(team.player1));
    result.add(await playersDatabase.getPlayer(team.player2));
    result.add(await playersDatabase.getPlayer(team.player3));
    result.add(await playersDatabase.getPlayer(team.player4));

    return result;
  }

  /// Met à jour la date et l'heure de la rencontre d'une équipe
  Future<void> updateDateTime(String teamId, DateTime newDateTime) async {
    await teamsCol.doc(teamId).update(
      {'dateTime': newDateTime.millisecondsSinceEpoch},
    );
  }

  /// Met à jour l'adversaire d'une équipe
  Future<void> updateOpponent(String teamId, String newOpponent) async {
    final ref = teamsCol.doc(teamId);
    await ref.update({'opponent': newOpponent});
  }
}