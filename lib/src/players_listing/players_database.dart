import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';

/// Représente la base de données des joueurs.
/// Utilisée pour la liste de force.
class PlayersDatabase {
  /// L'instance de la base de données
  static final _db = FirebaseFirestore.instance;

  /// La collection des joueurs
  final _playersCol = _db.collection('players').withConverter(
        fromFirestore: Player.fromFirestore,
        toFirestore: (Player player, _) => player.toFirestore(),
      );

  /// Ajoute un joueur en base de données
  Future<void> addPlayer(Player player) async {
    // Mise à jour des ids si besoin
    await _updateIdsForCreation(player.id);

    // Ajout du nouveau joueur
    await _playersCol.doc(player.id.toString()).set(player);

    // Mise à jour des index après l'ajout
    await _updateIndex();
  }

  /// Met à jour un joueur dans la base de données
  Future<void> updatePlayer(int oldId, Player newPlayer) async {
    // Si l'ID n'a pas été modifié
    if (oldId != newPlayer.id) {
      // Suppression du joueur en base de données
      // + mise à jour des ids
      await removePlayer(oldId);

      // Rajout du joueur en base de données
      await addPlayer(newPlayer);
    }

    // Simple remplacement des données du joueur
    await _playersCol.doc(oldId.toString()).set(newPlayer);
  }

  /// Supprime un joueur de la base de données sur base de l'ID de ce joueur.
  Future<void> removePlayer(int id) async {
    // Mise à jour des ids si besoin avec remplacement du joueur à supprimer
    await _updateIdsForDeletion(id);

    // Mise à jour des index
    await _updateIndex();
  }

  /// Met à jour les ids de tous les joueurs.
  /// Cette méthode est utile lorsque la liste des joueurs est modifiée.
  /// C'est pourquoi cette méthode n'est utilisée
  /// que lors de l'ajout et la suppression d'un joueur.
  Future<void> _updateIdsForCreation(int id) async {
    final players = await _playersCol.get();

    if (id == players.size + 1) return;

    // On vérifie si l'ID existe déjà
    for (final player in players.docs) {
      // L'ID existe déjà ?
      if (player.id == id.toString()) {
        // Augmentation des ids de 1 des joueurs suivants
        for (var i = players.size; i >= id; i--) {
          final p = await _playersCol.doc(i.toString()).get();

          // Le joueur avec le nouvel ID à stocker en base de données
          final playerWithNewId = Player(
            id: i + 1,
            index: p.data()!.index,
            affiliation: p.data()!.affiliation,
            firstName: p.data()!.firstName,
            lastName: p.data()!.lastName,
            ranking: p.data()!.ranking,
          );

          await _playersCol.doc((i + 1).toString()).set(playerWithNewId);
        }
        break; // Sortie de la boucle et arrêt de la méthode
      }
    }
  }

  Future<void> _updateIdsForDeletion(int id) async {
    // Récupération des joueurs
    final players = await _playersCol.get();

    // Suppression du joueur demandé
    await _playersCol.doc(id.toString()).delete();

    // Si le joueur à supprimer est le dernier joueur dans la liste,
    // il n'est pas nécessaire de mettre à jour les ids
    if (id == players.size) return;

    // Parcours de la liste à partir du prochain joueur
    for (var i = id + 1; i <= players.size; i++) {
      final p = await _playersCol.doc(i.toString()).get();

      // Le joueur avec le nouvel ID à stocker en base de données
      final playerWithNewId = Player(
        id: i - 1,
        index: p.data()!.index,
        affiliation: p.data()!.affiliation,
        firstName: p.data()!.firstName,
        lastName: p.data()!.lastName,
        ranking: p.data()!.ranking,
      );

      await _playersCol.doc((i - 1).toString()).set(playerWithNewId);
    }

    await _playersCol.doc(players.size.toString()).delete();
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
      final player = await playerRef.get().then((value) {
        return value.data()!;
      });

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
