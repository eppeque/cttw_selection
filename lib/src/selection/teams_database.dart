import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/selection/team.dart';

class TeamsDatabase {
  static final _db = FirebaseFirestore.instance;

  final teamsCol = _db.collection('teams').withConverter(
        fromFirestore: Team.fromFirestore,
        toFirestore: (Team team, _) => team.toFirestore(),
      );

  Future<Player> _getPlayer(int playerId) async {
    final ref = await FirebaseFirestore.instance
        .collection('players')
        .withConverter(
          fromFirestore: Player.fromFirestore,
          toFirestore: (Player player, _) => player.toFirestore(),
        )
        .doc(playerId.toString())
        .get();

    return ref.data()!;
  }

  Future<List<Player>> getPlayers(Team team) async {
    final result = <Player>[];

    result.add(await _getPlayer(team.player1));
    result.add(await _getPlayer(team.player2));
    result.add(await _getPlayer(team.player3));
    result.add(await _getPlayer(team.player4));

    return result;
  }

  Future<void> updateDateTime(String teamId, DateTime newDateTime) async {
    await teamsCol.doc(teamId).update(
      {'dateTime': newDateTime.millisecondsSinceEpoch},
    );
  }

  Future<void> updateOpponent(String teamId, String newOpponent) async {
    final ref = teamsCol.doc(teamId);
    await ref.update({'opponent': newOpponent});
  }
}