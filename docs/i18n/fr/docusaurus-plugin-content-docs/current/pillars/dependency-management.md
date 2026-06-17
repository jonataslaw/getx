---
sidebar_position: 3
---

# Dépendance

Get a un gestionnaire de dépendances simple et puissant qui vous permet de récupérer la même classe que votre Bloc ou contrôleur avec seulement 1 ligne de code, pas de contexte de fournisseur, pas de Widget hérité :

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

Au lieu d'instancier votre classe dans la classe que vous utilisez, vous l'instanciez dans l'instance Get qui le rendra disponible dans votre application.
Vous pouvez donc utiliser votre contrôleur (ou classe Bloc) normalement

- Remarque : Si vous utilisez Get's State Manager, prêtez plus d'attention à l'API [Bindings](#bindings), qui facilitera la connexion de votre vue à votre contrôleur.
- Note2: Obtenir la gestion des dépendances est décloué à partir d'autres parties du paquet, donc si par exemple votre application utilise déjà un gestionnaire d'état (n'importe qui, n'importe quel, cela n'a aucune importance), vous n'avez pas besoin de changer cela, vous pouvez utiliser ce gestionnaire d'injection de dépendances sans aucun problème

## Méthodes d'instanciation

Les méthodes et ses paramètres configurables sont :

### Get.put()

La façon la plus courante d'insérer une dépendance. Bon pour les contrôleurs de vos points de vue, par exemple.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Ceci est toutes les options que vous pouvez définir lors de l'utilisation de put:

```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: "S" means that it can be a class of any type
  S dependency

  // optional: this is for when you want multiple classess that are of the same type
  // since you normally get a class by using Get.find<Controller>(),
  // you need to use tag to tell which instance you need
  // must be unique string
  String tag,

  // optional: by default, get will dispose instances after they are not used anymore (example,
  // the controller of a view that is closed), but you might need that the instance
  // to be kept there throughout the entire app, like an instance of sharedPreferences or something
  // so you use this
  // defaults to false
  bool permanent = false,

  // optional: allows you after using an abstract class in a test, replace it with another one and follow the test.
  // defaults to false
  bool overrideAbstract = false,

  // optional: allows you to create the dependency using function instead of the dependency itself.
  // this one is not commonly used
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut

Il est possible de lazyLoad une dépendance pour qu'elle ne soit instanciée que lorsqu'elle est utilisée. Très utile pour les classes coûteuses de calcul ou si vous voulez instancier plusieurs classes en un seul endroit (comme dans une classe de liaisons) et vous savez que vous n'allez pas utiliser cette classe à ce moment-là.

```dart
/// ApiMock will only be called when someone uses Get.find<ApiMock> for the first time
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... some logic if needed
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

Ceci est toutes les options que vous pouvez définir lors de l'utilisation de lazyPut:

```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  InstanceBuilderCallback builder,
  
  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: It is similar to "permanent", the difference is that the instance is discarded when
  // is not being used, but when it's use is needed again, Get will recreate the instance
  // just the same as "SmartManagement.keepFactory" in the bindings api
  // defaults to false
  bool fenix = false
  
)
```

### Get.putAsync

Si vous voulez enregistrer une instance asynchrone, vous pouvez utiliser `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

Ceci est toutes les options que vous pouvez définir en utilisant putAsync:

```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  AsyncInstanceBuilderCallback<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
)
```

### Get.create

Celui-ci est délicat. Une explication détaillée de ce qu'est et des différences entre les autres peut être trouvée dans la section [Différences entre les méthodes :](#differences-entre-méthodes)

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Ceci est toutes les options que vous pouvez définir lors de l'utilisation de la création :

```dart
Get.create<S>(
  // required: a function that returns a class that will be "fabricated" every
  // time `Get.find()` is called
  // Example: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // optional: just like Get.put(), but it is used when you need multiple instances
  // of a of a same class
  // Useful in case you have a list that each item need it's own controller
  // needs to be a unique string. Just change from tag to name
  String name,

  // optional: just like int`Get.put()`, it is for when you need to keep the
  // instance alive thoughout the entire app. The difference is in Get.create
  // permanent is true by default
  bool permanent = true
```

## Utilisation de méthodes et de classes instanciées

Imaginez que vous ayez parcouru de nombreux itinéraires, et que vous ayez besoin de données laissées derrière vous dans votre contrôleur, vous auriez besoin d'un gestionnaire d'état combiné avec le Provider ou Get\_it, correct ? Pas avec Get. Il vous suffit de demander à Get to "find" pour votre contrôleur, vous n'avez pas besoin de dépendances supplémentaires :

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// Yes, it looks like Magic, Get will find your controller, and will deliver it to you.
// You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Et puis vous serez en mesure de récupérer les données de votre contrôleur qui y ont été obtenues :

```dart
Text(controller.textFromApi);
```

Puisque la valeur retournée est une classe normale, vous pouvez faire tout ce que vous voulez:

```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Pour supprimer une instance de Get:

```dart
Get.delete<Controller>(); //usually you don't need to do this because GetX already delete unused controllers
```

## Spécifier une instance alternative

Une instance actuellement insérée peut être remplacée par une instance de classe similaire ou étendue en utilisant la méthode `replace` ou `lazyReplace`. Cela peut ensuite être récupéré en utilisant la classe originale.

```dart
abstract class BaseClass {}
class ParentClass extends BaseClass {}

class ChildClass extends ParentClass {
  bool isChild = true;
}


Get.put<BaseClass>(ParentClass());

Get.replace<BaseClass>(ChildClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); //true


class OtherClass extends BaseClass {}
Get.lazyReplace<BaseClass>(() => OtherClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); // false
print(instance is OtherClass); //true
```

## Différences entre les méthodes

Tout d'abord, nous allons du `fenix` de Get.lazyPut et du `permanent` des autres méthodes.

La différence fondamentale entre `permanent` et `fenix` est la façon dont vous voulez stocker vos instances.

Renforcement : par défaut, GetX supprime les instances quand elles ne sont pas utilisées.
Cela signifie que : si l'écran 1 a un contrôleur 1 et que l'écran 2 a un contrôleur 2 et que vous retirez la première route de la pile, (comme si vous utilisez `Get. ff()` ou `Get.offNamed()`) le contrôleur 1 a perdu son utilisation, donc il sera effacé.

Mais si vous voulez utiliser `permanent:true`, alors le contrôleur ne sera pas perdu dans cette transition - ce qui est très utile pour les services que vous voulez garder en vie tout au long de l'application.

`fenix` dans l'autre main est pour les services que vous ne vous inquiétez pas de perdre entre les changements d'écran, mais quand vous avez besoin de ce service, vous vous attendez à ce qu'il soit vivant. Donc, en gros, il va disposer le contrôleur, service/classe inutilisé, mais quand vous en avez besoin, il "recréera à partir des cendres" une nouvelle instance.

Procéder avec les différences entre les méthodes :

- Get.put et Get. utAsync suit le même ordre de création, avec la différence que la seconde utilise une méthode asynchrone : ces deux méthodes créent et initialisent l'instance. Celui-ci est inséré directement dans la mémoire, en utilisant la méthode interne `insert` avec les paramètres `permanent: false` et `isSingleton: true` (ce paramètre isSingleton seul a pour but de dire si c'est d'utiliser la dépendance sur `dependency` ou s'il est d'utiliser la dépendance sur `FcBuilderFunc`). Après cela, `Get.find()` est appelé qui initialise immédiatement les instances qui sont en mémoire.

- Get.create: Comme le nom l'indique, il va "créer" votre dépendance! Similaire à `Get.put()`, il appelle également la méthode interne `insert` pour l'instance. Mais `permanent` est devenu vrai et `isSingleton` est devenu faux (puisque nous "créon" notre dépendance, il n'y a aucun moyen pour que ce soit une instance de singleton, c'est pourquoi c'est faux). Et parce qu'il a `permanent: true`, nous avons par défaut l'avantage de ne pas le perdre entre les écrans ! Aussi, `Get.find()` n'est pas appelé immédiatement, il attend d'être utilisé dans l'écran pour être appelé. Il est créé de cette façon pour utiliser le paramètre `permanent`, depuis lors, il vaut la peine de le remarquer, `Get. reate()` a été fait avec le but de créer des instances non partagées, mais ne pas être disposé, comme par exemple un bouton dans une listView, que vous voulez une instance unique pour cette liste - à cause de cela, Get. reate doit être utilisé avec GetWidget.

- Get.lazyPut: Comme le nom l'indique, c'est un processus paresseux. L'instance est créée, mais elle n'est pas appelée à être utilisée immédiatement, elle reste en attente d'être appelée. Contrairement aux autres méthodes, `insert` n'est pas appelé ici. À la place, l'instance est insérée dans une autre partie de la mémoire, une partie responsable de savoir si l'instance peut être recréée ou non, appelons-la "usine". Si nous voulons créer quelque chose à utiliser plus tard, il ne sera pas mélangé avec les choses qui ont été utilisées pour le moment. Et voici où la magie `fenix` entre : si vous choisissez de quitter `fenix: false`, et que votre `smartManagement` ne sont pas `keepFactory`, alors lorsque vous utilisez `Get. ind` l'instance changera la place dans la mémoire de l'"usine" à la zone de mémoire commune de l'instance. Juste après, par défaut, il est retiré de l'"usine". Maintenant, si vous choisissez `fenix: true`, l'instance continue d'exister dans cette partie dédiée, même en allant dans l'espace commun, pour être appelé à nouveau à l'avenir.

## Liens

Un des grands différentiels de ce paquet, peut-être, est la possibilité d'une intégration complète des routes, du gestionnaire d'état et du gestionnaire de dépendances.
Lorsqu'une route est retirée de la pile, tous les contrôleurs, toutes les variables et les instances d'objets qui y sont liés sont retirés de la mémoire. Si vous utilisez des flux ou des chronomètres, ils seront fermés automatiquement, et vous n'avez pas à vous inquiéter à ce sujet.
Dans la version 2.10 Obtenir complètement implémenté l'API Bindings.
Maintenant vous n'avez plus besoin d'utiliser la méthode d'initialisation. Vous n'avez même pas à taper vos contrôleurs si vous ne le voulez pas. Vous pouvez démarrer vos contrôleurs et vos services à l'endroit approprié pour cela.
La classe Binding est une classe qui découplera l'injection de dépendance, tout en "liant" les routes vers le gestionnaire d'état et le gestionnaire de dépendances.
Cela permet de savoir quel écran est affiché quand un contrôleur particulier est utilisé et de savoir où et comment s'en débarrasser.
De plus, la classe Binding vous permettra d'avoir un contrôle de configuration de SmartManager. Vous pouvez configurer les dépendances à organiser lors de la suppression d'une route de la pile, ou lorsque le widget qui l'a utilisé est mis en page, ni l'un ni l'autre. Vous aurez une gestion intelligente des dépendances qui fonctionne pour vous, mais malgré cela, vous pouvez le configurer comme vous le souhaitez.

### Classe de liaisons

- Créer une classe et implémenter la liaison

```dart
class HomeBinding implements Bindings {}
```

Votre IDE vous demandera automatiquement d'outrepasser la méthode "dépendances", et il vous suffit de cliquer sur la lampe, outrepasser la méthode et insérer toutes les classes que vous allez utiliser sur cette route :

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

Maintenant, il vous suffit d'informer votre itinéraire, que vous utiliserez cette liaison pour faire la connexion entre le gestionnaire de routes, les dépendances et les états.

- Utilisation des routes nommées:

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

- Utiliser des itinéraires normaux :

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Là, vous n'avez plus à vous soucier de la gestion de la mémoire de votre application, Get will do it for vous.

La classe de liaison est appelée lorsqu'une route est appelée, vous pouvez créer un "initialBinding dans votre GetMaterialApp pour insérer toutes les dépendances qui seront créées.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### Constructeur de liens

La façon par défaut de créer une liaison est de créer une classe qui implémente Bindings.
Mais alternativement, vous pouvez utiliser le callback `BindingsBuilder` pour que vous puissiez simplement utiliser une fonction pour instancier ce que vous voulez.

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

De cette façon, vous pouvez éviter de créer une classe de liaison pour chaque route, ce qui rend cela encore plus simple.

Les deux façons de faire fonctionnent parfaitement bien et nous voulons que vous utilisiez ce qui convient le mieux à vos goûts.

### Gestion intelligente

GetX par défaut dispose des contrôleurs inutilisés de la mémoire, même si un échec se produit et qu'un widget qui l'utilise n'est pas correctement installé.
C'est ce que l'on appelle le mode `full` de gestion des dépendances.
Mais si vous voulez changer la façon dont GetX contrôle la disposition des classes, vous avez la classe `SmartManagement` que vous pouvez définir des comportements différents.

#### Comment changer

Si vous voulez modifier cette configuration (ce dont vous n'avez généralement pas besoin), c'est de cette façon :

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilder //here
      home: Home(),
    )
  )
}
```

#### Complètement

C'est celui par défaut. Éliminer les classes qui ne sont pas utilisées et qui n'ont pas été configurées pour être permanentes. Dans la plupart des cas, vous voudrez garder cette configuration intacte. Si vous débutez sur GetX, ne changez pas cela.

#### Seulement le constructeur

Avec cette option, seuls les contrôleurs démarrés dans `init:` ou chargés dans un Binding avec `Get.lazyPut()` seront jetés.

Si vous utilisez `Get.put()` ou `Get.putAsync()` ou toute autre approche, SmartManagement n'aura pas les permissions d'exclure cette dépendance.

Avec le comportement par défaut, même les widgets instanciés avec "Get.put" seront supprimés, contrairement à SmartManagement.onlyBuilder.

#### Usine de gestion intelligente

Tout comme SmartManagement.full, il supprimera ses dépendances lorsqu'il n'est plus utilisé. Cependant, il conservera leur usine, ce qui signifie qu'il recréera la dépendance si vous avez besoin de cette instance à nouveau.

### Comment les liaisons fonctionnent sous la capuche

Les liaisons créent des usines transitoires, qui sont créées dès que vous cliquez pour aller à un autre écran, et sera détruite dès que l'animation de changement d'écran aura lieu.
Cela arrive si vite que l'analyseur ne sera même pas en mesure de l'enregistrer.
Lorsque vous accédez à cet écran à nouveau, une nouvelle usine temporaire sera appelée, donc il est préférable d'utiliser SmartManagement. eepFactory, mais si vous ne voulez pas créer de Bindings, ou si vous voulez garder toutes vos dépendances sur la même Lie, cela vous aidera certainement.
Les usines prennent peu de mémoire, elles ne contiennent pas d'instances, mais une fonction avec la "forme" de cette classe que vous voulez.
Cela a un coût très bas en mémoire, mais puisque le but de cette lib est d'obtenir le maximum de performance possible en utilisant les ressources minimales, Obtenir des suppressions même les usines par défaut.
Utilisez ce qui vous convient le mieux.

## Notes

- NE PAS UTILISER SmartManagement.keepFactory si vous utilisez plusieurs Bindings. Il a été conçu pour être utilisé sans Liaison ou avec un seul Liage lié dans l'initialLiaison de GetMaterialApp.

- L'utilisation de Bindings est complètement optionnelle, si vous le souhaitez, vous pouvez utiliser `Get.put()` et `Get.find()` sur les classes qui utilisent un contrôleur donné sans aucun problème.
  Cependant, si vous travaillez avec Services ou toute autre abstraction, je vous recommande d'utiliser Bindings pour une meilleure organisation.
