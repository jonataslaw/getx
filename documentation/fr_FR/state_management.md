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
    - [Atouts](#atouts)
    - [Utilisation](#utilisation)
    - [Comment il gère les contrôleurs](#comment-il-gre-les-contrleurs)
    - [Vous n'aurez plus besoin de StatefulWidgets](#vous-naurez-plus-besoin-de-statefulwidgets)
    - [Pourquoi ça existe](#pourquoi-ca-existe)
    - [Autres façons de l'utiliser](#autres-formes-d-utilisation)
    - [IDs Uniques](#ids-uniques)
  - [Mélanger les deux gestionnaires d'état](#mixing-the-two-state-managers)
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

### Atouts

1. Met à jour uniquement les widgets requis.

2. N'utilise pas changeNotifier, c'est le gestionnaire d'état qui utilise le moins de mémoire (proche de 0 Mo).

3. Oubliez StatefulWidget! Avec Get, vous n'en aurez jamais besoin. Avec les autres gestionnaires d'états, vous devrez probablement utiliser un StatefulWidget pour obtenir l'instance de votre fournisseur, BLoC, MobX Controller, etc. Mais vous êtes-vous déjà arrêté pour penser que votre appBar, votre 'scaffold', et la plupart des les widgets de votre classe sont sans état (stateless)? Alors pourquoi sauvegarder l'état d'une classe entière, si vous pouvez sauvegarder l'état du widget qui est «avec état» (statefull)? Get résout cela aussi. Créez une classe sans état, rendez tout «sans état». Si vous devez mettre à jour un seul composant, enveloppez-le avec GetBuilder et son état sera conservé.

4. Organisez votre projet pour de vrai! Les contrôleurs ne doivent pas être dans votre interface utilisateur, placer votre TextEditController ou tout contrôleur que vous utilisez dans votre classe Controller.

5. Avez-vous besoin de déclencher un événement pour mettre à jour un widget dès son rendu? GetBuilder a la propriété "initState", tout comme StatefulWidget, et vous pouvez appeler des événements depuis votre contrôleur, directement depuis celui-ci, aucun événement n'étant placé dans votre initState.

6. Avez-vous besoin de déclencher une action comme la fermeture de stream, de timers, etc.? GetBuilder a également la propriété dispose(), où vous pouvez appeler des événements dès que ce widget est détruit.

7. N'utilisez les streams que si nécessaire. Vous pouvez utiliser vos StreamControllers à l'intérieur de votre contrôleur normalement, et utiliser StreamBuilder également normalement, mais rappelez-vous qu'un stream consomme raisonnablement de la mémoire, la programmation réactive est belle, mais vous ne devriez pas en abuser. 30 streams ouverts simultanément peuvent être pires que changeNotifier (et changeNotifier est très mauvais).

8. Mettez à jour les widgets sans dépenser de RAM pour cela. Get stocke uniquement l'ID de créateur GetBuilder et met à jour ce GetBuilder si nécessaire. La consommation de mémoire du stockage get ID en mémoire est très faible, même pour des milliers de GetBuilders. Lorsque vous créez un nouveau GetBuilder, vous partagez en fait l'état de GetBuilder qui a un ID de créateur. Un nouvel état n'est pas créé pour chaque GetBuilder, ce qui économise BEAUCOUP de RAM pour les applications volumineuses. Fondamentalement, votre application sera entièrement sans état (stateless), et les quelques widgets qui seront stateful (dans GetBuilder) auront un seul état, et par conséquent, la mise à jour d'un seul les mettra tous à jour. L'état  est unique.

9. Get est omniscient et, dans la plupart des cas, il sait exactement quand sortir de mémoire un contrôleur. Vous ne devez pas vous soucier du moment de vous débarrasser d'un contrôleur, Get connaît le meilleur moment pour le faire.

### Utilisation

```dart
// Créez la classe controller qui 'extends' GetxController
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // utilisez update () pour mettre à jour la variable de compteur sur l'interface utilisateur lorsque incrément() est appelé
  }
}
// Sur votre classe Stateless / Stateful, utilisez GetBuilder pour mettre à jour le texte lorsque incrément() est appelé
GetBuilder<Controller>(
  init: Controller(), // INITIER CA UNIQUEMENT LA PREMIÈRE FOIS
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialisez votre contrôleur uniquement la première fois. La deuxième fois que vous utilisez ReBuilder pour le même contrôleur, ne recommencez pas. Votre contrôleur sera automatiquement supprimé de la mémoire dès que le widget qui l'a marqué comme «init» sera déployé. Vous n'avez pas à vous en soucier, Get le fera automatiquement, assurez-vous simplement de ne pas démarrer deux fois le même contrôleur.
```

**Fait!**

- Vous avez déjà appris à gérer les états avec Get.

- Note: Vous pouvez souhaiter une organisation plus grande et ne pas utiliser la propriété init. Pour cela, vous pouvez créer une classe et étendre la classe Bindings, et y mentionner les contrôleurs qui seront créés dans cette route. Les contrôleurs ne seront pas créés à ce moment-là, au contraire, il ne s'agit que d'une déclaration, de sorte que la première fois que vous utilisez un contrôleur, Get saura où chercher. Get restera lazyLoad et continuera à supprimer les contrôleurs lorsqu'ils ne seront plus nécessaires. Voir l'exemple pub.dev pour voir comment cela fonctionne.

Si vous parcourez de nombreuses routes et avez besoin de données qui se trouvaient dans votre contrôleur précédemment utilisé, il vous suffit de réutiliser GetBuilder (sans init):

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

Si vous devez utiliser votre contrôleur dans de nombreux autres endroits, et en dehors de GetBuilder, créez simplement un get dans votre contrôleur et ayez-le facilement. (ou utilisez `Get.find <Controller> ()`)

```dart
class Controller extends GetxController {

  /// Vous n'en avez pas besoin. Je recommande de l'utiliser uniquement pour faciliter la syntaxe.
  /// avec la méthode statique: Controller.to.counter ();
  /// sans méthode statique: Get.find <Controller> () .counter ();
  /// Il n'y a aucune différence de performances, ni aucun effet secondaire de l'utilisation de l'une ou l'autre syntaxe. Un seul n'a pas besoin du type, et l'autre l'EDI le complétera automatiquement.
   static Controller get to => Get.find(); // Ajouter cette ligne

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

Et puis vous pouvez accéder directement à votre contrôleur, de cette façon:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

Lorsque vous appuyez sur FloatingActionButton, tous les widgets qui écoutent la variable «counter» seront mis à jour automatiquement.

### Comment il gère les contrôleurs

Disons que nous avons ceci:

`Class a => Class B (has controller X) => Class C (has controller X)`

Dans la classe A, le contrôleur n'est pas encore en mémoire, car vous ne l'avez pas encore utilisé (Get est lazyLoad). Dans la classe B, vous avez utilisé le contrôleur et il est entré en mémoire. Dans la classe C, vous avez utilisé le même contrôleur que dans la classe B, Get partagera l'état du contrôleur B avec le contrôleur C, et le même contrôleur est toujours en mémoire. Si vous fermez l'écran C et l'écran B, Get retirera automatiquement le contrôleur X de la mémoire et libèrera des ressources, car la classe A n'utilise pas le contrôleur. Si vous naviguez à nouveau vers B, le contrôleur X entrera à nouveau en mémoire, si au lieu de passer à la classe C, vous revenez en classe A, Get retirera le contrôleur de la mémoire de la même manière. Si la classe C n'utilisait pas le contrôleur et que vous retiriez la classe B de la mémoire, aucune classe n'utiliserait le contrôleur X et de même, elle serait éliminée. La seule exception qui peut gâcher Get, est si vous supprimez B de l'itinéraire de manière inattendue et essayez d'utiliser le contrôleur dans C.Dans ce cas, l'ID de créateur du contrôleur qui était dans B a été supprimé et Get a été programmé pour supprimer de la mémoire tous les contrôleurs qui n'ont pas d'ID de créateur. Si vous avez l'intention de faire cela, ajoutez l'indicateur "autoRemove: false" au GetBuilder de la classe B et utilisez adoptID = true; dans GetBuilder de la classe C.

### Vous n'aurez plus besoin de StatefulWidgets

Utiliser StatefulWidgets signifie stocker inutilement l'état d'écrans entiers, même parce que si vous avez besoin de reconstruire au minimum un widget, vous l'intègrerez dans un Consumer / Observer / BlocProvider / GetBuilder / GetX / Obx, qui sera un autre StatefulWidget.
La classe StatefulWidget est une classe plus grande que StatelessWidget, qui allouera plus de RAM, et cela ne fera peut-être pas une différence significative entre une ou deux classes, mais cela le fera très certainement lorsque vous en aurez 100!
À moins que vous n'ayez besoin d'utiliser un mixin, comme TickerProviderStateMixin, il sera totalement inutile d'utiliser un StatefulWidget avec Get.

Vous pouvez appeler toutes les méthodes d'un StatefulWidget directement à partir d'un GetBuilder.
Si vous devez appeler la méthode initState () ou dispose () par exemple, vous pouvez les appeler directement:

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Une bien meilleure approche que celle-ci consiste à utiliser les méthodes onInit () et onClose () directement à partir de votre contrôleur.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- NOTE: Si vous voulez démarrer une méthode au moment où le contrôleur est appelé pour la première fois, vous N'AVEZ PAS BESOIN d'utiliser des constructeurs pour cela, en fait, en utilisant un package orienté performance comme Get, cela frôle la mauvaise pratique, car il s'écarte de la logique dans laquelle les contrôleurs sont créés ou alloués (si vous créez une instance de ce contrôleur, le constructeur sera appelé immédiatement, vous remplirez un contrôleur avant même qu'il ne soit utilisé, vous allouez de la mémoire sans qu'elle ne soit utilisée , cela nuit définitivement aux principes de cette bibliothèque). Les méthodes onInit (); et onClose (); ont été créés pour cela, ils seront appelés lors de la création du Controller, ou lors de sa première utilisation, selon que vous utilisez Get.lazyPut ou non. Si vous voulez, par exemple, faire un appel à votre API pour remplir des données, vous pouvez oublier la méthode à l'ancienne de initState / dispose, lancez simplement votre appel à l'API dans onInit, et si vous devez exécuter une commande comme la fermeture des flux, utilisez onClose () pour cela.

### Pourquoi ca existe

Le but de ce package est précisément de vous donner une solution complète pour la navigation des routes, la gestion des dépendances et des états, en utilisant le moins de dépendances possible, avec un haut degré de découplage. Get engage toutes les API Flutter de haut et bas niveau en lui-même, pour vous assurer de travailler avec le moins de couplage possible. Nous centralisons tout dans un seul package, pour vous assurer que vous n'avez aucun type de couplage dans votre projet. De cette façon, vous pouvez mettre uniquement des widgets dans votre vue et laisser la partie de votre équipe qui travaille avec la «business logique» libre, pour travailler avec la business logique sans dépendre d'aucun élément de la vue. Cela fournit un environnement de travail beaucoup plus propre, de sorte qu'une partie de votre équipe ne travaille qu'avec des widgets, sans se soucier d'envoyer des données à votre contrôleur, et une partie de votre équipe ne travaille qu'avec la business logique dans toute son ampleur, sans dépendre d'aucun élément de la Vue.

Donc, pour simplifier cela:
Vous n'avez pas besoin d'appeler des méthodes dans initState et de les envoyer par paramètre à votre contrôleur, ni d'utiliser votre constructeur de contrôleur pour cela, vous avez la méthode onInit () qui est appelée au bon moment pour démarrer vos services.
Vous n'avez pas besoin d'appeler l'appareil, vous avez la méthode onClose () qui sera appelée au moment exact où votre contrôleur n'est plus nécessaire et sera supprimé de la mémoire. De cette façon, ne laissez les vues que pour les widgets, abstenez-vous d'y mettre tout type de business logique.

N'appelez pas une méthode dispose() dans GetxController, cela ne fera rien, rappelez-vous que le contrôleur n'est pas un Widget, vous ne devez pas le «supprimer», et il sera automatiquement et intelligemment supprimé de la mémoire par Get. Si vous avez utilisé un Stream et que vous souhaitez le fermer, insérez-le simplement dans la méthode close(). Exemple:

```dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// pour fermer stream = méthode onClose(), pas dispose().
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Cycle de vie du controlleur:

- onInit () quand il est créé.
- onClose () quand il est fermé pour apporter des modifications en préparation de la méthode delete.
- supprimé: vous n'avez pas accès à cette API car elle supprime littéralement le contrôleur de la mémoire. Il est littéralement supprimé, sans laisser de trace.

### Autres formes d utilisation

Vous pouvez utiliser l'instance Controller directement sur la valeur GetBuilder:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', // ici
  ),
),
```

Vous pouvez également avoir besoin d'une instance de votre contrôleur en dehors de votre GetBuilder, et vous pouvez utiliser ces approches pour y parvenir:

```dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// Dans la vue:
GetBuilder<Controller>(  
  init: Controller(), // utilisez-le seulement la première fois sur chaque contrôleur
  builder: (_) => Text(
    '${Controller.to.counter}', // ici
  )
),
```

ou encore

```dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // sans static get
[...]
}
// Dans la classe stateful/stateless
GetBuilder<Controller>(  
  init: Controller(), // utilisez-le seulement la première fois sur chaque contrôleur
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // ici
  ),
),
```

- Vous pouvez utiliser des approches «non canoniques» pour ce faire. Si vous utilisez un autre gestionnaire de dépendances, comme get_it, modular, etc., et que vous souhaitez simplement fournir l'instance de contrôleur, vous pouvez le faire:

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, // ici
  builder: (_) => Text(
    '${controller.counter}', // ici
  ),
),

```

### IDs Uniques

Si vous souhaitez affiner le contrôle de mise à jour d'un widget avec GetBuilder, vous pouvez leur attribuer des ID uniques:

```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // utilisez-le seulement la première fois sur chaque contrôleur
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // ici
  ),
),
```

Et mettez-le à jour de cette façon:

```dart
update(['text']);
```

Vous pouvez également imposer des conditions pour la mise à jour:

```dart
update(['text'], counter < 10);
```

GetX le fait automatiquement et ne reconstruit que le widget qui utilise la variable exacte qui a été modifiée, si vous remplacez une variable par la même que la précédente et que cela n'implique pas un changement d'état, GetX ne reconstruira pas le widget pour économiser de la mémoire et Cycles CPU (3 est affiché à l'écran, et vous changez à nouveau la variable à 3. Dans la plupart des gestionnaires d'états, cela entraînera une nouvelle reconstruction, mais avec GetX, le widget ne sera reconstruit qu'à nouveau, si en fait son état a changé ).

## Mélanger les deux gestionnaires d'état

Certaines personnes ont ouvert une demande de fonctionnalité, car elles ne voulaient utiliser qu'un seul type de variable réactive, et les autres mécanismes, et devaient insérer un Obx dans un GetBuilder pour cela. En y réfléchissant, MixinBuilder a été créé. Il permet à la fois des changements réactifs en changeant les variables ".obs" et des mises à jour mécaniques via update (). Cependant, des 4 widgets c'est celui qui consomme le plus de ressources, car en plus d'avoir un Abonnement pour recevoir les événements de changement de ses enfants, il souscrit à la méthode de mise à jour de son contrôleur.

L'extension de GetxController est importante, car ils ont des cycles de vie et peuvent «démarrer» et «terminer» des événements dans leurs méthodes onInit () et onClose (). Vous pouvez utiliser n'importe quelle classe pour cela, mais je vous recommande fortement d'utiliser la classe GetxController pour placer vos variables, qu'elles soient observables ou non.

## GetBuilder vs GetX vs Obx vs MixinBuilder

En une décennie de travail avec la programmation, j'ai pu apprendre de précieuses leçons.

Mon premier contact avec la programmation réactive a été tellement "wow, c'est incroyable" et en fait la programmation réactive est incroyable.
Cependant, elle ne convient pas à toutes les situations. Souvent, il suffit de changer l'état de 2 ou 3 widgets en même temps, ou d'un changement d'état éphémère, auquel cas la programmation réactive n'est pas mauvaise, mais elle n'est pas appropriée.

La programmation réactive a une consommation de RAM plus élevée qui peut être compensée par le flux de travail individuel, ce qui garantira qu'un seul widget est reconstruit et si nécessaire, mais créer une liste avec 80 objets, chacun avec plusieurs flux n'est pas une bonne idée . Ouvrez le 'dart inspect' et vérifiez combien un StreamBuilder consomme, et vous comprendrez ce que j'essaie de vous dire.

Dans cet esprit, j'ai créé le gestionnaire d'état simple. C'est simple, et c'est exactement ce que vous devriez lui demander: mettre à jour l'état par blocs de manière simple et de la manière la plus économique.

GetBuilder est très économique en RAM, et il n'y a guère d'approche plus économique que lui (du moins je ne peux pas en imaginer une, si elle existe, merci de nous le faire savoir).

Cependant, GetBuilder est toujours un gestionnaire d'état mécanique, vous devez appeler update () comme vous auriez besoin d'appeler les notifyListeners () de Provider.

Il y a d'autres situations où la programmation réactive est vraiment intéressante, et ne pas travailler avec elle revient à réinventer la roue. Dans cet esprit, GetX a été créé pour fournir tout ce qui est le plus moderne et le plus avancé dans un gestionnaire d'état. Il met à jour uniquement ce qui est nécessaire et si nécessaire, si vous avez une erreur et envoyez 300 changements d'état simultanément, GetX filtrera et mettra à jour l'écran uniquement si l'état change réellement.

GetX est toujours plus économique que tout autre gestionnaire d'état réactif, mais il consomme un peu plus de RAM que GetBuilder. En y réfléchissant et en visant à maximiser la consommation de ressources, Obx a été créé. Contrairement à GetX et GetBuilder, vous ne pourrez pas initialiser un contrôleur à l'intérieur d'un Obx, c'est juste un widget avec un StreamSubscription qui reçoit les événements de changement de vos widgets enfants, c'est tout. Il est plus économique que GetX, mais perd face à GetBuilder, ce qui était prévisible, car il est réactif, et GetBuilder a l'approche la plus simpliste qui existe, de stocker le hashcode d'un widget et son StateSetter. Avec Obx, vous n'avez pas besoin d'écrire votre type de contrôleur, et vous pouvez entendre le changement de plusieurs contrôleurs différents, mais il doit être initialisé avant, soit en utilisant l'approche d'exemple au début de ce readme, soit en utilisant la classe Bindings.