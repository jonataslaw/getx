---
sidebar_position: 3
---

# Gestion des dépendances

Get a un gestionnaire de dépendances simple et puissant qui vous permet de récupérer la même classe que votre Bloc ou contrôleur avec seulement 1 ligne de code, pas de contexte de fournisseur, pas de Widget hérité :

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Note: Si vous utilisez Get's State Manager, prêtez plus d'attention à l'API de liaisons, qui facilitera la connexion de votre vue à votre contrôleur.

Au lieu d'instancier votre classe dans la classe que vous utilisez, vous l'instanciez dans l'instance Get qui le rendra disponible dans votre application.
Vous pouvez donc utiliser votre contrôleur (ou votre classe Bloc) normalement

**Conseil:** Obtenir la gestion des dépendances est découplé des autres parties du paquet, donc si par exemple, votre application utilise déjà un gestionnaire d'état (n'importe qui, n'importe quel, cela n'a aucune importance), vous n'avez pas besoin de tout réécrire, vous pouvez utiliser cette injection de dépendance sans aucun problème

```dart
controller.fetchApi();
```

Imaginez que vous ayez parcouru de nombreux itinéraires, et que vous ayez besoin de données laissées derrière vous dans votre contrôleur, vous auriez besoin d'un gestionnaire d'état combiné avec le Provider ou Get\_it, correct ? Pas avec Get. Il vous suffit de demander à Get to "find" pour votre contrôleur, vous n'avez pas besoin de dépendances supplémentaires :

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Et puis vous serez en mesure de récupérer les données de votre contrôleur qui y ont été obtenues :

```dart
Text(controller.textFromApi);
```

### Plus de détails sur la gestion des dépendances

**Voir une explication plus détaillée de la gestion des dépendances [here](/docs/pillars/dependency-management)**
