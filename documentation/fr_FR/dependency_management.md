# Gestion des dépendances
- [Dependency Management](#Gestion-des-dépendances)
  - [Instancing methods](#Instanciation-des-methodes)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Using instantiated methods/classes](#Utilisation de méthodes / classes instanciées)
  - [Differences between methods](#differences-between-methods)
  - [Bindings](#bindings)
    - [Classe Bindings](#classe-bindings)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Comment changer](#comment-changer)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Comment Bindings fonctionne sous le capot](#comment-bindings-fonctionne-sous-le-capot)
  - [Notes](#notes)

Get a un gestionnaire de dépendances simple et puissant qui vous permet de récupérer la même classe que votre Bloc ou Controller avec une seule ligne de code, pas de context Provider, pas d' inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Au lieu de Controller controller = Controller();
```

Au lieu d'instancier votre classe dans la classe que vous utilisez, vous l'instanciez dans l'instance Get, qui la rendra disponible dans toute votre application.
Vous pouvez donc utiliser votre contrôleur (ou classe Bloc) normalement

- Note: Si vous utilisez le gestionnaire d'état de Get, faites plus attention à l'API [Bindings] (# bindings), qui facilitera la connexion de votre vue à votre contrôleur.
- Note²: La gestion des dépendances est découplée des autres parties du package, donc si, par exemple, votre application utilise déjà un gestionnaire d'état (n'importe lequel, peu importe), vous n'avez pas besoin de changer cela, vous pouvez utiliser ce manager d'injection de dépendance sans aucun problème.

## Instanciation des methodes
Les méthodes et leurs paramètres configurables sont:

### Get.put()

La manière la plus courante d'insérer une dépendance. Bon pour les contrôleurs de vos vues par exemple.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "un String unique");
```

Ce sont toutes les options que vous pouvez définir lorsque vous utilisez put:
```dart
Get.put<S>(
  // obligatoire: la classe que vous voulez que get enregistre, comme un 'controler' ou autre
  // note: "S" signifie que ca peut etre une classe de n'importe quel type
  S dependency

  // optionnel: c'est pour quand vous voulez plusieurs classes qui sont du même type
  // puisque vous obtenez normalement une classe en utilisant Get.find<Controller>(),
  // vous devez utiliser ce tag pour indiquer de quelle instance vous avez besoin
  // doit être un String unique
  String tag,

  // optionnel: par défaut, get supprimera les instances une fois qu'elles ne seront plus utilisées (exemple,
  // le contrôleur d'une vue qui est fermée), mais vous pourriez avoir besoin que l'instance
  // soit conservée dans toute l'application, comme une instance de sharedPreferences ou quelque chose du genre
  // donc vous utilisez ceci
  // équivaut à false par défaut
  bool permanent = false,

  // facultatif: permet après avoir utilisé une classe abstraite dans un test, de la remplacer par une autre et de suivre le test.
  // équivaut à false par défaut
  bool overrideAbstract = false,

  // facultatif: vous permet de créer la dépendance en utilisant la fonction au lieu de la dépendance elle-même.
  // ce n'est pas couramment utilisé
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
Il est possible de lazyLoad une dépendance afin qu'elle ne soit instanciée que lorsqu'elle est utilisée. Très utile pour les classes qui demandent beaucoup de ressources ou si vous souhaitez instancier plusieurs classes en un seul endroit (comme dans une classe Bindings) et que vous savez que vous n'utiliserez pas cette classe à ce moment-là.

```dart
/// ApiMock ne sera appelé que lorsque quelqu'un utilise Get.find <ApiMock> pour la première fois
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... some logic if needed
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>(() => Controller() )
```

Ce sont toutes les options que vous pouvez définir lors de l'utilisation de lazyPut:
```dart
Get.lazyPut<S>(
  // obligatoire: une méthode qui sera exécutée lorsque votre classe sera appelée pour la première fois
  InstanceBuilderCallback builder,
  
  // facultatif: identique à Get.put(), il est utilisé lorsque vous voulez plusieurs instances différentes d'une même classe
  // doit être unique
  String tag,

  // facultatif: cela est similaire à "permanent", la différence est que l'instance est supprimée lorsqu'elle
  // n'est pas utilisée, mais lorsqu'elle est à nouveau nécessaire, Get recrée l'instance
  // identique à "SmartManagement.keepFactory" dans l'API Bindings
  // vaut false par défaut
  bool fenix = false
  
)
```

### Get.putAsync
Si vous souhaitez enregistrer une instance async, vous pouvez utiliser `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>(() async => await YourAsyncClass())
```

Ce sont toutes les options que vous pouvez définir lors de l'utilisation de putAsync:
```dart
Get.putAsync<S>(

  // obligatoire: une méthode async qui sera exécutée pour instancier votre classe
  AsyncInstanceBuilderCallback<S> builder,

  // facultatif: identique à Get.put(), il est utilisé lorsque vous voulez plusieurs instances différentes d'une même classe
  // doit être unique
  String tag,

  // facultatif: identique à Get.put(), utilisé lorsque vous devez maintenir cette instance active dans l'ensemble de l'application
  // vaut false par défaut
  bool permanent = false
)
```

### Get.create

Celui-ci est délicat. Une explication détaillée de ce que c'est et des différences d'avec les autres peut être trouvée dans la section [Différences entre les méthodes:](#differences-entre-les-methodes).

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Ce sont toutes les options que vous pouvez définir lors de l'utilisation de create:

```dart
Get.create<S>(
  // requis: une fonction qui renvoie une classe qui sera "fabriquée" chaque
  // fois que `Get.find()` est appelé
  // Exemple: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // facultatif: comme Get.put(), mais il est utilisé lorsque vous avez besoin de plusieurs instances
  // d'une même classe
  // Utile dans le cas où vous avez une liste oú chaque élément a besoin de son propre contrôleur
  // doit être une String unique. Changez simplement de 'tag' en 'name'
  String name,

  // optionnel: tout comme dans `Get.put()`, c'est pour quand vous devez garder l'
  // instance vivante dans toute l'application. La différence est que dans Get.create,
  // permanent est 'true' par défaut
  bool permanent = true
```

## Utilisation de méthodes/classes instanciées

Imaginez que vous ayez parcouru de nombreuses routes et que vous ayez besoin d'une donnée qui a été laissée dans votre contrôleur, vous auriez besoin d'un gestionnaire d'état combiné avec le 'Provider' ou Get_it, n'est-ce pas? Pas avec Get. Il vous suffit de demander à Get de "find" (trouver) votre contrôleur, vous n'avez pas besoin de dépendances supplémentaires:

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// Oui, cela ressemble à Magic, Get trouvera votre contrôleur et vous le livrera.
// Vous pouvez avoir 1 million de contrôleurs instanciés, Get vous trouvera toujours le bon contrôleur.
```

Et puis vous pourrez récupérer les données de votre contrôleur qui ont été obtenues là-bas:

```dart
Text(controller.textFromApi);
```

La valeur renvoyée étant une classe normale, vous pouvez faire tout ce que vous voulez:
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // donne: 12345
```

Pour supprimer une instance de Get:

```dart
Get.delete<Controller>(); //généralement, vous n'avez pas besoin de le faire car GetX supprime déjà les contrôleurs inutilisés-
```

## Differences entre les methodes

Commençons par le `fenix` de Get.lazyPut et le `permanent` des autres méthodes.

La différence fondamentale entre `permanent` et `fenix` réside dans la manière dont vous souhaitez stocker vos instances.

Renforcement: par défaut, GetX supprime les instances lorsqu'elles ne sont pas utilisées.
Cela signifie que: Si l'écran 1 a le contrôleur 1 et l'écran 2 a le contrôleur 2 et que vous supprimez la première route du Stack, (comme si vous utilisez `Get.off()` ou `Get.offNamed()`) le contrôleur 1 a perdu son utilisation, il sera donc effacé.

Mais si vous optez pour l'utilisation de `permanent: true`, alors le contrôleur ne sera pas perdu dans cette transition - ce qui est très utile pour les services que vous souhaitez maintenir actif dans toute l'application.

`fenix`, quant à lui, est destiné aux services que vous ne craignez pas de perdre entre les changements d'écran, mais lorsque vous avez besoin de ce service, vous vous attendez à ce qu'il soit vivant. Donc, fondamentalement, il supprimera le contrôleur / service / classe inutilisé, mais lorsque vous en aurez besoin, il "recréera à partir de ses cendres" une nouvelle instance.

Différences entre les méthodes:

- Get.put et Get.putAsync suivent le même ordre de création, à la différence que la seconde utilise une méthode asynchrone: ces deux méthodes créent et initialisent l'instance. Celle-ci est insérée directement dans la mémoire, en utilisant la méthode interne `insert` avec les paramètres` permanent: false` et `isSingleton: true` (ce paramètre isSingleton a pour seul but de dire s'il faut utiliser la dépendance sur` dependency` ou s'il doit utiliser la dépendance sur `FcBuilderFunc`). Après cela, `Get.find()` est appelé pour initialiser immédiatement les instances qui sont en mémoire.

- Get.create: Comme son nom l'indique, il "créera" votre dépendance! Similaire à `Get.put()`, il appelle également la méthode interne `insert` pour l'instanciation. Mais `permanent` devient vrai et` isSingleton` devient faux (puisque nous "créons" notre dépendance, il n'y a aucun moyen pour que ce soit une instance singleton, c'est pourquoi il est faux). Et comme il a `permanent: true`, nous avons par défaut l'avantage de ne pas le perdre entre les écrans! De plus, `Get.find()` n'est pas appelé immédiatement, il attend d'être utilisé dans l'écran pour être appelé. Il est créé de cette façon pour utiliser le paramètre `permanent`, depuis lors, il convient de noter que` Get.create() `a été créé dans le but de créer des instances non partagées, mais qui ne sont pas supprimées, comme par exemple un bouton dans un listView, pour lequel vous voulez une instance unique pour cette liste - à cause de cela, Get.create doit être utilisé avec GetWidget.

- Get.lazyPut: Comme son nom l'indique, il s'agit d'un processus 'paresseux'. L'instance est créée, mais elle n'est pas appelée pour être utilisée immédiatement, elle reste en attente d'être appelée. Contrairement aux autres méthodes, `insert` n'est pas appelé ici. Au lieu de cela, l'instance est insérée dans une autre partie de la mémoire, une partie chargée de dire si l'instance peut être recréée ou non, appelons-la "factory". Si nous voulons créer quelque chose pour être utilisé plus tard, il ne sera pas mélangé avec les choses actuellement utilisées. Et voici où la magie de `fenix` apparaît: si vous choisissez de laisser` fenix: false`, et que votre `smartManagement` n'est pas` keepFactory`, alors lors de l'utilisation de `Get.find`, l'instance changera la place dans la mémoire de la "factory" à la zone de mémoire d'instance commune. Juste après cela, par défaut, il est retiré de `la factory`. Maintenant, si vous optez pour `fenix: true`, l'instance continue d'exister dans cette partie dédiée, allant même vers la zone commune, pour être appelée à nouveau dans le futur.

## Bindings

L'une des grandes différences de ce package, peut-être, est la possibilité d'une intégration complète des routes, du gestionnaire d'état et du gestionnaire de dépendances.
Lorsqu'une route est supprimée de la pile, tous les contrôleurs, variables et instances d'objets qui lui sont associés sont supprimés de la mémoire. Si vous utilisez des streams ou timers, ils seront fermés automatiquement et vous n'aurez à vous soucier de rien de tout cela.
Dans la version 2.10, Get a complètement implémenté l'API Bindings.
Vous n'avez plus besoin d'utiliser la méthode init. Vous n'avez même pas besoin de `typer`(declaration de type) vos contrôleurs si vous ne le souhaitez pas. Vous pouvez démarrer vos contrôleurs et services à l'endroit approprié pour cela.
La classe Binding est une classe qui découplera l'injection de dépendances, en faisant du "binding" des routes entre le gestionnaire d'état et le gestionnaire de dépendances.
Cela permet à Get de savoir quel écran est affiché lorsqu'un contrôleur particulier est utilisé et de savoir où et comment s'en débarrasser.
De plus, la classe Binding vous permettra d'avoir le contrôle de la configuration de SmartManager. Vous pouvez configurer les dépendances à organiser lors de la suppression d'une route du Stack, ou lorsque le widget qui l'utilisait est disposé, ou ni l'un ni l'autre. Vous disposerez d'une gestion intelligente des dépendances qui fonctionnera pour vous, mais vous pourrez malgré tout la configurer comme vous le souhaitez.

### Classe Bindings

- Créer une classe et implémenter Bindings

```dart
class HomeBinding implements Bindings {}
```

Votre IDE vous demandera automatiquement de remplacer la méthode "dependencies", et il vous suffit de cliquer sur la lampe, de remplacer la méthode et d'insérer toutes les classes que vous allez utiliser sur cette route:

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<Service>(()=> Api());
  }
}

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
```

Il vous suffit maintenant d'informer votre route, que vous utiliserez ce Binding pour établir la connexion entre le gestionnaire de routes, les dépendances et les états.

- En utilisant les routes nommées:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: DetailsBinding(),
  ),
];
```

- En utilisant les routes normales:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Là, vous n'avez plus à vous soucier de la gestion de la mémoire de votre application, Get le fera pour vous.

La classe Binding est appelée lorsqu'une route est appelée, vous pouvez créer un "initialBinding dans votre GetMaterialApp pour insérer toutes les dépendances qui seront créées.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

La manière par défaut de créer un binding est de créer une classe qui implémente Bindings.

Mais alternativement, vous pouvez utiliser le callback `BindingsBuilder` afin de pouvoir simplement utiliser une fonction pour instancier ce que vous désirez.

Exemple:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

De cette façon, vous pouvez éviter de créer une classe Binding pour chaque route, ce qui est encore plus simple.

Les deux méthodes fonctionnent parfaitement bien et nous voulons que vous utilisiez ce qui correspond le mieux à vos goûts.

### SmartManagement

GetX par défaut supprime les contrôleurs inutilisés de la mémoire, même si un échec se produit et qu'un widget qui l'utilise n'est pas correctement supprimé.
C'est ce qu'on appelle le mode `full` de gestion des dépendances.
Mais si vous voulez changer la façon dont GetX contrôle la suppression des classes, vous avez la classe `SmartManagement` pour définir différents comportements.

#### Comment changer

Si vous souhaitez modifier cette configuration (dont vous n'avez généralement pas besoin), procédez comme suit:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //Ici
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

C'est celui par défaut. Supprime les classes qui ne sont pas utilisées et qui n'ont pas été définies pour être permanentes. Dans la majorité des cas, vous voudrez garder cette configuration intacte. Si vous débutez avec GetX, ne changez pas cela.

#### SmartManagement.onlyBuilders

Avec cette option, seuls les contrôleurs démarrés dans `init:` ou chargés dans un  Binding avec `Get.lazyPut()` seront supprimés.

Si vous utilisez `Get.put()` ou `Get.putAsync()` ou toute autre approche, SmartManagement n'aura pas les autorisations pour exclure cette dépendance.

Avec le comportement par défaut, même les widgets instanciés avec "Get.put" seront supprimés, contrairement à SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Tout comme SmartManagement.full, il supprimera ses dépendances lorsqu'elles ne seront plus utilisées. Cependant, il conservera leur factory, ce qui signifie qu'il recréera la dépendance si vous avez à nouveau besoin de cette instance.

### Comment Bindings fonctionne sous le capot

Bindings crée des `'factories' transitoires`, qui sont créées au moment où vous cliquez pour aller à un autre écran, et seront détruites dès que l'animation de changement d'écran se produit.
Cela arrive si vite que l'analyseur ne pourra même pas l'enregistrer.
Lorsque vous accédez à nouveau à cet écran, une nouvelle fabrique temporaire sera appelée, c'est donc préférable à l'utilisation de SmartManagement.keepFactory, mais si vous ne voulez pas créer de Bindings, ou si vous voulez garder toutes vos dépendances sur le même Binding , cela vous aidera certainement.
Les factories prennent peu de mémoire, elles ne contiennent pas d'instances, mais une fonction avec la "forme" de cette classe que vous voulez.
Cela a un très faible coût en mémoire, mais comme le but de cette bibliothèque est d'obtenir le maximum de performances possible en utilisant le minimum de ressources, Get supprime même les factories par défaut.
Utilisez celui qui vous convient le mieux.

## Notes

- N'UTILISEZ PAS SmartManagement.keepFactory si vous utilisez plusieurs Bindings. Il a été conçu pour être utilisé sans Bindings ou avec une seule Binding liée dans le fichier initialBinding de GetMaterialApp.

- L'utilisation de Bindings est complètement facultative, si vous le souhaitez, vous pouvez utiliser `Get.put()` et `Get.find()` sur les classes qui utilisent un contrôleur donné sans aucun problème.
  Cependant, si vous travaillez avec des services ou toute autre abstraction, je vous recommande d'utiliser Bindings pour une meilleure organisation.