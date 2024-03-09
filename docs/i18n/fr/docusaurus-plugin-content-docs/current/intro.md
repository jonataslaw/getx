---
sidebar_position: 1
---

# Commencer

## Tests en cours

### Installation en cours

Ajouter à votre fichier pubspec.yaml :

```yml
dependencies:
  get:
```

Importer dans les fichiers qu'il sera utilisé :

```dart
import 'package:get/get.dart';
```

### Compteur d'application avec GetX

Le projet "compteur" créé par défaut sur le nouveau projet sur Flutter a plus de 100 lignes (avec commentaires). Pour montrer la puissance de Get, je vais montrer comment faire un "compteur" en changeant l'état à chaque clic, basculer entre les pages et partager l'état entre les écrans, de façon organisée, séparant la logique commerciale de la vue, en SEULEMENT 26 Lignes CODE INCLUANT LES COMMENTS.

- Étape 1 :
  Ajouter "Obtenir" avant votre MaterialApp, en la transformant en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Remarque : cela ne modifie pas le MaterialApp du Flutter, GetMaterialApp n'est pas une application matérielle modifiée, il s'agit juste d'un Widget pré-configuré, qui a le MaterialApp par défaut en tant qu'enfant. Vous pouvez configurer cela manuellement, mais ce n'est absolument pas nécessaire. GetMaterialApp va créer des routes, les injecter, injecter des traductions, injecter tout ce dont vous avez besoin pour la navigation sur route. Si vous utilisez Get uniquement pour la gestion des états ou la gestion des dépendances, il n'est pas nécessaire d'utiliser GetMaterialApp. GetMaterialApp est nécessaire pour les routes, snackbars, internationalisation, bottomSheets, dialogues et apis de haut niveau liés aux routes et à l'absence de contexte.

- Note2: Cette étape n'est nécessaire que si vous allez utiliser la gestion des routes (`Get.to()`, `Get.back()` et ainsi de suite). Si vous ne allez pas l'utiliser, alors il n'est pas nécessaire de faire l'étape 1

- Étape 2:
  Créez votre classe de logique métier et placez toutes les variables, méthodes et contrôleurs à l'intérieur.
  Vous pouvez rendre n'importe quelle variable observable en utilisant un simple ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Étape 3:
  Créez votre vue, utilisez StatelessWidget et enregistrez de la RAM, avec Get vous n'aurez peut-être plus besoin d'utiliser StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Résultat:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Il s'agit d'un projet simple, mais il montre déjà clairement à quel point Get est puissant. Au fur et à mesure que votre projet se développe, cette différence deviendra plus importante.

Get a été conçu pour travailler avec des équipes, mais cela simplifie le travail d'un développeur individuel.

Améliorez vos délais, livrez tout à temps sans perdre vos performances. Get n'est pas pour tout le monde, mais si vous avez identifié avec cette phrase, Get est pour vous!
