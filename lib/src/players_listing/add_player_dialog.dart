import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cttw_selection/src/players_listing/player.dart';
import 'package:cttw_selection/src/players_listing/players_database.dart';
import 'package:flutter/material.dart';

class AddPlayerDialog extends StatefulWidget {
  final Player? player;

  const AddPlayerDialog({super.key, this.player});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _formKey = GlobalKey<FormState>();

  var _id = '';
  var _index = '';
  var _affiliation = '';
  var _firstName = '';
  var _lastName = '';
  var _ranking = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.player == null ? 'Nouveau joueur' : 'Modifier le joueur'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('ID'),
                border: OutlineInputBorder(),
              ),
              initialValue: widget.player?.id.toString(),
              onChanged: (value) => setState(() => _id = value),
              autofocus: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez spécifier un ID';
                }

                try {
                  int.parse(value);
                } catch (_) {
                  return 'Veuillez spécifier un nombre';
                }

                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Index'),
                border: OutlineInputBorder(),
              ),
              initialValue: widget.player?.index.toString(),
              onChanged: (value) => setState(() => _index = value),
              readOnly: widget.player != null,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez spécifier un index';
                }

                try {
                  int.parse(value);
                } catch (_) {
                  return 'Veuillez spécifier un nombre';
                }

                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("N°d'affiliation"),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _affiliation = value),
              initialValue: widget.player?.affiliation.toString(),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Veuillez spécifier un N°d'affiliation";
                }

                try {
                  int.parse(value);
                } catch (_) {
                  return 'Veuillez spécifier un nombre';
                }

                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Prénom'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _firstName = value),
              initialValue: widget.player?.firstName,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez spécifier un prénom';
                }

                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Nom'),
                border: OutlineInputBorder(),
              ),
              initialValue: widget.player?.lastName,
              onChanged: (value) => setState(() => _lastName = value),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez spécifier un nom';
                }

                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Classement'),
                border: OutlineInputBorder(),
              ),
              initialValue: widget.player?.ranking,
              onChanged: (value) => setState(() => _ranking = value),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez spécifier un classement';
                }

                final regex = RegExp(r'([B-E](0|2|4|6))|NC');

                if (!regex.hasMatch(value)) {
                  return 'Format invalide';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
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
                index: int.parse(_index),
                affiliation: int.parse(_affiliation),
                firstName: _firstName,
                lastName: _lastName,
                ranking: _ranking,
              );

              if (widget.player == null) {
                // TODO: Modifier le joueur
              } else {
                await playersDatabase.addPlayer(newPlayer);
              }
            }
          },
          child: Text(widget.player == null ? 'Ajouter' : 'Modifier'),
        ),
      ],
    );
  }
}
