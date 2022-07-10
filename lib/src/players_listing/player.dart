import 'package:cloud_firestore/cloud_firestore.dart';

/// Représente un joueur de tennis de table.
/// Tous les joueurs se trouvent
/// dans la liste de force stockée en base de données (Firestore).
class Player {
  /// L'ID du joueur
  final int id;

  /// L'index du joueur
  final int index;

  /// Le n° d'affiliation du joueur
  final int affiliation;

  /// Le prénom du joueur
  final String firstName;

  /// Le nom du joueur
  final String lastName;

  /// Le classement du joueur
  final String ranking;

  /// Crée un joueur avec :
  /// - un [id]
  /// - un [index]
  /// - un n° d'[affiliation]
  /// - un prénom = [firstName]
  /// - un nom = [lastName]
  /// - un classement = [ranking]
  const Player({
    required this.id,
    required this.index,
    required this.affiliation,
    required this.firstName,
    required this.lastName,
    required this.ranking,
  });

  /// Crée un joueur sur base de données tirées de la base de données Firestore
  factory Player.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Player(
      id: data['id'] as int,
      index: data['index'] as int,
      affiliation: data['affiliation'] as int,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      ranking: data['ranking'] as String,
    );
  }

  /// Convertit ce joueur en une Map pouvant être stockée en base de données
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'index': index,
      'affiliation': affiliation,
      'firstName': firstName,
      'lastName': lastName,
      'ranking': ranking,
    };
  }
}