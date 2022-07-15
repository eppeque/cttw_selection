import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/selection/team.dart';
import 'package:cttw_selection/src/page_manager.dart';
import 'package:flutter/material.dart';

// TODO: Ordonner le code (classe TeamDatabase ?) + Commenter cette classe + implémenter changement joueur + couleur quand changement

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
  Future<List<Player>> _getPlayers(Team team) async {
    final result = <Player>[];

    result.add(await _getPlayer(team.player1));
    result.add(await _getPlayer(team.player2));
    result.add(await _getPlayer(team.player3));
    result.add(await _getPlayer(team.player4));

    return result;
  }

  Future<Player> _getPlayer(int playerId) async {
    final ref = await FirebaseFirestore.instance
        .collection('players')
        .withConverter(
          fromFirestore: Player.fromFirestore,
          toFirestore: (Player player, _) => player.toFirestore(),
        )
        .doc(playerId.toString())
        .get();

    return ref.data()!;
  }

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

  String _dateTimeToString(DateTime dateTime) {
    final minute = dateTime.minute == 0 ? '00' : dateTime.minute.toString();
    return '${_getWeekdayName(dateTime.weekday)} ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}h$minute';
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
      animation: widget.controller,
      builder: (context, _) {
        // Le document contenant les données de l'équipe sélectionnée
        final doc = FirebaseFirestore.instance
            .collection('teams')
            .withConverter(
              fromFirestore: Team.fromFirestore,
              toFirestore: (Team team, _) => team.toFirestore(),
            )
            .doc((widget.controller.index + 1).toString());

        // Récupère et affiche le tableau de sélection
        return StreamBuilder<DocumentSnapshot<Team>>(
          stream: doc.snapshots(),
          builder: (context, teamSnapshot) {
            if (teamSnapshot.hasError) {
              return const Center(
                child: Text("Une erreur s'est produite :/"),
              );
            }

            if (teamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final team = teamSnapshot.data!.data()!;
            final opponentController =
                TextEditingController(text: team.opponent);

            return FutureBuilder<List<Player>>(
              future: _getPlayers(team),
              builder: (context, playerSnapshot) {
                if (playerSnapshot.hasError) {
                  return const Center(
                    child: Text("Une erreur s'est produite :/"),
                  );
                }

                if (playerSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final rows = <TableRow>[];

                rows.add(
                  const TableRow(
                    children: [
                      Text(
                        'Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nom et prénom',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Classement',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Index',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );

                rows.addAll(playerSnapshot.data!.map(
                  (player) {
                    return TableRow(
                      children: [
                        Text(
                          player.id.toString(),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${player.firstName} ${player.lastName}'
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          player.ranking,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          player.index.toString(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  },
                ).toList());

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _dateTimeToString(team.dateTime),
                      style: const TextStyle(fontSize: 28.0),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final date = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: now,
                          lastDate: now.add(
                            const Duration(days: 365),
                          ),
                        );

                        if (date == null) return;

                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time == null) return;

                        final dateTime = DateTime(date.year, date.month,
                            date.day, time.hour, time.minute);

                        await FirebaseFirestore.instance
                            .collection('teams')
                            .doc(teamSnapshot.data!.id)
                            .update(
                          {'dateTime': dateTime.millisecondsSinceEpoch},
                        );
                      },
                      child: const Text("Changer la date et l'heure"),
                    ),
                    Text(
                      team.opponent,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 48.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          label: Text('Adversaire'),
                        ),
                        controller: opponentController,
                        onSubmitted: (value) async {
                          final ref = FirebaseFirestore.instance
                              .collection('teams')
                              .doc(teamSnapshot.data!.id);

                          await ref.update({'opponent': value});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: rows,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}