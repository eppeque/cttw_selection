import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';

/// Représente la base de données des joueurs.
/// Utilisée pour la liste de force.
class PlayersDatabase {
  // L'instance de la base de données
  static final _db = FirebaseFirestore.instance;

  /// La collection des joueurs
  final _playersCol = _db.collection('players').withConverter(
        fromFirestore: Player.fromFirestore,
        toFirestore: (Player player, _) => player.toFirestore(),
      );

  /// Ajoute un joueur en base de données
  Future<void> addPlayer(Player player) async {
    // On met à jour les ids si besoin
    await _updateIds(player.id);

    // On ajoute le nouveau joueur
    await _playersCol
        .doc(player.id.toString())
        .set(player);

    // On met à jour les index après l'ajout
    await _updateIndex();
  }

  /// Met à jour un joueur dans la base de données
  Future<void> updatePlayer(Player player) async {
    // TODO: Mettre à jour un joueur
  }

  /// Supprime un joueur de la base de données sur base de l'ID de ce joueur.
  Future<void> removePlayer() async {
    // TODO: Supprimer un joueur
  }

  /// Met à jour les ids de tous les joueurs.
  /// Cette méthode est utile lorsque la liste des joueurs est modifiée.
  /// C'est pourquoi cette méthode n'est utilisée
  /// que lors de l'ajout et la suppression d'un joueur.
  Future<void> _updateIds(int id) async {
    final players = await _playersCol.get();

    // On vérifie si l'ID existe déjà
    for (final player in players.docs) {
      // L'ID existe déjà ?
      if (player.id == id.toString()) {
        // On augmente les IDS de 1 puis on ajoute notre joueur
        for (var i = players.size; i >= int.parse(player.id); i--) {
          final p = await _playersCol.doc(i.toString()).get();

          await _playersCol.doc((i + 1).toString()).set(p.data()!);
        }
        break; // Sortie de la boucle et arrêt de la méthode
      }
    }
  }

  /// Met à jour les index des joueurs
  Future<void> _updateIndex() async {
    final players = await _playersCol.get();

    // L'ID du joueur parcouru
    var i = players.size;

    // L'index du classement parcouru
    var currentIndex = 0;

    // Le classement parcouru
    var currentRanking = '';

    // Tant qu'on est pas arrivé au premier joueur
    while (i > 0) {
      // Récupération de la référence du joueur sur base de son ID
      final playerRef = _playersCol.doc(i.toString());

      // Récupération du joueur
      final player = await playerRef.get().then(
        (value) {
          return value.data()!;
        }
      );

      // Si le classement du joueur parcouru est E6 ou NC
      if (player.ranking == 'E6' || player.ranking == 'NC') {
        // Mise à jour de l'index tel que : index = dernier ID
        await playerRef.update({'index': players.size});
      } else {
        // Si le classement du joueur parcouru est différent du classement qu'on parcourt
        if (currentRanking != player.ranking) {
          // Mise à jour de l'index parcouru
          currentIndex = int.parse(playerRef.id);

          // Mise à jour du classement parcouru
          currentRanking = player.ranking;
        }

        // Mise à jour de l'index du joueur parcouru tel que : index = index parcouru
        await playerRef.update({'index': currentIndex});
      }
      // i = i - 1 afin de remonter la liste des joueurs
      i--;
    }
  }
}