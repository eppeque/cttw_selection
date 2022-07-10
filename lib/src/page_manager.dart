import 'package:animations/animations.dart';
import 'package:cttw_selection/src/players_listing/add_player_dialog.dart';
import 'package:cttw_selection/src/players_listing/players_listing_view.dart';
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:cttw_selection/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

class PageManager extends StatefulWidget {
  final SettingsController settingsController;

  const PageManager({
    super.key,
    required this.settingsController,
  });

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const PlayersListingView(),
      SettingsView(settingsController: widget.settingsController),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CTTW Sélection'),
      ),
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people_alt),
                label: Text('Liste de force'),
              ),
              // NavigationRailDestination(
              //   icon: Icon(Icons.format_list_bulleted),
              //   label: Text('Sélection'),
              // ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Paramètres'),
              ),
            ],
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.selected,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: PageTransitionSwitcher(
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: pages[_selectedIndex],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddPlayerDialog(),
                );
              },
              tooltip: 'Ajouter un joueur',
              child: const Icon(Icons.person_add_outlined),
            )
          : Container(),
    );
  }
}