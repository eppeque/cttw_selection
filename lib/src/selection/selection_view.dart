import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:flutter/material.dart';

// TODO: Commenter ce widget + ajouter les données nécessaire sur Firestore + implémenter les tableaux pour chaque équipe
class SelectionView extends StatelessWidget {
  final TabController controller;

  const SelectionView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final ref = FirebaseFirestore.instance.collection('teams').withConverter(
          fromFirestore: Team.fromFirestore,
          toFirestore: (Team team, _) => team.toFirestore(),
        ).doc((controller.index + 1).toString());

        return StreamBuilder<DocumentSnapshot<Team>>(
          stream: ref.snapshots(),
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
