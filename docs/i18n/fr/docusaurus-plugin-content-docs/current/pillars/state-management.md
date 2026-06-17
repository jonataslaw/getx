---
sidebar_position: 1
---

# État

GetX n'utilise pas Streams ou ChangeNotifier comme d'autres gestionnaires d'état. Pourquoi? En plus de construire des applications pour android, iOS, web, fenêtres, macos et linux, Avec GetX, vous pouvez construire des applications serveur avec la même syntaxe que Flutter/GetX. Afin d'améliorer le temps de réponse et de réduire la consommation de RAM, nous avons créé GetValue et GetStream, qui sont des solutions de faible latence qui offrent beaucoup de performances, à un faible coût d'exploitation. Nous utilisons cette base pour construire toutes nos ressources, y compris la gestion de l'Etat.

- _Complexity_: Certains gestionnaires d'état sont complexes et ont beaucoup de boilerplate. Avec GetX, vous n'avez pas à définir de classe pour chaque événement, le code est très propre et clair, et vous faites beaucoup plus en écrivant moins. De nombreuses personnes ont abandonné Flutter à cause de ce sujet et elles ont enfin une solution stupidement simple pour gérer les États.
- _Aucun générateur de code_: Vous passez la moitié de votre temps de développement à écrire votre logique d'application. Certains gestionnaires d'état comptent sur des générateurs de code pour avoir du code lisible au minimum. Changer une variable et avoir à exécuter build\_runner peut être improductif, et souvent le temps d'attente après un nettoyage flottant sera long, et vous devrez boire beaucoup de café.

Avec GetX, tout est réactif, et rien ne dépend des générateurs de code, ce qui augmente votre productivité dans tous les aspects de votre développement.

- \_Cela ne dépend pas du contexte : Vous avez probablement déjà besoin d'envoyer le contexte de votre vue à un contrôleur, faire le couplage de la vue avec la logique de votre entreprise. Vous avez probablement dû utiliser une dépendance pour un endroit sans contexte, et a dû passer le contexte à travers diverses classes et fonctions. Cela n'existe pas avec GetX. Vous avez accès à vos contrôleurs depuis vos contrôleurs sans contexte. Vous n'avez pas besoin d'envoyer le contexte par paramètre pour littéralement rien.
- _Contrôle granulaire_: la plupart des gestionnaires d'état sont basés sur ChangeNotifier. ChangeNotifier avertira tous les widgets qui dépendent de lui quand notifyListeners est appelé. Si vous avez 40 widgets sur un écran, qui ont une variable de votre classe ChangeNotifier, lorsque vous mettez à jour un, tous ces éléments seront reconstruits.

Avec GetX, même les widgets imbriqués sont respectés. Si vous avez Obx surveillant votre ListView, et un autre surveillant une case à cocher dans la ListView, lorsque vous changez la valeur de la case à cocher, elle sera mise à jour lorsque vous changerez la valeur de la liste, seule la vue liste sera mise à jour.

- \_Il ne se reconstruit que si sa variable change REALLY : GetX a un contrôle de flux, ce qui signifie que si vous affichez un texte avec 'Paola', si vous changez à nouveau la variable observable en 'Paola', le widget ne sera pas reconstruit. C'est parce que GetX sait que 'Paola' est déjà affiché dans le texte et ne fera pas de reconstructions inutiles.

La plupart des gestionnaires d'état actuels seront reconstruits à l'écran.

## Gestionnaire d'état réactif

La programmation réactive peut aliéner de nombreuses personnes parce que l'on dit qu'elle est compliquée. GetX transforme la programmation réactive en quelque chose de assez simple :

- Vous n'aurez pas besoin de créer des StreamControllers.
- Vous n'aurez pas besoin de créer un StreamBuilder pour chaque variable
- Vous n'aurez pas besoin de créer une classe pour chaque état.
- Vous n'aurez pas besoin de créer un get pour une valeur initiale.

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

C'est tout. C'est _que_ simple.

À partir de maintenant, nous pourrions faire référence à ces variables réactive-".obs"(ervables) comme _Rx_.

Qu'avons-nous fait sous le capot? Nous avons créé un `Stream` de `String`s, assigné la valeur initiale `"Jonatas Borges"` , nous avons notifié à tous les widgets qui utilisent `"Jonatas Borges"` qu'ils appartiennent maintenant à cette variable, et quand la valeur _Rx_ change, ils devront également changer.

C'est la **magie de GetX**, grâce aux capacités de Dart.

Mais, comme nous le savons, un `Widget` ne peut être modifié que s'il est à l'intérieur d'une fonction, parce que les classes statiques n'ont pas la puissance pour "auto-change".

Vous devrez créer un `StreamBuilder` , vous abonner à cette variable pour écouter les modifications, et créez une "cascade" de `StreamBuilder` imbriqué si vous voulez changer plusieurs variables dans la même portée, n'est-ce pas?

Non, vous n'avez pas besoin d'un `StreamBuilder` , mais vous avez raison sur les classes statiques.

Eh bien, du point de vue, nous avons généralement beaucoup de boilerplate quand nous voulons changer un Widget spécifique, c'est la façon Flut.
Avec **GetX** vous pouvez également oublier ce code de la chaudière.

`StreamBuilder( … )` ? `initialValue: …` ? `builder: …` ? Non, vous avez juste besoin de placer cette variable à l'intérieur d'un Widget `Obx()`.

```dart
Obx (() => Text (controller.name));
```

_De quoi avez-vous besoin pour mémoriser ?_ Seulement `Obx(() =>` .

Vous passez juste ce Widget à travers une fonction de flèche dans un `Obx()` (le "Observateur" du _Rx_).

`Obx` est assez intelligent, et ne changera que si la valeur de `controller.name` change.

Si `name` est `"John"` , et que vous le changez en `"John"` ( `name. alue = "John"` ), comme c'est la même `valeur` qu'avant, rien ne changera à l'écran, et `Obx` , pour enregistrer des ressources, ignorera simplement la nouvelle valeur et ne reconstruira pas le Widget. **N'est-ce pas incroyable ?**

> Alors, que se passe-t-il si j'ai 5 variables _Rx_ (observables) dans un `Obx` ?

Cela ne fera que se mettre à jour quand **tout** d'entre eux changeront.

> Et si j'ai 30 variables dans une classe, quand je mets à jour une classe, cela mettra-t-il à jour **toutes** les variables qui sont dans cette classe?

Non, juste le **widget spécifique** qui utilise cette variable _Rx_.

Donc **GetX** ne met à jour l'écran que lorsque la variable _Rx_ change sa valeur.

```

final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```

### Avantages

**GetX()** vous aide quand vous avez besoin d'un contrôle **granulaire** sur ce qui est mis à jour.

Si vous n'avez pas besoin de `unique IDs`, car toutes vos variables seront modifiées lorsque vous effectuerez une action, alors utilisez `GetBuilder` ,
parce qu'il s'agit d'une mise à jour d'état simple (en blocs, comme `setState()` ), faite en quelques lignes de code.
Il a été rendu simple, pour avoir le moins d'impact sur le processeur, et juste pour remplir un seul but (un _état_ reconstruit) et dépenser le minimum de ressources possible.

Si vous avez besoin d'un gestionnaire d'État **puissant** , vous ne pouvez pas vous tromper avec **GetX**.

Cela ne fonctionne pas avec des variables, mais **flows**, tout ce qu'il contient est `Streams` sous le capot.

Vous pouvez utiliser _rxDart_ en conjonction avec elle, car tout est `Streams`,
vous pouvez écouter l'événement `event` de chaque variable "_Rx_",
parce que tout ce qu'il contient est `Streams`.

Il s'agit littéralement d'une approche _BLoC_, plus facile que _MobX_, et sans générateurs de code ni décorations.
Tu peux transformer **n'importe quoi** en un _"Observable"_ avec juste un `.obs` .

### Performance maximale :

En plus d'avoir un algorithme intelligent pour les reconstructions minimales, **GetX** utilise des comparateurs
pour s'assurer que l'état a changé.

Si vous rencontrez des erreurs dans votre application et que vous envoyez un changement d'état en double,
**GetX** s'assurera qu'il ne plantera pas.

Avec **GetX** l'Etat ne change que si la `valeur` change.
C'est la différence principale entre **GetX** et l'utilisation de \_ `computed` de MobX\_.
En rejoignant deux **observables**, et un change; l'écouteur de cette _observable_ va également changer.

Avec **GetX**, si vous rejoignez deux variables, `GetX()` (similaire à `Observer()` ) ne sera reconstruit que si cela implique un réel changement d'état.

### Déclarer une variable réactive

Vous avez 3 façons de transformer une variable en un "observable".

1 - Le premier utilise **`Rx{Type}`**.

```dart
// initial value is recommended, but not mandatory
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - La seconde est d'utiliser **`Rx`** et d'utiliser Darts Generics, `Rx<Type>`

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Custom classes - it can be any class, literally
final user = Rx<User>();
```

3 - La troisième approche, plus pratique, plus facile et préférée, ajoute juste **`.obs`** comme propriété de votre `valeur` :

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - it can be any class, literally
final user = User().obs;
```

##### Avoir un état réactif est facile.

Comme nous le savons, _Dart_ va maintenant vers _null safety_.
Pour être prêt, à partir de maintenant, vous devriez toujours commencer vos variables _Rx_ avec une **valeur initiale**.

> Transformer une variable en _observable_ + _valeur initiale_ avec **GetX** est l'approche la plus simple et la plus pratique.

Vous allez littéralement ajouter un « .obs» à la fin de votre variable, et **c'est cela**, vous l'avez rendu observable,
et son `. alue` , eh bien, sera la valeur _initiale_).

### Utilisation des valeurs dans la vue

```dart
// controller file
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// view file
GetX<Controller>(
  builder: (controller) {
    print("count 1 rebuild");
    return Text('${controller.count1.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 2 rebuild");
    return Text('${controller.count2.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 3 rebuild");
    return Text('${controller.sum}');
  },
),
```

Si nous incrémentons `count1.value++` , cela affichera :

- `count 1 reconstruction`

- `count 3 rebuild`

parce que `count1` a une valeur de `1` , et `1 + 0 = 1` , en changeant la valeur d'getter `sum`.

Si nous changeons `count2.value++` , cela affichera :

- `count 2 reconstruction`

- `count 3 rebuild`

parce que `count2.value` a changé, et le résultat de la `sum` est maintenant `2` .

- NOTE: Par défaut, le tout premier événement reconstruira le widget, même s'il s'agit de la même `valeur`.

Ce comportement existe à cause des variables booléennes.

Imaginez que vous ayez fait ceci:

```dart
var isLogged = false.obs;
```

Et puis, vous avez vérifié si un utilisateur est "connecté" pour déclencher un événement dans `ever` .

```dart
@override
onInit() async {
  ever(isLogged, fireRoute);
  isLogged.value = await Preferences.hasToken();
}

fireRoute(logged) {
  if (logged) {
   Get.off(Home());
  } else {
   Get.off(Login());
  }
}
```

Si `hasToken` était `false` , il n'y aurait aucun changement à `isLogged` , donc `ever()` ne serait jamais appelé.
Pour éviter ce type de comportement, le premier changement à un _observable_ déclenchera toujours un événement,
même s'il contient le même `. alue` .

Tu peux supprimer ce comportement si tu veux, en utilisant
`isLogged.firstRebuild = false;`

### Conditions à reconstruire

De plus, Get fournit un contrôle étatique raffiné. Vous pouvez conditionner un événement (comme ajouter un objet à une liste), à une certaine condition.

```dart
// First parameter: condition, must return true or false.
// Second parameter: the new value to apply if the condition is true.
list.addIf(item < limit, item);
```

Sans décorations, sans générateur de code, sans complications :smile:

Connaissez-vous l'application Compteur de Flutter? Votre classe de contrôleur pourrait ressembler à ceci:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Avec un simple :

```dart
controller.count.value++
```

Vous pouvez mettre à jour la variable compteur dans votre interface utilisateur, quel que soit l'endroit où elle est stockée.

### Où les .obs peuvent être utilisés

Vous pouvez transformer n'importe quoi sur les obs. Voici deux façons de le faire:

- Vous pouvez convertir vos valeurs de classe en obs

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

- ou vous pouvez convertir la classe entière en étant observable

```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

### Note sur les listes

Les listes sont complètement observables comme le sont les objets qui s'y trouvent. De cette façon, si vous ajoutez une valeur à une liste, elle reconstruira automatiquement les widgets qui l'utilisent.

Vous n'avez pas non plus besoin d'utiliser ".value" avec des listes, l'étonnant api dart nous a permis de supprimer cela.
Les types primitifs malheureux tels que String et int ne peuvent pas être étendus, en utilisant . est obligatoire, mais ce ne sera pas un problème si vous travaillez avec des jeux et des setters pour ceux-ci.

```dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // String need to have .value in front of it
ListView.builder (
  itemCount: controller.list.length // lists don't need it
)
```

Lorsque vous rendez vos propres classes observables, il y a un autre moyen de les mettre à jour :

```dart
// on the model file
// we are going to make the entire class observable instead of each attribute
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}

// on the controller file
final user = User().obs;
// when you need to update the user variable:
user.update( (user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});
// an alternative way of update the user variable:
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// you can also access the model values without the .value:
user().name; // notice that is the user variable, not the class (variable has lowercase u)
```

Vous n'avez pas à travailler avec des ensembles si vous ne le voulez pas. Vous pouvez utiliser l'api "assigner "et" assigné".
L'api "assigner" effacera votre liste et ajoutera un seul objet que vous voulez y commencer.
L'api "assignAll" effacera la liste existante et ajoutera tous les objets itérables que vous y injecterez.

### Pourquoi je dois utiliser .value

Nous pourrions supprimer l'obligation d'utiliser 'value' à `String` et `int` avec un simple générateur de décoration et de code, mais le but de cette bibliothèque est précisément d'éviter les dépendances externes. Nous voulons offrir un environnement prêt à la programmation, impliquant les éléments essentiels (gestion des routes, dépendances et états), d'une manière simple, légère et performante, sans avoir besoin d'un paquet externe.

Vous pouvez littéralement ajouter 3 lettres à votre pubspec (recevoir) et un deux-points et commencer la programmation. Toutes les solutions incluses par défaut, de la gestion des itinéraires à la gestion des états, visent à faciliter la tâche, la productivité et la performance.

Le poids total de cette bibliothèque est inférieur à celui d'un gestionnaire d'état unique, même si c'est une solution complète, et c'est ce que vous devez comprendre.

Si vous êtes ennuyé par `. alue` , et comme un générateur de code, MobX est une excellente alternative, et vous pouvez l'utiliser en conjonction avec Get. Pour ceux qui veulent ajouter une dépendance unique dans pubspec et commencer à programmer sans se soucier de l'incompatibilité de la version d'un paquet avec un autre, ou si l'erreur d'une mise à jour d'état vient du gestionnaire d'état ou de la dépendance, ou encore, ne veulent pas s'inquiéter de la disponibilité des contrôleurs, si littéralement "juste la programmation", obtenir est tout simplement parfait.

Si vous n'avez pas de problème avec le générateur de code MobX, ou si vous n'avez aucun problème avec le boilerplate BLoC, vous pouvez simplement utiliser Get pour les routes, et oublier qu'il a le gestionnaire d'état. Obtenir SEM et RSM sont nés par nécessité, mon entreprise avait un projet avec plus de 90 contrôleurs, et le générateur de code a simplement pris plus de 30 minutes pour terminer ses tâches après un Nettoyage Flutter sur une machine raisonnablement bonne. Si votre projet a 5, 10, 15 contrôleurs, tout gestionnaire d'état vous fournira bien. Si vous avez un projet ridiculement grand et que le générateur de code est un problème pour vous, vous avez reçu cette solution.

Évidemment, si quelqu'un veut contribuer au projet et créer un générateur de code, ou quelque chose de similaire, je vais lier dans ce readme comme une alternative, mon besoin n'est pas le besoin pour tous les développeurs, mais pour l'instant je le dis, il ya de bonnes solutions qui font déjà cela, comme MobX.

### Obx()

Taper dans Get using Bindings n'est pas nécessaire. vous pouvez utiliser le widget Obx au lieu de GetX qui ne reçoit que la fonction anonyme qui crée un widget.
Évidemment, si vous n'utilisez pas de type, vous devrez avoir une instance de votre contrôleur pour utiliser les variables, ou utiliser `Get. liez<Controller>()` .value ou Controller.to.value pour récupérer la valeur.

### Collaborateurs-trices

Les employés vous aideront à déclencher des callbacks spécifiques lorsqu'un événement se produit.

```dart
/// Called every time `count1` changes.
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

Tous les travailleurs (sauf `debounce` ) ont un `condition` nommé paramètre, qui peut être un `bool` ou un callback qui renvoie un `bool`.
Cette `condition` définit quand la fonction `callback` s'exécute.

Tous les travailleurs renvoient une instance `Worker`, que vous pouvez utiliser pour annuler ( via `dispose()` ) le travailleur.

- **`jamais`**

est appelée à chaque fois que la variable _Rx_ émet une nouvelle valeur.

- **`toujours`**

Comme `ever` , mais il prend une `List` de valeurs _Rx_ appelées chaque fois que sa variable est modifiée. Voilà.

- **`une fois`**

'once' n'est appelé que la première fois que la variable a été modifiée.

- **`debounce`**

'debounce' est très utile dans les fonctions de recherche, où vous voulez seulement que l'API soit appelée lorsque l'utilisateur a fini de taper. Si l'utilisateur saisit "Jonny", vous aurez 5 recherches dans les APIs, par la lettre J, o, n, n et y. Avec Get cela ne se produit pas, parce que vous aurez un Worker "debounce" qui ne sera déclenché qu'à la fin de la frappe.

- **`intervalle`**

'intervalle' est différent de la débouche. déviation si l'utilisateur fait 1000 changements à une variable en 1 seconde, il n'enverra que le dernier après le minuteur stipulé (ce qui est par défaut 800 millisecondes). L'intervalle ignorera à la place toutes les actions de l'utilisateur pour la période prévue. Si vous envoyez des événements pendant 1 minute, 1000 par seconde, le debounce ne vous enverra que le dernier, lorsque l'utilisateur arrête des événements errants. L'intervalle livrera des événements à chaque seconde, et s'il est réglé sur 3 secondes, il livrera 20 événements à la minute. Ceci est recommandé pour éviter les abus, dans les fonctions où l'utilisateur peut rapidement cliquer sur quelque chose et obtenir un avantage (imaginez que l'utilisateur peut gagner des pièces en cliquant sur quelque chose, s'il a cliqué 300 fois dans la même minute, il aurait 300 pièces, en utilisant l'intervalle, vous pouvez définir un calendrier pour 3 secondes, et même après avoir cliqué 300 ou mille fois le maximum qu'il obtiendrait en 1 minute serait 20 pièces, en cliquant 300 ou 1 million de fois). Le debounce est approprié pour les anti-DDos, pour les fonctions comme la recherche où chaque changement à onChange provoquerait une requête à votre api. Debounce attendra que l'utilisateur arrête de taper le nom, pour faire la demande. Si elle était utilisée dans le scénario de pièce mentionné ci-dessus, l'utilisateur ne gagnera que 1 pièce, parce qu'il n'est exécuté que lorsque l'utilisateur "pause" pour la durée établie.

- REMARQUE : Les employés doivent toujours être utilisés lors du démarrage d'un contrôleur ou d'une classe, il devrait donc toujours être sur onInit (recommandé), constructeur de classe, ou l'initState d'un StatefulWidget (cette pratique n'est pas recommandée dans la plupart des cas, mais elle ne devrait pas avoir d'effets secondaires).

## Gestionnaire d'état simple

Get a un gestionnaire d'état qui est extrêmement léger et facile, qui n'utilise pas ChangeNotifier, répondra au besoin en particulier pour les nouveaux utilisateurs de Flutter, et ne posera pas de problèmes pour les applications de grande taille.

GetBuilder vise précisément à contrôler plusieurs états. Imaginez que vous ayez ajouté 30 produits à un panier, vous cliquez sur supprimer un, en même temps que la liste est mise à jour, le prix est mis à jour et le badge dans le panier est mis à jour à un nombre plus petit. Ce type d'approche rend GetBuilder plus meurtrier, car il regroupe les états et les modifie tous à la fois sans aucune "logique de calcul" pour cela. GetBuilder a été créé en gardant à l'esprit ce type de situation, car pour un changement éphémère d'état, vous pouvez utiliser setState et vous n'aurez pas besoin d'un gestionnaire d'état pour cela.

De cette façon, si vous voulez un contrôleur individuel, vous pouvez assigner des identifiants pour cela, ou utiliser GetX. C'est à vous de le faire, en vous rappelant que plus vous avez de widgets "individuels", plus les performances de GetX se démarqueront, alors que les performances de GetBuilder devraient être supérieures, quand il y a plusieurs changements d'état.

### Avantages

1. Mettre à jour uniquement les widgets requis.

2. N'utilise pas changeNotifier, c'est le gestionnaire d'état qui utilise moins de mémoire (proche de 0mb).

3. Oubliez StatefulWidget ! Avec Get vous n'en aurez jamais besoin. Avec les autres gestionnaires d'état, vous devrez probablement utiliser un StatefulWidget pour obtenir l'instance de votre fournisseur, BLoC, MobX Controller, etc. Mais avez-vous jamais cessé de penser que votre barre d'app, votre échafaudage et la plupart des widgets qui sont dans votre classe sont apatrides ? Alors pourquoi enregistrer l'état d'une classe entière, si vous ne pouvez enregistrer que l'état du Widget qui est état? Obtenez des solutions à ce problème aussi. Créez une classe sans état, rendez tout sans état. Si vous avez besoin de mettre à jour un seul composant, enveloppez-le avec GetBuilder, et son état sera maintenu.

4. Organisez votre projet pour de vrais ! Les contrôleurs ne doivent pas être dans votre interface utilisateur, placer votre TextEditController, ou tout contrôleur que vous utilisez dans votre classe de contrôleur.

5. Avez-vous besoin de déclencher un événement pour mettre à jour un widget dès qu'il est rendu ? GetBuilder a la propriété "initState", tout comme StatefulWidget, et vous pouvez appeler des événements de votre contrôleur, directement à partir de celui-ci, plus aucun événement n'est placé dans votre état d'initialisation.

6. Avez-vous besoin de déclencher une action comme la fermeture des flux, des minuteurs et etc? GetBuilder dispose également de la propriété disposition, où vous pouvez appeler des événements dès que ce widget est détruit.

7. Utiliser les flux uniquement si nécessaire. Vous pouvez utiliser vos StreamControllers à l'intérieur de votre contrôleur normalement, et utiliser StreamBuilder aussi normalement, mais n'oubliez pas, un flux consomme raisonnablement de la mémoire, la programmation réactive est belle, mais vous ne devriez pas abuser de cela. 30 flux ouverts simultanément peuvent être pires que changeNotifier (et changeNotifier est très mauvais).

8. Mettre à jour les widgets sans dépenser de bélier pour cela. Obtenez les magasins uniquement l'ID de créateur de GetBuilder, et les mises à jour que GetBuilder si nécessaire. La consommation de mémoire du get ID dans la mémoire est très faible, même pour des milliers de GetBuilders. Lorsque vous créez un nouveau GetBuilder, vous partagez en fait l'état de GetBuilder qui a un ID de créateur. Un nouvel état n'est pas créé pour chaque GetBuilder, ce qui sauve un LOT DE RAM pour les applications de grande taille. Fondamentalement, votre demande sera entièrement sans état et les quelques Widgets qui seront Stateful (au sein de GetBuilder) auront un seul état, et donc la mise à jour d'un d'entre eux les mettra à jour tous. L'État n'en est qu'un seul.

9. Obtenir est omniscient et dans la plupart des cas, il sait exactement le temps de retirer un contrôleur de la mémoire. Vous ne devriez pas vous inquiéter de savoir quand vous débarrasser d'un contrôleur, faites savoir le meilleur moment pour le faire.

### Usage

```dart
// Create controller class and extends GetxController
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // use update() to update counter variable on UI when increment be called
  }
}
// On your Stateless/Stateful class, use GetBuilder to update Text when increment be called
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```

**Terminé !**

- Vous avez déjà appris comment gérer les états avec Get.

- Note : Vous pouvez vouloir une organisation plus grande, et ne pas utiliser la propriété init. Pour cela, vous pouvez créer une classe et étendre la classe Binding et mentionner les contrôleurs qui seront créés dans cette route. Les contrôleurs ne seront pas créés à ce moment-là, au contraire, ce n'est qu'une déclaration, pour que la première fois que vous utilisez un contrôleur, Get sache où regarder. Obtenez restera pazyLoad et continuera à éliminer les contrôleurs quand ils ne sont plus nécessaires. Voyez l'exemple pub.dev pour voir comment ça fonctionne.

Si vous naviguez sur de nombreuses routes et que vous avez besoin de données qui étaient dans votre contrôleur précédemment utilisé, il vous suffit d'utiliser GetBuilder à nouveau (sans init):

```dart
class OtherClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<Controller>(
          builder: (s) => Text('${s.counter}'),
        ),
      ),
    );
  }

```

Si vous avez besoin d'utiliser votre contrôleur à d'autres endroits, et en dehors de GetBuilder, il vous suffit de créer une entrée dans votre contrôleur et de l'avoir facilement. (ou utilisez `Get.find<Controller>()` )

```dart
class Controller extends GetxController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.increment();
  /// with no static method: Get.find<Controller>().increment();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other the IDE will autocomplete it.
  static Controller get to => Get.find(); // add this line

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

Et puis vous pouvez accéder directement à votre contrôleur, de cette façon :

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

Lorsque vous appuyez sur FloatingActionButton, tous les widgets qui écoutent la variable 'compteur' seront mis à jour automatiquement.

### Comment gérer les contrôleurs

Disons que nous avons ceci:

`Classe a => Classe B (a le contrôleur X) => Classe C (a le contrôleur X)`

Dans la classe A, le contrôleur n'est pas encore en mémoire, parce que vous ne l'avez pas encore utilisé (Get is lazyLoad). Dans la classe B, vous avez utilisé le contrôleur, et il est entré en mémoire. Dans la classe C, vous avez utilisé le même contrôleur que dans la classe B, Get partagera l'état du contrôleur B avec le contrôleur C, et le même contrôleur est toujours en mémoire. Si vous fermez l'écran C et l'écran B, Get prendra automatiquement le contrôleur X en mémoire et libérera des ressources. parce que la classe a n'utilise pas le contrôleur. Si vous repassez vers B, le contrôleur X entrera à nouveau dans la mémoire, si au lieu d'aller à la classe C, vous revenez à nouveau à la classe A, Get prendra le contrôleur en mémoire de la même manière. Si la classe C n'utilise pas le contrôleur, et que vous avez pris la classe B en mémoire, aucune classe n'utiliserait le contrôleur X et elle serait également déposée. La seule exception qui peut gâcher avec Get, est si vous retirez B de la route de manière inattendue et essayez d'utiliser le contrôleur en C. Dans ce cas, l'ID du créateur du contrôleur qui était en B a été supprimé, et Get a été programmé pour le retirer de la mémoire chaque contrôleur qui n'a pas d'ID de créateur. Si vous avez l'intention de le faire, ajoutez le flag "autoRemove: false" à GetBuilder de la classe B et utilisez adoptID = true; dans GetBuilder de la classe C.

### Vous n'aurez plus besoin de StatefulWidgets

Utiliser StatefulWidgets signifie stocker inutilement l'état des écrans entiers, même si vous avez besoin de reconstruire un widget, vous l'intégrerez dans un Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, qui sera un autre StatefulWidget.
La classe StatefulWidget est une classe plus grande que StatelessWidget, qui allouera plus de RAM, et cela peut ne pas faire une différence significative entre une ou deux classes, mais cela sera très certainement le cas quand vous en aurez 100 !
À moins que vous n'ayez besoin d'utiliser un mixin, comme TickerProviderStateMixin, il sera totalement inutile d'utiliser un StatefulWidget avec Get.

Vous pouvez appeler toutes les méthodes d'un StatefulWidget directement depuis un GetBuilder.
Si vous devez appeler la méthode initState() ou dispose() par exemple, vous pouvez les appeler directement ;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Une meilleure approche est d'utiliser la méthode onInit() et onClose() directement depuis votre contrôleur.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- REMARQUE : Si vous voulez démarrer une méthode au moment où le contrôleur est appelé pour la première fois, Vous n'avez PAS BESOIN d'utiliser des constructeurs pour cela, en fait, en utilisant un paquet axé sur les performances comme Get, cette bordure sur les mauvaises pratiques, parce qu'il s'écarte de la logique dans laquelle les contrôleurs sont créés ou alloués (si vous créez une instance de ce contrôleur, le constructeur sera appelé immédiatement, vous allez remplir un contrôleur avant même qu'il soit utilisé, vous allouez de la mémoire sans qu'elle soit utilisée, ce qui nuit aux principes de cette bibliothèque). Les méthodes onInit() ; et onClose(); ont été créés pour cela, ils seront appelés lorsque le contrôleur sera créé, ou utilisé pour la première fois, selon que vous utilisez Get. azyPut ou non. Si vous voulez, par exemple, faire un appel à votre API pour remplir des données, vous pouvez oublier la méthode obsolète de initState/disposition, démarrez juste votre appel à l'api dans onInit, et si vous avez besoin d'exécuter une commande comme la fermeture des flux, utilisez la fonction onClose() pour cela.

### Pourquoi il existe

Le but de ce paquet est précisément de vous donner une solution complète pour la navigation des routes, la gestion des dépendances et des états, en utilisant les dépendances les moins possibles, avec un degré élevé de découplage. Faites appel à toutes les API de lutte de haut et de bas niveau pour vous assurer que vous travaillez avec le moins de couplage possible. Nous centralisons tout en un seul paquet, pour vous assurer que vous n'avez pas de couplage dans votre projet. De cette façon, vous ne pouvez mettre que des widgets dans votre vue, et laisser la partie de votre équipe qui fonctionne avec la logique d'entreprise librement, pour travailler avec la logique commerciale sans dépendre de tout élément de la vue. Cela fournit un environnement de travail beaucoup plus propre, de sorte qu'une partie de votre équipe ne fonctionne qu'avec des widgets, sans se soucier d'envoyer des données à votre contrôleur, et une partie de votre équipe ne travaille qu'avec la logique commerciale dans son ensemble, sans dépendre d'aucun élément de la vue.

Donc pour simplifier ceci :
Vous n'avez pas besoin d'appeler des méthodes dans initState et de les envoyer par paramètre à votre contrôleur, ni utiliser le constructeur de votre contrôleur pour cela, vous avez la méthode onInit() qui est appelée au bon moment pour démarrer vos services.
Vous n'avez pas besoin d'appeler l'appareil, vous avez la méthode onClose() qui sera appelée au moment exact où votre contrôleur n'est plus nécessaire et sera retiré de la mémoire. De cette façon, laisser les vues pour les widgets seulement, s'abstenir de toute logique commerciale de cela.

N'appelez pas une méthode d'élimination dans GetxController, il ne fera rien, n'oubliez pas que le contrôleur n'est pas un Widget, vous ne devriez pas le « disposer », et il sera automatiquement et intelligemment retiré de la mémoire par Get. Si vous avez utilisé un flux sur lui et que vous voulez le fermer, insérez-le dans la méthode fermée. Exemple:

```dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// close stream = onClose method, not dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Cycle de vie du contrôleur :

- onInit() où il est créé.
- onClose() où il est fermé pour effectuer des modifications dans la préparation de la méthode de suppression
- supprimé: vous n'avez pas accès à cette API car elle supprime littéralement le contrôleur de la mémoire. Elle est littéralement supprimée, sans laisser de trace.

### Autres façons de l'utiliser

Vous pouvez utiliser une instance de contrôleur directement sur la valeur de GetBuilder:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

Vous pouvez également avoir besoin d'une instance de votre contrôleur en dehors de votre GetBuilder, et vous pouvez utiliser ces approches pour atteindre ceci:

```dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// on you view:
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Controller.to.counter}', //here
  )
),
```

ou

```dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // with no static get
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

- Pour cela, vous pouvez utiliser des approches "non-canoniques". Si vous utilisez un autre gestionnaire de dépendances, comme get\_it, modulaire, etc., et que vous voulez simplement fournir l'instance du contrôleur, vous pouvez faire ceci :

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, //here
  builder: (_) => Text(
    '${controller.counter}', // here
  ),
),

```

### IDs uniques

Si vous voulez affiner le contrôle de mise à jour d'un widget avec GetBuilder, vous pouvez leur assigner des ID uniques :

```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

Et mettez à jour cette forme :

```dart
update(['text']);
```

Vous pouvez également imposer des conditions pour la mise à jour :

```dart
update(['text'], counter < 10);
```

GetX le fait automatiquement et ne reconstruit que le widget qui utilise la variable exacte qui a été modifiée, si vous changez une variable par la même valeur que la précédente, ce qui n'implique pas un changement d'état , GetX ne reconstruira pas le widget pour économiser de la mémoire et les cycles CPU (3 est affiché à l'écran). et vous changez à nouveau la variable à 3. Dans la plupart des gestionnaires d'état, cela provoquera une nouvelle reconstruction, mais avec GetX, le widget ne sera reconstruit que si en fait son état a changé).

## Mélanger les deux gestionnaires d'état

Certaines personnes ont ouvert une demande de fonctionnalité, car elles ne voulaient utiliser qu'un seul type de variable réactive, et les autres mécaniques, et avaient besoin d'insérer un Obx dans un GetBuilder pour cela. MixinBuilder a été créé pour y penser. Il permet à la fois des changements réactifs en modifiant des variables ".obs" et des mises à jour mécaniques via update(). Cependant, parmi les 4 widgets il est celui qui consomme le plus de ressources, car en plus d'avoir un abonnement pour recevoir des événements de changement de la part de ses enfants, il souscrit à la méthode de mise à jour de son contrôleur.

L'extension de GetxController est importante, car ils ont des cycles de vie, et peuvent "démarrer" et "fin" les événements dans leurs méthodes onInit() et onClose() . Vous pouvez utiliser n'importe quelle classe pour cela, mais je vous recommande fortement d'utiliser la classe GetxController pour placer vos variables, qu'ils soient observables ou non.

## Mixin

Une autre façon de gérer votre état `UI` est d'utiliser le `StateMixin<T>`.
Pour l'implémenter, utilisez le `with` pour ajouter le `StateMixin<T>`
à votre contrôleur qui permet un modèle T.

```dart
class Controller extends GetController with StateMixin<User>{}
```

La méthode `change()` change l'état quand nous le voulons.
Il suffit de transmettre les données et le statut de cette façon :

```dart
change(data, status: RxStatus.success());
```

RxStatus autorise ces statuts :

```dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Pour le représenter dans l'interface utilisateur, utilisez :

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

## GetBuilder vs GetX vs Obx vs MixinBuilder

En une décennie de travail avec la programmation, j'ai pu apprendre des leçons précieuses.

Mon premier contact avec la programmation réactive a été si "wow, c'est incroyable" et en fait la programmation réactive est incroyable.
Cependant, il ne convient pas à toutes les situations. Souvent, tout ce dont vous avez besoin est de changer l'état de 2 ou 3 widgets en même temps, ou un changement d'état éphémère, auquel cas la programmation réactive n'est pas mauvaise, mais elle n'est pas appropriée.

La programmation réactive a une consommation de RAM plus élevée qui peut être compensée par le flux de travail individuel, qui s'assurera qu'un seul widget est reconstruit et si nécessaire, mais en créant une liste avec 80 objets, chacun avec plusieurs flux n'est pas une bonne idée. Ouvrez le dart inspecter et vérifiez combien un StreamBuilder consomme, et vous comprendrez ce que j'essaie de vous dire.

C'est dans cet esprit que j'ai créé le simple gestionnaire d'État. C'est simple, et c'est exactement ce que vous devriez exiger: mettre à jour l'état en blocs d'une manière simple, et de la manière la plus économique.

GetBuilder est très économique en RAM, et il y a à peine une approche plus économique que lui (au moins je ne peux pas en imaginer une, si elle existe, s'il vous plaît faites-le nous savoir).

Cependant, GetBuilder est toujours un gestionnaire d'état mécanique, vous devez appeler update() comme vous devriez appeler la fonction Provider's notifyListeners().

Il y a d'autres situations où la programmation réactive est vraiment intéressante, et ne pas travailler avec elle, c'est la même chose que de réinventer la roue. Avec cela à l'esprit, GetX a été créé pour fournir tout ce qui est le plus moderne et le plus avancé dans un gestionnaire d'état. Il ne met à jour que ce qui est nécessaire et si nécessaire, si vous avez une erreur et envoyez 300 changements d'état en même temps, GetX filtrera et mettra à jour l'écran uniquement si l'état change réellement.

GetX est encore plus économique que tout autre gestionnaire d'état réactif, mais il consomme un peu plus de RAM que GetBuilder. Penser à cela et viser à maximiser la consommation de ressources qu'Obx a été créé. Contrairement à GetX et GetBuilder, vous ne pourrez pas initialiser un contrôleur dans un Obx, c'est juste un Widget avec un StreamSubscription qui reçoit des événements de changement de vos enfants, c'est tout. Il est plus économique que GetX, mais perd pour GetBuilder, ce qui était à prévoir, car il est réactif, et GetBuilder a l'approche la plus simpliste qui existe, de stocker le hashcode d'un widget et son StateSetter. Avec Obx, vous n'avez pas besoin d'écrire votre type de contrôleur, et vous pouvez entendre le changement de plusieurs contrôleurs différents, mais il doit être initialisé avant, soit en utilisant l'approche d'exemple au début de ce readme, soit en utilisant la classe Bindings.
