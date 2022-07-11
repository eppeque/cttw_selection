import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/players_listing/players_database.dart';
import 'package:flutter/material.dart';

class DeletePlayerDialog extends StatelessWidget {
  final Player player;

  const DeletePlayerDialog({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text('Supprimer le joueur "${player.firstName} ${player.lastName}"'),
      content: Text(
        'Êtes-vous sûr de vouloir supprimer le joueur "${player.firstName} ${player.lastName}" ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final playersDatabase = PlayersDatabase();
            await playersDatabase.removePlayer(player.id);
          },
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}