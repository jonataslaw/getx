---
sidebar_position: 2
---

# Gestion de la route

Si vous allez utiliser des routes/snackbars/dialogs/bottomsheets sans contexte, GetX est excellent pour vous aussi, il suffit de le voir :

Ajouter "Obtenir" avant votre MaterialApp, la transformer en GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Naviguer vers un nouvel écran :

```dart

Get.to(NextScreen());
```

Naviguez vers le nouvel écran avec le nom. Voir plus de détails sur les routes [here](/docs/pillars/route-management#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

Pour fermer les barres de collation, les dialogues, les feuilles du bas ou tout ce que vous fermeriez normalement avec Navigator.pop(contexte);

```dart
Get.back();
```

Pour passer à l'écran suivant et aucune option pour revenir à l'écran précédent (pour utiliser dans SplashScreens, les écrans de connexion, etc.)

```dart
Get.off(NextScreen());
```

Pour aller à l'écran suivant et annuler tous les itinéraires précédents (utiles dans les paniers, les sondages et les tests)

```dart
Get.offAll(NextScreen());
```

Vous avez remarqué que vous n'avez pas à utiliser le contexte pour faire l'une de ces choses ? C'est l'un des plus grands avantages de la gestion de route Get . Avec cela, vous pouvez exécuter toutes ces méthodes à partir de votre classe de contrôleur, sans soucis.

### Plus de détails sur la gestion de l'itinéraire

**Travaillez avec des routes nommées et offre également un contrôle de niveau inférieur sur vos routes! Il y a une documentation approfondie [here](/docs/pillars/route-management)**
