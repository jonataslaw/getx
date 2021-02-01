- [Gestion d'État](#gestion-d-etat)
  - [Gestionnaire d'état réactif](#gestionnaire-d-etat-reactif)
    - [Avantages](#avantages)
    - [Performance maximale:](#performance-maximale)
    - [Déclaration d'une variable réactive](#declaration-d-une-variable-reactive)
        - [Avoir un état réactif, c'est facile.](#avoir-un-etat-reactif-c-est-facile)
    - [Utilisation des valeurs dans la Vue](#utilisation-des-valeurs-dans-la-vue)
    - [Conditions pour reconstruire](#conditions-pour-reconstruire)
    - [Quand utiliser .obs](#quand-utiliser-obs)
    - [Remarque sur List](#remarque-sur-list)
    - [Pourquoi je dois utiliser .value](#pourquoi-je-dois-utiliser-value)
    - [Obx()](#obx)
    - [Workers](#workers)
  - [Gestionnaire d'état simple](#gestionnaire-d-etat-simple)
    - [Advantages](#advantages-1)
    - [Usage](#usage)
    - [How it handles controllers](#how-it-handles-controllers)
    - [You won't need StatefulWidgets anymore](#you-wont-need-statefulwidgets-anymore)
    - [Why it exists](#why-it-exists)
    - [Other ways of using it](#other-ways-of-using-it)
    - [Unique IDs](#unique-ids)
  - [Mixing the two state managers](#mixing-the-two-state-managers)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# Gestion d Etat

GetX n'utilise pas Streams ou ChangeNotifier comme les autres gestionnaires d'état. Pourquoi? En plus de créer des applications pour Android, iOS, Web, Linux, MacOS et Linux, GetX vous permet de créer des applications serveur avec la même syntaxe que Flutter / GetX. Afin d'améliorer le temps de réponse et de réduire la consommation de RAM, nous avons créé GetValue et GetStream, des solutions à faible latence qui offrent beaucoup de performances, à un faible coût d'exploitation. Nous utilisons cette base pour construire toutes nos ressources, y compris la gestion d'état.

- _Complexité_: Certains gestionnaires d'État sont complexes et ont beaucoup de code standard. Avec GetX, vous n'avez pas à définir une classe pour chaque événement, le code est très propre et clair, et vous faites beaucoup plus en écrivant moins. Beaucoup de gens ont abandonné Flutter à cause de ce sujet, et ils ont enfin une solution stupidement simple pour gérer les états.
- _Aucun générateur de code_: Vous passez la moitié de votre temps de développement à écrire la logique de votre application. Certains gestionnaires d'état s'appuient sur des générateurs de code pour avoir un code lisible minimal. Changer une variable et avoir à exécuter build_runner peut être improductif, et souvent le temps d'attente après un redémarrage sera long, et vous devrez boire beaucoup de café.
                              Avec GetX, tout est réactif, et rien ne dépend des générateurs de code, augmentant votre productivité dans tous les aspects de votre développement.
- _Cela ne dépend pas de 'context'_: Vous avez probablement déjà eu besoin d'envoyer le contexte de votre vue à un contrôleur, ce qui rend le couplage de la vue avec votre logique métier élevé. Vous avez probablement dû utiliser une dépendance dans un endroit qui n'a pas de contexte, et avez dû passer le contexte à travers différentes classes et fonctions. Cela n'existe tout simplement pas avec GetX. Vous avez accès à vos contrôleurs depuis vos contrôleurs sans aucun contexte. Vous n'avez pas besoin d'envoyer le contexte par paramètre pour rien.
- _Contrôle granulaire_: la plupart des gestionnaires d'état sont basés sur ChangeNotifier. ChangeNotifier notifiera tous les widgets qui en dépendent lors de l'appel de notifyListeners. Si vous avez 40 widgets sur un écran, qui ont une variable de votre classe ChangeNotifier, lorsque vous en mettez un à jour, tous seront reconstruits.
                          Avec GetX, même les widgets imbriqués sont respectés. Si Obx gère votre ListView et un autre gère une case à cocher dans ListView, lors de la modification de la valeur CheckBox, il ne sera mis à jour que, lors de la modification de la valeur List, seul le ListView sera mis à jour.
- _Il ne reconstruit que si sa variable change VRAIMENT_: GetX a un contrôle de flux, cela signifie que si vous affichez un texte avec 'Paola', si vous changez à nouveau la variable observable en 'Paola', le widget ne sera pas reconstruit. C'est parce que GetX sait que `Paola` est déjà affiché dans Text et ne fera pas de reconstructions inutiles.
                                                          La plupart (sinon tous) les gestionnaires d'état actuels se reconstruiront à l'écran.

## Gestionnaire d etat reactif

La programmation réactive peut aliéner de nombreuses personnes car on dit qu'elle est compliquée. GetX transforme la programmation réactive en quelque chose d'assez simple:

- Vous n'aurez pas besoin de créer des StreamControllers.
- Vous n'aurez pas besoin de créer un StreamBuilder pour chaque variable
- Vous n'aurez pas besoin de créer une classe pour chaque état.
- Vous n'aurez pas besoin de créer un 'get' pour une valeur initiale.


La programmation réactive avec Get est aussi simple que d'utiliser setState.

Imaginons que vous ayez une variable de 'name' et que vous souhaitiez que chaque fois que vous la modifiez, tous les widgets qui l'utilisent soient automatiquement modifiés.

Voici votre variable:

```dart
var name = 'Jonatas Borges';
```

Pour la rendre observable, il vous suffit d'ajouter ".obs" à la fin:

```dart
var name = 'Jonatas Borges'.obs;
```

C'est *tout*. Si simple que ca.

A partir de maintenant, nous pourrions désigner ces variables réactives - ". Obs" (ervables) comme _Rx_.

Qu'est ce qui s'est passé derrière les rideaux? Nous avons créé un `Stream` de` String`s, assigné la valeur initiale `" Jonatas Borges "`, nous avons notifié tous les widgets qui utilisent `" Jonatas Borges "` qu'ils "appartiennent" maintenant à cette variable, et quand la valeur _Rx_ changements, ils devront également changer.

C'est la **magie de GetX**, grâce aux performances de Dart.

Mais, comme nous le savons, un `Widget` ne peut être changé que s'il est à l'intérieur d'une fonction, car les classes statiques n'ont pas le pouvoir de" changer automatiquement ".

Vous devrez créer un `StreamBuilder`, vous abonner à cette variable pour écouter les changements et créer une" cascade "de` StreamBuilder` imbriqués si vous voulez changer plusieurs variables dans la même portée, non?

Non, vous n'avez pas besoin d'un `StreamBuilder`, mais vous avez raison pour les classes statiques.

Eh bien, dans la vue, nous avons généralement beaucoup de code standard lorsque nous voulons changer un widget spécifique, c'est la manière Flutter.
Avec **GetX**, vous pouvez également oublier ce code passe-partout.

`StreamBuilder( … )`? `initialValue: …`? `builder: …`? Non, il vous suffit de placer cette variable dans un widget `Obx ()`.

```dart
Obx (() => Text (controller.name));
```

_Que devez-vous mémoriser?_  Seulement `Obx(() =>`. 

Vous passez simplement ce Widget via une fonction dans un `Obx ()` (l' "Observateur" du _Rx_).

`Obx` est assez intelligent et ne changera que si la valeur de` controller.name` change.

Si `name` est` "John" `, et que vous le changez en` "John" `(` name.value = "John" `), comme c'est la même` valeur` qu'avant, rien ne changera à l'écran, et `Obx`, pour économiser les ressources, ignorera simplement la nouvelle valeur et ne reconstruira pas le widget. **N'est-ce pas incroyable?**

> Alors, que faire si j'ai 5 variables _Rx_ (observables) dans un `Obx`?

Il sera simplement mis à jour lorsque **l'un d'entre eux** change.

> Et si j'ai 30 variables dans une classe, lorsque j'en mets une à jour, est-ce que cela va mettre à jour **toutes** les variables qui sont dans cette classe?

Non, juste le **Widget spécifique** qui utilise cette variable _Rx_.

Ainsi, **GetX** ne met à jour l'écran que lorsque la variable _Rx_ change sa valeur.

```
final isOpen = false.obs;

// Rien de ne change... valeur identique.
void onButtonTap() => isOpen.value=false;
```
### Avantages

**GetX ()** vous aide lorsque vous avez besoin d'un contrôle **granulaire** sur ce qui est mis à jour.


Si vous n'avez pas besoin d'ID uniques, car toutes vos variables seront modifiées lorsque vous effectuez une action, utilisez `GetBuilder`,
parce que c'est un Simple State Updater (en blocs, comme `setState ()`), fait en seulement quelques lignes de code.
Il a été rendu simple, pour avoir le moins d'impact sur le processeur, et juste pour remplir un seul objectif (une reconstruction de _l'état_) et dépenser le minimum de ressources possible.

Si vous avez besoin d'un State Manager **puissant** , vous ne pouvez pas vous tromper avec **GetX**.

Cela ne fonctionne pas avec les variables, mais __flows__, tout ce qu'il contient sont des `Streams` en réalité.
Vous pouvez utiliser _rxDart_ en conjonction avec lui, car tout est `Streams`.
Vous pouvez écouter les changements de chaque "variable _Rx_",
parce que tout ce qui se trouve dedans est un `Streams`.


C'est littéralement une approche _BLoC_, plus facile que _MobX_, et sans générateurs de code ni décorations.
Vous pouvez transformer **n'importe quoi** en un _"Observable"_ avec juste un `.obs`.

###  Performance maximale:

En plus d'avoir un algorithme intelligent pour des reconstructions minimales, **GetX** utilise des comparateurs
pour s'assurer que l'État a changé. 

Si vous rencontrez des erreurs dans votre application et envoyez un changement d'état en double,
**GetX** garantira qu'il ne plantera pas.

Avec **GetX**, l'état ne change que si la `valeur` change.
C'est la principale différence entre **GetX** et l'utilisation de _`computed` de MobX_.
Lors de la jonction de deux __observables__, si l'une change; le listener de cet _observable_ changera également.

Avec **GetX**, si vous joignez deux variables, `GetX ()` (similaire à `Observer ()`), ne se reconstruira que si cela implique un réel changement d'état.

### Declaration d une variable reactive

Vous avez 3 façons de transformer une variable en "observable".

1 - La première est d'utiliser **`Rx{Type}`**.

```dart
// la valeur initiale est recommandée, mais pas obligatoire
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - La seconde consiste à utiliser **`Rx`** et à utiliser les types `Rx<Type>` Génériques Darts 

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Classes personnalisées - il peut s'agir de n'importe quelle classe, littéralement
final user = Rx<User>();
```

3 - La troisième approche, plus pratique, plus facile et préférée, ajoutez simplement **`.obs`** comme propriété de votre` valeur`:

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Classes personnalisées - il peut s'agir de n'importe quelle classe, littéralement
final user = User().obs;
```

##### Avoir un etat reactif, c est facile.

Comme nous le savons, _Dart_ se dirige maintenant vers _null safety_.
Pour être prêt, à partir de maintenant, vous devez toujours commencer vos variables _Rx_ avec une **valeur initiale**.

> Transformer une variable en _observable_ + _valeurInitiale_ avec **GetX** est l'approche la plus simple et la plus pratique.

Vous allez littéralement ajouter un "".obs"" à la fin de votre variable, et **c'est tout**, vous l'avez rendue observable,
et sa `.value`, eh bien, sera la _valeurInitiale_.

### Utilisation des valeurs dans la Vue

```dart
// dans le controlleur
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// dans la vue
GetX<Controller>(
  builder: (controller) {
    print("count 1 reconstruction");
    return Text('${controller.count1.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 2 reconstruction");
    return Text('${controller.count2.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 3 reconstruction");
    return Text('${controller.sum}');
  },
),
```

Si nous incrémentons `count1.value++`, cela affichera:
- `count 1 reconstruction` 
- `count 3 reconstruction`

parce que `count1` a une valeur de `1`, et `1 + 0 = 1`, changeant la valeur du getter `sum`.

Si nous incrémentons `count2.value++`, cela affichera:
- `count 2 reconstruction` 
- `count 3 reconstruction`

parce que `count2.value` a changé et que le résultat de `sum` est maintenant `2`.

- NOTE: Par défaut, le tout premier événement reconstruira le widget, même s'il s'agit de la même `valeur`.
         Ce comportement existe en raison de variables booléennes.

Imaginez que vous fassiez ceci:

```dart
var isLogged = false.obs;
```

Et puis, vous vérifiez si un utilisateur est "connecté" pour déclencher un événement dans `ever`.

```dart
@override
onInit(){
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

si `hasToken` était `false`, il n'y aurait pas de changement à `isLogged`, donc` ever () `ne serait jamais appelé.
Pour éviter ce type de comportement, la première modification d'un _observable_ déclenchera toujours un événement,
même s'il contient la même `.value`.

Vous pouvez supprimer ce comportement si vous le souhaitez, en utilisant:
`isLogged.firstRebuild = false;`

### Conditions pour reconstruire

En outre, Get fournit un contrôle d'état raffiné. Vous pouvez conditionner un événement (comme l'ajout d'un objet à une liste), à ​​une certaine condition.

```dart
// Premier paramètre: condition, doit retourner vrai ou faux.
// Deuxième paramètre: la nouvelle valeur à appliquer si la condition est vraie.
list.addIf(item < limit, item);
```

Sans décorations, sans générateur de code, sans complications :smile:

Connaissez-vous l'application 'counter' de Flutter? Votre classe Controller pourrait ressembler à ceci:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Avec un simple:

```dart
controller.count.value++
```

Vous pouvez mettre à jour la variable de compteur dans votre interface utilisateur, quel que soit l'endroit où elle est stockée.

### Quand utiliser .obs

Vous pouvez tout transformer sur obs. Voici deux façons de procéder:

* Vous pouvez convertir vos valeurs de classe en obs
```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* ou vous pouvez convertir la classe entière en un observable:
```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// en instanciant:
final user = User(name: "Camila", age: 18).obs;
```

### Remarque sur List

Les listes sont complètement observables, tout comme les objets qu'elles contiennent. De cette façon, si vous ajoutez une valeur à une liste, cela reconstruira automatiquement les widgets qui l'utilisent.

Vous n'avez pas non plus besoin d'utiliser ".value" avec des listes, l'incroyable api de Dart nous a permis de supprimer cela.
Malheureusement, les types primitifs comme String et int ne peuvent pas être étendus, ce qui rend l'utilisation de .value obligatoire, mais ce ne sera pas un problème si vous travaillez avec des getters et des setters pour ceux-ci.

```dart
// Dans le controlleur
final String title = 'User Info:'.obs;
final list = List<User>().obs;

// Dans la vue
Text(controller.title.value), // La String doit avoir .value devant elle
ListView.builder (
  itemCount: controller.list.length // pas besoin pour List
)
```

Lorsque vous rendez vos propres classes observables, il existe une manière différente de les mettre à jour:

```dart
// sur le fichier modèle
// nous allons rendre la classe entière observable au lieu de chaque attribut
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}


// Dans le controlleur
final user = User().obs;
// lorsque vous devez mettre à jour la variable utilisateur:
user.update( (user) { // ce paramètre est la classe même que vous souhaitez mettre à jour
user.name = 'Jonny';
user.age = 18;
});
// une autre manière de mettre à jour la variable user:
user(User(name: 'João', age: 35));

// Dans la vue:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// vous pouvez également accéder aux valeurs du modèle sans le .value:
user().name; //notez que c'est la variable utilisateur, pas la classe (la variable a un u minuscule)
```

Vous n'êtes pas obligé de travailler avec des setters si vous ne le souhaitez pas. vous pouvez utiliser les API «assign» et «assignAll».
L'API «assign» effacera votre liste et ajoutera un seul objet que vous souhaitez.
L'API "assignAll" effacera la liste existante et ajoutera tous les objets itérables que vous y injecterez.

### Pourquoi je dois utiliser .value

Nous pourrions supprimer l'obligation d'utiliser 'value' pour `String` et` int` avec une simple décoration et un générateur de code, mais le but de cette bibliothèque est précisément d'éviter les dépendances externes. Nous souhaitons proposer un environnement prêt à la programmation, impliquant l'essentiel (gestion des routes, des dépendances et des états), de manière simple, légère et performante, sans avoir besoin d'un package externe.

Vous pouvez littéralement ajouter 3 lettres à votre pubspec (get) et un signe deux-points et commencer la programmation. Toutes les solutions incluses par défaut, de la gestion des routes à la gestion des états, visent la facilité, la productivité et la performance.

Le poids total de cette bibliothèque est inférieur à celui d'un seul gestionnaire d'état, bien qu'il s'agisse d'une solution complète, et c'est ce que vous devez comprendre.

Si vous êtes dérangé par `.value`, et comme un générateur de code, MobX est une excellente alternative, et vous pouvez l'utiliser en conjonction avec Get. Pour ceux qui veulent ajouter une seule dépendance dans pubspec et commencer à programmer sans se soucier de l'incompatibilité de la version d'un package avec un autre, ou si l'erreur d'une mise à jour d'état vient du gestionnaire d'état ou de la dépendance, ou encore, ne veulent pas s'inquiéter de la disponibilité des contrôleurs, que ce soit littéralement "juste de la programmation", get est tout simplement parfait.

Si vous n'avez aucun problème avec le générateur de code MobX, ou si vous n'avez aucun problème avec le code standard BLoC, vous pouvez simplement utiliser Get pour les routes et oublier qu'il a un gestionnaire d'état. Get SEM et RSM sont nés par nécessité, mon entreprise avait un projet avec plus de 90 contrôleurs, et le générateur de code a simplement pris plus de 30 minutes pour terminer ses tâches après un Flutter Clean sur une machine raisonnablement bonne, si votre projet il a 5, 10, 15 contrôleurs, n'importe quel gestionnaire d'état vous suffira bien. Si vous avez un projet d'une taille absurde et que le générateur de code est un problème pour vous, cette solution vous a été attribuée.

Évidemment, si quelqu'un veut contribuer au projet et créer un générateur de code, ou quelque chose de similaire, je vais créer un lien dans ce readme comme alternative, mon besoin n'est pas le besoin de tous les développeurs, mais pour l'instant je dis q'il y a de bonnes solutions qui font déjà cela, comme MobX.

### Obx()

Les types dans Get à l'aide de Bindings ne sont pas nécessaires. Vous pouvez utiliser le widget Obx, au lieu de GetX, qui ne reçoit que la fonction anonyme qui crée un widget.
Évidemment, si vous n'utilisez pas de type, vous devrez avoir une instance de votre contrôleur pour utiliser les variables, ou utiliser `Get.find <Controller> ()` .value ou Controller.to.value pour récupérer la valeur .

### Workers

Les 'workers' vous assisteront, déclenchant des callbacks spécifiques lorsqu'un événement se produit.

```dart
/// Appelée à chaque fois que «count1» change.
ever(count1, (_) => print("$_ a été modifié"));

/// Appelée uniquement la première fois que la variable est modifiée
once(count1, (_) => print("$_ a été changé une fois"));

/// Anti DDos - Appelée chaque fois que l'utilisateur arrête de taper pendant 1 seconde, par exemple.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore toutes les modifications pendant 1 seconde.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```
Tous les workers (sauf `debounce`) ont un paramètre nommé `condition`, qui peut etre un `bool` ou un callback qui retourne un `bool`.
Cette `condition` definit quand la fonction `callback` est executée.

Tous les workers renvoyent un objet `Worker`, qui peut être utilisé pour annuler ( via `dispose()` ) le `worker`.
 
- **`ever`**
 est appelée chaque fois que la variable _Rx_ émet une nouvelle valeur.

- **`everAll`**
 Un peu comme `ever`, mais il prend une` List` de valeurs _Rx_. Appelée chaque fois que sa variable est changée. C'est tout.

- **`once`**
'once' est appelée uniquement la première fois que la variable a été modifiée.

- **`debounce`**
'debounce' est très utile dans les fonctions de recherche, où vous souhaitez que l'API ne soit appelée que lorsque l'utilisateur a fini de taper. Si l'utilisateur tape "Jonny", vous aurez 5 recherches dans les API, par la lettre J, o, n, n et y. Avec Get, cela ne se produit pas, car vous aurez un Worker "anti-rebond" qui ne sera déclenché qu'à la fin de la saisie.

- **`interval`**
'interval' est différent de 'debounce'. Avec «debounce» si l'utilisateur fait 1000 changements à une variable en 1 seconde, il n'enverra que le dernier après le temporisateur stipulé (la valeur par défaut est 800 millisecondes). 'Interval' ignorera à la place toutes les actions de l'utilisateur pour la période stipulée. Si vous envoyez des événements pendant 1 minute, 1000 par seconde, debounce ne vous enverra que le dernier, lorsque l'utilisateur arrête de mitrailler les événements. interval délivrera des événements toutes les secondes, et s'il est réglé sur 3 secondes, il fournira 20 événements cette minute. Ceci est recommandé pour éviter les abus, dans des fonctions où l'utilisateur peut rapidement cliquer sur quelque chose et obtenir un avantage (imaginez que l'utilisateur puisse gagner des pièces en cliquant sur quelque chose, s'il cliquait 300 fois dans la même minute, il aurait 300 pièces, en utilisant l'intervalle, vous pouvez définir une période de 3 secondes, et même en cliquant 300 ou mille fois, le maximum qu'il obtiendrait en 1 minute serait de 20 pièces, en cliquant 300 ou 1 million de fois). Le 'debounce' convient aux anti-DDos, pour des fonctions comme la recherche où chaque changement de onChange entraînerait une requête à votre api. Debounce attendra que l'utilisateur arrête de taper le nom, pour faire la demande. S'il était utilisé dans le scénario de pièces mentionné ci-dessus, l'utilisateur ne gagnerait qu'une pièce, car il n'est exécuté que lorsque l'utilisateur "fait une pause" pendant le temps établi.

- NOTE: Les 'workers' doivent toujours être utilisés lors du démarrage d'un contrôleur ou d'une classe, il doit donc toujours être dans onInit (recommandé), le constructeur de classe ou l'initState d'un StatefulWidget (cette pratique n'est pas recommandée dans la plupart des cas, mais cela ne devrait poser aucun problème).

## Gestionnaire d etat simple

Get a un gestionnaire d'état extrêmement léger et facile, qui n'utilise pas ChangeNotifier, répondra aux besoins en particulier des nouveaux utilisateurs de Flutter et ne posera pas de problèmes pour les applications volumineuses.

GetBuilder vise précisément le contrôle de plusieurs états. Imaginez que vous avez ajouté 30 produits à un panier, que vous cliquez sur supprimer un, en même temps que la liste est mise à jour, le prix est mis à jour et le badge dans le panier est mis à jour avec un nombre plus petit. Ce type d'approche fait de GetBuilder un tueur, car il regroupe les états et les modifie tous à la fois sans aucune "logique de calcul" pour cela. GetBuilder a été créé avec ce type de situation à l'esprit, car pour un changement d'état éphémère, vous pouvez utiliser setState et vous n'aurez pas besoin d'un gestionnaire d'état pour cela.

De cette façon, si vous voulez un contrôleur individuel, vous pouvez lui attribuer des ID ou utiliser GetX. Cela dépend de vous, en vous rappelant que plus vous avez de widgets "individuels", plus les performances de GetX se démarqueront, tandis que les performances de GetBuilder devraient être supérieures, en cas de changement d'état multiple.

### Advantages

1. Met à jour uniquement les widgets requis.

2. N'utilise pas changeNotifier, c'est le gestionnaire d'état qui utilise le moins de mémoire (proche de 0 Mo).

3. Oubliez StatefulWidget! Avec Get, vous n'en aurez jamais besoin. Avec les autres gestionnaires d'états, vous devrez probablement utiliser un StatefulWidget pour obtenir l'instance de votre fournisseur, BLoC, MobX Controller, etc. Mais vous êtes-vous déjà arrêté pour penser que votre appBar, votre 'scaffold', et la plupart des les widgets de votre classe sont sans état (stateless)? Alors pourquoi sauvegarder l'état d'une classe entière, si vous pouvez sauvegarder l'état du widget qui est «avec état» (statefull)? Get résout cela aussi. Créez une classe sans état, rendez tout «sans état». Si vous devez mettre à jour un seul composant, enveloppez-le avec GetBuilder et son état sera conservé.

4. Organisez votre projet pour de vrai! Les contrôleurs ne doivent pas être dans votre interface utilisateur, placer votre TextEditController ou tout contrôleur que vous utilisez dans votre classe Controller.

5. Avez-vous besoin de déclencher un événement pour mettre à jour un widget dès son rendu? GetBuilder a la propriété "initState", tout comme StatefulWidget, et vous pouvez appeler des événements depuis votre contrôleur, directement depuis celui-ci, aucun événement n'étant placé dans votre initState.

6. Avez-vous besoin de déclencher une action comme la fermeture de stream, de timers, etc.? GetBuilder a également la propriété dispose(), où vous pouvez appeler des événements dès que ce widget est détruit.

7. N'utilisez les streams que si nécessaire. Vous pouvez utiliser vos StreamControllers à l'intérieur de votre contrôleur normalement, et utiliser StreamBuilder également normalement, mais rappelez-vous qu'un stream consomme raisonnablement de la mémoire, la programmation réactive est belle, mais vous ne devriez pas en abuser. 30 streams ouverts simultanément peuvent être pires que changeNotifier (et changeNotifier est très mauvais).

8. Mettez à jour les widgets sans dépenser de RAM pour cela. Get stocke uniquement l'ID de créateur GetBuilder et met à jour ce GetBuilder si nécessaire. La consommation de mémoire du stockage get ID en mémoire est très faible, même pour des milliers de GetBuilders. Lorsque vous créez un nouveau GetBuilder, vous partagez en fait l'état de GetBuilder qui a un ID de créateur. Un nouvel état n'est pas créé pour chaque GetBuilder, ce qui économise BEAUCOUP de RAM pour les applications volumineuses. Fondamentalement, votre application sera entièrement sans état (stateless), et les quelques widgets qui seront stateful (dans GetBuilder) auront un seul état, et par conséquent, la mise à jour d'un seul les mettra tous à jour. L'état  est unique.

9. Get est omniscient et, dans la plupart des cas, il sait exactement quand sortir de mémoire un contrôleur. Vous ne devez pas vous soucier du moment de vous débarrasser d'un contrôleur, Get connaît le meilleur moment pour le faire.

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

**Done!**

- You have already learned how to manage states with Get.

- Note: You may want a larger organization, and not use the init property. For that, you can create a class and extends Bindings class, and within it mention the controllers that will be created within that route. Controllers will not be created at that time, on the contrary, this is just a statement, so that the first time you use a Controller, Get will know where to look. Get will remain lazyLoad, and will continue to dispose Controllers when they are no longer needed. See the pub.dev example to see how it works.

If you navigate many routes and need data that was in your previously used controller, you just need to use GetBuilder Again (with no init):

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

If you need to use your controller in many other places, and outside of GetBuilder, just create a get in your controller and have it easily. (or use `Get.find<Controller>()`)

```dart
class Controller extends GetxController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.counter();
  /// with no static method: Get.find<Controller>().counter();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other the IDE will autocomplete it.
  static Controller get to => Get.find(); // add this line

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

And then you can access your controller directly, that way:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

When you press FloatingActionButton, all widgets that are listening to the 'counter' variable will be updated automatically.

### How it handles controllers

Let's say we have this:

`Class a => Class B (has controller X) => Class C (has controller X)`

In class A the controller is not yet in memory, because you have not used it yet (Get is lazyLoad). In class B you used the controller, and it entered memory. In class C you used the same controller as in class B, Get will share the state of controller B with controller C, and the same controller is still in memory. If you close screen C and screen B, Get will automatically take controller X out of memory and free up resources, because Class a is not using the controller. If you navigate to B again, controller X will enter memory again, if instead of going to class C, you return to class A again, Get will take the controller out of memory in the same way. If class C didn't use the controller, and you took class B out of memory, no class would be using controller X and likewise it would be disposed of. The only exception that can mess with Get, is if you remove B from the route unexpectedly, and try to use the controller in C. In this case, the creator ID of the controller that was in B was deleted, and Get was programmed to remove it from memory every controller that has no creator ID. If you intend to do this, add the "autoRemove: false" flag to class B's GetBuilder and use adoptID = true; in class C's GetBuilder.

### You won't need StatefulWidgets anymore

Using StatefulWidgets means storing the state of entire screens unnecessarily, even because if you need to minimally rebuild a widget, you will embed it in a Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, which will be another StatefulWidget.
The StatefulWidget class is a class larger than StatelessWidget, which will allocate more RAM, and this may not make a significant difference between one or two classes, but it will most certainly do when you have 100 of them!
Unless you need to use a mixin, like TickerProviderStateMixin, it will be totally unnecessary to use a StatefulWidget with Get.

You can call all methods of a StatefulWidget directly from a GetBuilder.
If you need to call initState() or dispose() method for example, you can call them directly;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

A much better approach than this is to use the onInit() and onClose() method directly from your controller.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- NOTE: If you want to start a method at the moment the controller is called for the first time, you DON'T NEED to use constructors for this, in fact, using a performance-oriented package like Get, this borders on bad practice, because it deviates from the logic in which the controllers are created or allocated (if you create an instance of this controller, the constructor will be called immediately, you will be populating a controller before it is even used, you are allocating memory without it being in use, this definitely hurts the principles of this library). The onInit() methods; and onClose(); were created for this, they will be called when the Controller is created, or used for the first time, depending on whether you are using Get.lazyPut or not. If you want, for example, to make a call to your API to populate data, you can forget about the old-fashioned method of initState/dispose, just start your call to the api in onInit, and if you need to execute any command like closing streams, use the onClose() for that.

### Why it exists

The purpose of this package is precisely to give you a complete solution for navigation of routes, management of dependencies and states, using the least possible dependencies, with a high degree of decoupling. Get engages all high and low level Flutter APIs within itself, to ensure that you work with the least possible coupling. We centralize everything in a single package, to ensure that you don't have any kind of coupling in your project. That way, you can put only widgets in your view, and leave the part of your team that works with the business logic free, to work with the business logic without depending on any element of the View. This provides a much cleaner working environment, so that part of your team works only with widgets, without worrying about sending data to your controller, and part of your team works only with the business logic in its breadth, without depending on no element of the view.

So to simplify this:
You don't need to call methods in initState and send them by parameter to your controller, nor use your controller constructor for that, you have the onInit() method that is called at the right time for you to start your services.
You do not need to call the device, you have the onClose() method that will be called at the exact moment when your controller is no longer needed and will be removed from memory. That way, leave views for widgets only, refrain from any kind of business logic from it.

Do not call a dispose method inside GetxController, it will not do anything, remember that the controller is not a Widget, you should not "dispose" it, and it will be automatically and intelligently removed from memory by Get. If you used any stream on it and want to close it, just insert it into the close method. Example:

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

Controller life cycle:

- onInit() where it is created.
- onClose() where it is closed to make any changes in preparation for the delete method
- deleted: you do not have access to this API because it is literally removing the controller from memory. It is literally deleted, without leaving any trace.

### Other ways of using it

You can use Controller instance directly on GetBuilder value:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

You may also need an instance of your controller outside of your GetBuilder, and you can use these approaches to achieve this:

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

or

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

- You can use "non-canonical" approaches to do this. If you are using some other dependency manager, like get_it, modular, etc., and just want to deliver the controller instance, you can do this:

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

### Unique IDs

If you want to refine a widget's update control with GetBuilder, you can assign them unique IDs:

```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

And update it this form:

```dart
update(['text']);
```

You can also impose conditions for the update:

```dart
update(['text'], counter < 10);
```

GetX does this automatically and only reconstructs the widget that uses the exact variable that was changed, if you change a variable to the same as the previous one and that does not imply a change of state , GetX will not rebuild the widget to save memory and CPU cycles (3 is being displayed on the screen, and you change the variable to 3 again. In most state managers, this will cause a new rebuild, but with GetX the widget will only is rebuilt again, if in fact his state has changed).

## Mixing the two state managers

Some people opened a feature request, as they wanted to use only one type of reactive variable, and the other mechanics, and needed to insert an Obx into a GetBuilder for this. Thinking about it MixinBuilder was created. It allows both reactive changes by changing ".obs" variables, and mechanical updates via update(). However, of the 4 widgets he is the one that consumes the most resources, since in addition to having a Subscription to receive change events from his children, he subscribes to the update method of his controller.

Extending GetxController is important, as they have life cycles, and can "start" and "end" events in their onInit() and onClose() methods. You can use any class for this, but I strongly recommend you use the GetxController class to place your variables, whether they are observable or not.


## GetBuilder vs GetX vs Obx vs MixinBuilder

In a decade working with programming I was able to learn some valuable lessons.

My first contact with reactive programming was so "wow, this is incredible" and in fact reactive programming is incredible.
However, it is not suitable for all situations. Often all you need is to change the state of 2 or 3 widgets at the same time, or an ephemeral change of state, in which case reactive programming is not bad, but it is not appropriate.

Reactive programming has a higher consumption of RAM consumption that can be compensated for by the individual workflow, which will ensure that only one widget is rebuilt and when necessary, but creating a list with 80 objects, each with several streams is not a good one idea. Open the dart inspect and check how much a StreamBuilder consumes, and you'll understand what I'm trying to tell you.

With that in mind, I created the simple state manager. It is simple, and that is exactly what you should demand from it: updating state in blocks in a simple way, and in the most economical way.

GetBuilder is very economical in RAM, and there is hardly a more economical approach than him (at least I can't imagine one, if it exists, please let us know).

However, GetBuilder is still a mechanical state manager, you need to call update() just like you would need to call Provider's notifyListeners().

There are other situations where reactive programming is really interesting, and not working with it is the same as reinventing the wheel. With that in mind, GetX was created to provide everything that is most modern and advanced in a state manager. It updates only what is necessary and when necessary, if you have an error and send 300 state changes simultaneously, GetX will filter and update the screen only if the state actually changes.

GetX is still more economical than any other reactive state manager, but it consumes a little more RAM than GetBuilder. Thinking about it and aiming to maximize the consumption of resources that Obx was created. Unlike GetX and GetBuilder, you will not be able to initialize a controller inside an Obx, it is just a Widget with a StreamSubscription that receives change events from your children, that's all. It is more economical than GetX, but loses to GetBuilder, which was to be expected, since it is reactive, and GetBuilder has the most simplistic approach that exists, of storing a widget's hashcode and its StateSetter. With Obx you don't need to write your controller type, and you can hear the change from multiple different controllers, but it needs to be initialized before, either using the example approach at the beginning of this readme, or using the Bindings class.
