import 'package:cloud_firestore/cloud_firestore.dart';

/// Représente une équipe de tennis de table.
/// Une équipe comporte 4 joueurs, un adversaire à affronter et
/// la date et l'heure de la rencontre.
class Team {
  /// L'ID du premier joueur
  final int player1;

  /// L'ID du deuxième joueur
  final int player2;

  /// L'ID du troisième joueur
  final int player3;

  /// L'ID du quatrième joueur
  final int player4;

  /// Le nom de l'équipe adverse
  final String opponent;

  /// La date et l'heure de la rencontre.
  /// En base de données, la date et l'heure est stockée sous forme
  /// d'entier repérentant le timestamp
  final DateTime dateTime;

  /// Crée une équipe avec :
  /// - l'ID du premier joueur = [player1]
  /// - l'ID du deuxième joueur = [player2]
  /// - l'ID du troisième joueur = [player3]
  /// - l'ID du quatrième joueur = [player4]
  /// - le nom de l'opposant = [opponent]
  /// - la date et l'heure convertie du timestamp vers la classe [DateTime]
  const Team({
    required this.player1,
    required this.player2,
    required this.player3,
    required this.player4,
    required this.opponent,
    required this.dateTime,
  });

  /// Crée une équipe depuis les données tirées de la base de données Firestore
  factory Team.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return Team(
      player1: data['player1'] as int,
      player2: data['player2'] as int,
      player3: data['player3'] as int,
      player4: data['player4'] as int,
      opponent: data['opponent'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
    );
  }

  /// Convertit cette équipe en une Map pouvant être stockée en base de données
  Map<String, dynamic> toFirestore() {
    return {
      'player1': player1,
      'player2': player2,
      'player3': player3,
      'player4': player4,
      'opponent': opponent,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}