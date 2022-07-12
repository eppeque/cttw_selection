import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:flutter/material.dart';

class PlayerSearchView extends SearchDelegate {
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

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      tooltip: 'Retour',
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

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

        // Filtrage des résultats
        final result = snapshot.data!.docs.where((element) {
          final player = element.data();

          return '${player.firstName} ${player.lastName}'
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();

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
