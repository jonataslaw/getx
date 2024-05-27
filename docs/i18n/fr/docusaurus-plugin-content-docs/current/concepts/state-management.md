---
sidebar_position: 1
---

# Gestion des états

Get a deux gestionnaires d'état différents : le simple gestionnaire d'état (nous l'appellerons GetBuilder) et le gestionnaire d'état réactif (GetX/Obx)

### Gestionnaire d'état réactif

La programmation réactive peut aliéner de nombreuses personnes parce que l'on dit qu'elle est compliquée. GetX transforme la programmation réactive en quelque chose de assez simple :

- Vous n'aurez pas besoin de créer des StreamControllers.
- Vous n'aurez pas besoin de créer un StreamBuilder pour chaque variable
- Vous n'aurez pas besoin de créer une classe pour chaque état.
- Vous n'aurez pas besoin de créer un get pour une valeur initiale.
- Vous n'aurez pas besoin d'utiliser des générateurs de code

La programmation réactive avec Get est aussi simple que l'utilisation de setState.

Imaginons que vous ayez une variable de nom et que chaque fois que vous la modifiez, tous les widgets qui l'utilisent sont automatiquement changés.

Ceci est votre variable de compte:

```dart
var name = 'Jonatas Borges';
```

Pour le rendre observable, il vous suffit d'ajouter ".obs" à la fin de celui-ci :

```dart
var name = 'Jonatas Borges'.obs;
```

Et dans l'interface utilisateur, quand vous voulez afficher cette valeur et mettre à jour l'écran chaque fois que les valeurs changent, faites simplement ceci:

```dart
Obx(() => Text("${controller.name}"));
```

C'est tout. C'est _cel_ simple.

### Plus de détails sur la gestion des états

**Voir une explication plus détaillée de la gestion des états [here](/docs/pillars/state-management). Vous y verrez plus d'exemples ainsi que la différence entre le simple gestionnaire d'état et le gestionnaire d'état réactif**

Vous aurez une bonne idée de la puissance de GetX.
