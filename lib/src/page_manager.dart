import 'package:animations/animations.dart';
import 'package:cttw_selection/src/players_listing/add_player_dialog.dart';
import 'package:cttw_selection/src/players_listing/player_search_view.dart';
import 'package:cttw_selection/src/players_listing/players_listing_view.dart';
import 'package:cttw_selection/src/selection/selection_view.dart';
import 'package:cttw_selection/src/settings/app_theme.dart' as app_theme;
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:cttw_selection/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

/// Représente le gestionnaire des pages de l'application.
/// Ce widget peut être comparé à un cadre.
/// Le contour de ce cadre contient :
/// - la barre d'application supérieure -> [AppBar]
/// - le rail de navigation à gauche -> [NavigationRail]
/// - un bouton d'action flottant -> [FloatingActionButton]
///
/// L'intérieur du cadre est la page sélectionnée depuis le rail de navigation.
class PageManager extends StatefulWidget {
  final SettingsController settingsController;

  const PageManager({
    super.key,
    required this.settingsController,
  });

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager>
    with SingleTickerProviderStateMixin {
    
  // Les onglets à afficher dans la barre d'application
  static const tabs = [
    Tab(text: 'Équipe 1'),
    Tab(text: 'Équipe 2'),
    Tab(text: 'Équipe 3'),
    Tab(text: 'Équipe 4'),
    Tab(text: 'Équipe 5'),
    Tab(text: 'Équipe 6'),
  ];

  // Le contrôleur utilisé dans la barre d'application et
  // sur la page contenant les pages des onglets
  late TabController _tabController;

  // L'index des pages dans le rail de navigation
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  // Destruction du contrôleur afin de libérer certaines ressources
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Les pages pouvant êtres choisies dans le rail de navigation
    final pages = [
      const PlayersListingView(),
      SelectionView(controller: _tabController),
      SettingsView(settingsController: widget.settingsController),
    ];

    return Scaffold(
      // La barre d'application
      appBar: AppBar(
        title: const Text('CTTW Sélection'),
        actions: [
          // Bouton de recherche de joueur
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlayerSearchView(),
              );
            },
            tooltip: 'Rechercher un joueur',
            icon: const Icon(Icons.search),
          )
        ],

        // La barre montrant les différents onglets uniquement
        // sur la deuxième page (page de sélection)
        bottom: _selectedIndex == 1
            ? TabBar(
                tabs: tabs,
                controller: _tabController,
                indicatorColor: app_theme.appColor,
                labelColor: Colors.black,
              )
            : null,
      ),
      body: Row(
        children: [
          // Le rail de navigation
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people_alt),
                label: Text('Liste de force'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.format_list_bulleted),
                label: Text('Sélection'),
              ),
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
          // La page acutellement sélectionnée
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

      // Le bouton d'action flottant affichant un pop-up afin
      // d'ajouter ou modifier un joueur.
      // Ce bouton n'est affiché que si la première page est affichée
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