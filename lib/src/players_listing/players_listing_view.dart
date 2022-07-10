import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/add_player_dialog.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:flutter/material.dart';

class PlayersListingView extends StatelessWidget {
  const PlayersListingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('players').withConverter(
          fromFirestore: Player.fromFirestore,
          toFirestore: (Player player, _) => player.toFirestore(),
        );

    return StreamBuilder<QuerySnapshot<Player>>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        // Une erreur s'est produite
        if (snapshot.hasError) {
          return const Text("Une erreur s'est produite :/");
        }

        // Chargement en cours...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // On trie la liste des joueurs dans l'ordre chroissant des ids
        snapshot.data!.docs.sort((a, b) => a.id.compareTo(b.id));

        // Affichage de la liste
        return ListView(
          children: snapshot.data!.docs.map((p) {
            final player = p.data();
            return ListTile(
              leading: Text(player.id.toString()),
              title: Text(
                '${player.firstName} ${player.lastName.toUpperCase()}',
              ),
              subtitle: Text(
                  "N°d'affiliation : ${player.affiliation}\nIndex : ${player.index}"),
              trailing: Text(player.ranking),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddPlayerDialog(player: player),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}