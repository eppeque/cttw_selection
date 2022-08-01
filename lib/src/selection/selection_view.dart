import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/selection/players_table.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:cttw_selection/src/page_manager.dart';
import 'package:cttw_selection/src/selection/teams_database.dart';
import 'package:flutter/material.dart';

// TODO: Implémenter changement joueur + couleur quand changement

/// Interface contenant les tableaux de sélection des joueurs pour les équipes.
/// Ce widget réagit dynamiquement aux onglets affichés sur [PageManager].
/// Ces onglets permettent de sélectionner l'équipe à afficher.
class SelectionView extends StatefulWidget {
  /// Le contrôleur d'onglets initialisé dans [PageManager]
  final TabController controller;

  const SelectionView({super.key, required this.controller});

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  /// Objet représentant la base de données des équipes
  /// afin de pouvoir modifier les données à l'intérieur
  final teamsDatabase = TeamsDatabase();

  /// Donne le nom du jour selon sa position dans la semaine
  String _getWeekdayName(int weekdayPos) {
    switch (weekdayPos) {
      case 1:
        return 'Lundi';
      case 2:
        return 'Mardi';
      case 3:
        return 'Mercredi';
      case 4:
        return 'Jeudi';
      case 5:
        return 'Vendredi';
      case 6:
        return 'Samedi';
      default:
        return 'Dimanche';
    }
  }

  /// Convertit une date en une chaîne de caractères lisisble
  String _dateTimeToString(DateTime dateTime) {
    // Les minutes s'affichent avec un seul zéro par défaut.
    // On modifie ce comportement par défaut ici.
    final minute = dateTime.minute == 0 ? '00' : dateTime.minute.toString();
    return '${_getWeekdayName(dateTime.weekday)} ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}h$minute';
  }

  /// Affiche à l'utilisateur la sélection d'une date et d'une heure et met à jour la base de données
  Future<void> _setDateTime(String teamId) async {
    // Date et heure actuelles
    final now = DateTime.now();

    // Affiche à l'utilisateur la sélection d'une date
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(
        const Duration(days: 365),
      ),
    );

    // Si aucune date n'a été encodée, on abandonne
    if (date == null) return;

    // Affiche à l'utilisateur la sélection d'une heure
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    // Si aucune heure n'a été encodée, on abandonne
    if (time == null) return;

    // Création de l'objet date/heure
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    // Mise à jour de la base de données
    await teamsDatabase.updateDateTime(teamId, dateTime);
  }

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
      // Le contrôleur d'onglets
      animation: widget.controller,
      builder: (context, _) {
        // Le document contenant les données de l'équipe sélectionnée
        final doc = teamsDatabase.teamsCol
            .doc((widget.controller.index + 1).toString());

        // Récupère et affiche la page d'une équipe
        return StreamBuilder<DocumentSnapshot<Team>>(
          stream: doc.snapshots(),
          builder: (context, teamSnapshot) {
            // Une erreur s'est produite ?
            if (teamSnapshot.hasError) {
              return const Center(
                child: Text("Une erreur s'est produite :/"),
              );
            }

            // Chargement...
            if (teamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Récupération de l'objet représentant l'équipe sélectionnée
            final team = teamSnapshot.data!.data()!;

            // Contôleur de modification de texte pour la saisie de l'adversaire.
            // Ce contrôleur est nécessaire pour préremplir le champ avec l'adversire précédemment sélectionné.
            final opponentController =
                TextEditingController(text: team.opponent);

            return ListView(
              children: [
                // Texte affichant la date et l'heure de la rencontre
                Text(
                  _dateTimeToString(team.dateTime),
                  style: const TextStyle(fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20.0),

                // Bouton pour modifier la date et l'heure
                Stack(
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () async =>
                            await _setDateTime(teamSnapshot.data!.id),
                        child: const Text("Changer la date et l'heure"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                // Texte affichant l'adversaire
                Text(
                  team.opponent,
                  style: const TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 48.0,
                  ),
                  // Champ de texte permettant de modifier l'adversaire
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text('Adversaire'),
                    ),
                    controller: opponentController,
                    onSubmitted: (value) async {
                      // Mise à jour de la base de données
                      await teamsDatabase.updateOpponent(
                        teamSnapshot.data!.id,
                        value,
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Affichage du tableau des joueurs sléectionnés
                  child: PlayersTable(database: teamsDatabase, team: team),
                ),
              ],
            );
          },
        );
      },
    );
  }
}