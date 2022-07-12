import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/players_listing/players_database.dart';
import 'package:flutter/material.dart';

/// Pop-up qui permet d'ajouter ou de modifier un joueur dans la liste de force.
/// Le widget peut prendre un joueur en paramètres :
/// - Si un joueur est donné -> le pop-up modifie un joueur
/// - Si rien n'est donné (et que le joueur est null) -> Le pop-up crée un joueur
class AddPlayerDialog extends StatefulWidget {
  final Player? player;

  const AddPlayerDialog({super.key, this.player});

  /// Détermine si le joueur est donné ou non
  bool get isPlayerSet => player != null;

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _formKey = GlobalKey<FormState>();

  // Les données fournies dans le formulaire
  String _id = ''; // l'ID
  String _affiliation = ''; // Le n° d'affiliation
  String _firstName = ''; // Le prénom
  String _lastName = ''; // Le nom
  String _ranking = ''; // Le classement

  @override
  void initState() {
    super.initState();

    if (widget.isPlayerSet) {
      _id = widget.player!.id.toString();
      _affiliation = widget.player!.affiliation.toString();
      _firstName = widget.player!.firstName;
      _lastName = widget.player!.lastName;
      _ranking = widget.player!.ranking;
    }
  }

  /// Valide ou non les données sous forme d'entier provenant d'un formulaire
  String? _validateIntValue(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez spécifier un $fieldName';
    }

    try {
      int.parse(value);
    } catch (_) {
      return 'Veuillez spécifier un nombre';
    }

    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez spécifier un $fieldName';
    }

    return null;
  }

  String? _validateRanking(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez spécifier un classement';
    }

    final regex = RegExp(r'([B-E](0|2|4|6))|NC');

    if (!regex.hasMatch(value)) {
      return 'Format invalide';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Le titre du pop-up
      title: Text(widget.isPlayerSet ? 'Modifier le joueur' : 'Nouveau joueur'),

      // Le contenu avec le formulaire
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Le champ ID
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Code'),
                border: OutlineInputBorder(),
              ),
              initialValue: _id,
              onChanged: (value) => setState(() => _id = value),
              autofocus: true,
              keyboardType: TextInputType.number,
              validator: (value) => _validateIntValue(value, 'code'),
            ),

            const SizedBox(height: 20.0),

            // Le champ n° d'affiliation
            TextFormField(
              decoration: const InputDecoration(
                label: Text("N°d'affiliation"),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _affiliation = value),
              initialValue: _affiliation,
              keyboardType: TextInputType.number,
              validator: (value) => _validateIntValue(value, "n° d'affiliation"),
            ),

            const SizedBox(height: 20.0),

            // Le champ prénom
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Prénom'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _firstName = value),
              initialValue: _firstName,
              validator: (value) => _validateName(value, 'prénom'),
            ),

            const SizedBox(height: 20.0),

            // Le champ nom
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Nom'),
                border: OutlineInputBorder(),
              ),
              initialValue: _lastName,
              onChanged: (value) => setState(() => _lastName = value),
              validator: (value) => _validateName(value, 'nom'),
            ),

            const SizedBox(height: 20.0),

            // Le champ classement
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Classement'),
                border: OutlineInputBorder(),
              ),
              initialValue: _ranking,
              onChanged: (value) => setState(() => _ranking = value),
              validator: _validateRanking,
            ),
          ],
        ),
      ),
      actions: [
        // Bouton d'annulation
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),

        // Bouton de confirmation
        ElevatedButton(
          onPressed: () async {
            // Si tous les champs du formulaire sont valides
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context); // On ferme le pop-up

              // Création de l'objet représentant la base de données
              // afin de pouvoir modifier les données à l'intérieur
              final playersDatabase = PlayersDatabase();

              // Création du joueur à ajouter ou modifier dans la base de données
              final newPlayer = Player(
                id: int.parse(_id),
                // Si le joueur est créé, l'index sera calculé par l'algorithme de calcul des index
                // Si le joueur est modifié, l'index ne sera pas calculé, c'est pourquoi il faut donner l'ancien index
                index: widget.player?.id ?? 0,
                affiliation: int.parse(_affiliation),
                firstName: _firstName,
                lastName: _lastName,
                ranking: _ranking,
              );

              // On vérifie s'il faut modifier ou ajouter le joueur
              if (widget.isPlayerSet) {
                await playersDatabase.updatePlayer(
                  widget.player!.id,
                  newPlayer,
                );

                return;
              }

              await playersDatabase.addPlayer(newPlayer);
            }
          },
          child: Text(widget.isPlayerSet ? 'Modifier' : 'Ajouter'),
        ),
      ],
    );
  }
}