import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:cttw_selection/src/page_manager.dart';
import 'package:flutter/material.dart';

// TODO: Implémenter les tableaux pour chaque équipe

/// Interface contenant les tableaux de sélection des joueurs pour les équipes.
/// Ce widget réagit dynamiquement aux onglets affichés sur [PageManager].
/// Ces onglets permettent de sélectionner l'équipe à afficher.
class SelectionView extends StatelessWidget {
  /// Le contrôleur d'onglets initialisé dans [PageManager]
  final TabController controller;

  const SelectionView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder remplace une solution toute faite, à savoir TabBarView.
    // TabBarView permet de réagir au contrôleur mais
    // doit obligatoirement comporter le même nombre de pages que d'onglets.
    // Ce n'est pas la solution recherchée car ici,
    // on veut la même interface pour chaque équipe.
    // C'est pourquoi, AnimatedBuilder est une solution personnalisée car
    // elle rafraîchit l'interface à chaque changement d'onglet et permet
    // d'avoir une seule et même interface
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Le document contenant les données de l'équipe sélectionnée
        final doc = FirebaseFirestore.instance.collection('teams').withConverter(
          fromFirestore: Team.fromFirestore,
          toFirestore: (Team team, _) => team.toFirestore(),
        ).doc((controller.index + 1).toString());

        // Récupère et affiche le tableau de sélection
        return StreamBuilder<DocumentSnapshot<Team>>(
          stream: doc.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Une erreur s'est produite :/"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final team = snapshot.data!.data()!;

            return Center(
              child: Text(team.opponent),
            );
          }
        );
      },
    );
  }
}