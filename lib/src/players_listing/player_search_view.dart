import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:flutter/material.dart';

/// L'interface de recherche d'un joueur
class PlayerSearchView extends SearchDelegate {

  /// Dessine les widgets à mettre à la fin de [AppBar]
  /// Dans cette app, c'est basiquement un bouton qui
  /// permet de réinitialiser la requête
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        tooltip: 'Effacer la requête',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  /// Dessine le widget à mettre au début de [AppBar]
  /// Dans cette app, c'est un bouton qui permet de fermer la page de recherche
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      tooltip: 'Retour',
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// Dessine les résultats de la recherche
  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  /// Dessine les suggesitions au fur et à mesure
  /// que l'utilisateur tape sa requête
  @override
  Widget buildSuggestions(BuildContext context) {
    // La référence de la collection contenant les joueurs
    final ref = FirebaseFirestore.instance.collection('players').withConverter(
          fromFirestore: Player.fromFirestore,
          toFirestore: (Player player, _) => player.toFirestore(),
        );

    return StreamBuilder<QuerySnapshot<Player>>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        // Une erreur s'est produite
        if (snapshot.hasError) {
          return const Center(
            child: Text("Une erreur s'est produite :/"),
          );
        }

        // Chargement en cours...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filtrage des résultats.
        // C'est ici que la recherche s'effectue.
        final result = snapshot.data!.docs.where((element) {
          final player = element.data();

          return '${player.firstName} ${player.lastName}'
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();

        // Si la liste des résultats est vide,
        // affichage d'un message informant l'utilisateur
        if (result.isEmpty) {
          return const Center(
            child: Text(
              '¯\\_(ツ)_/¯\nAucun joueur trouvé...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
          );
        }

        // Affichage des résultats
        return ListView(
          children: result.map((element) {
            final player = element.data();

            return ListTile(
              leading: Text(player.id.toString()),
              title: Text(
                '${player.firstName} ${player.lastName.toUpperCase()}',
              ),
              subtitle: Text(
                'N°affiliation : ${player.affiliation}\nIndex : ${player.index}',
              ),
              trailing: Text(player.ranking),
            );
          }).toList(),
        );
      },
    );
  }
}