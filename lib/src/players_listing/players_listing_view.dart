import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/add_player_dialog.dart';
import 'package:cttw_selection/src/players_listing/delete_player_dialog.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:flutter/material.dart';

/// Représente l'affichage de la liste de force
class PlayersListingView extends StatelessWidget {
  const PlayersListingView({super.key});

  @override
  Widget build(BuildContext context) {
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

        // Affichage de la liste
        return ListView(
          children: snapshot.data!.docs.map((element) {
            final player = element.data();
            
            // Pour chaque joueur, on affiche une ligne avec les données du joueur
            return ListTile(
              leading: Text(player.id.toString()),
              title: Text(
                '${player.firstName} ${player.lastName.toUpperCase()}',
              ),
              subtitle: SelectableText(
                "N°d'affiliation : ${player.affiliation}\nIndex : ${player.index}",
              ),
              trailing: Text(player.ranking),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddPlayerDialog(player: player),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => DeletePlayerDialog(player: player),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}