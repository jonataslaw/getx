---
sidebar_position: 2
---

# Itinéraire

C'est l'explication complète de tout ce qu'il y a à Getx quand il s'agit de la gestion des routes.

## Comment utiliser

Ajouter ceci à votre fichier pubspec.yaml :

```yaml
dependencies:
  get:
```

Si vous utilisez des routes/snackbars/dialogs/bottomsheets sans contexte, ou utilisez les API de haut niveau, vous devez simplement ajouter "Get" avant votre MaterialApp, la transformer en GetMaterialApp et profiter !

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Navigation sans routes nommées

Pour naviguer vers un nouvel écran :

```dart
Get.to(NextScreen());
```

Pour fermer les barres de collation, les dialogues, les feuilles du bas ou tout ce que vous fermeriez normalement avec Navigator.pop(contexte);

```dart
Get.back();
```

Pour passer à l'écran suivant et aucune option pour revenir à l'écran précédent (pour utiliser dans SplashScreens, les écrans de connexion et etc.)

```dart
Get.off(NextScreen());
```

Pour aller à l'écran suivant et annuler tous les itinéraires précédents (utiles dans les paniers, les sondages et les tests)

```dart
Get.offAll(NextScreen());
```

Pour naviguer vers l'itinéraire suivant, et recevoir ou mettre à jour les données dès que vous revenez depuis:

```dart
var data = await Get.to(Payment());
```

sur un autre écran, envoyer des données pour la route précédente :

```dart
Get.back(result: 'success');
```

Et utilisez:

ex:

```dart
if(data == 'success') madeAnything();
```

Vous ne voulez pas apprendre notre syntaxe ?
Il suffit de changer le navigateur (majuscule) en navigateur (minuscule), et vous aurez toutes les fonctions de la navigation standard, sans avoir à utiliser le contexte
Exemple:

```dart

// Default Flutter navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Get using Flutter syntax without needing context
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Get syntax (It is much better, but you have the right to disagree)
Get.to(HomePage());


```

## Navigation avec les routes nommées

- Si vous préférez naviguer par namedRoutes, Get also supports ceci.

Pour naviguer vers le prochain écran

```dart
Get.toNamed("/NextScreen");
```

Pour naviguer et supprimer l'écran précédent de l'arborescence.

```dart
Get.offNamed("/NextScreen");
```

Pour naviguer et supprimer tous les écrans précédents de l'arborescence.

```dart
Get.offAllNamed("/NextScreen");
```

Pour définir des routes, utilisez GetMaterialApp :

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
        GetPage(
          name: '/third',
          page: () => Third(),
          transition: Transition.zoom  
        ),
      ],
    )
  );
}
```

Pour gérer la navigation vers des routes non définies (404 erreur), vous pouvez définir une page unknownRoute dans GetMaterialApp.

```dart
void main() {
  runApp(
    GetMaterialApp(
      unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
      ],
    )
  );
}
```

### Envoyer des données aux Routes nommées

Envoyez simplement ce que vous voulez pour des arguments. Obtenir n'importe quoi accepte ici, qu'il s'agisse d'une String, d'une Map, d'une Liste, ou même d'une instance de classe.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

sur votre classe ou votre contrôleur :

```dart
print(Get.arguments);
//print out: Get is the best
```

### Liens d'URL dynamiques

Offrez des urls dynamiques avancés comme sur le Web. Les développeurs Web ont probablement déjà souhaité cette fonctionnalité sur Flutter, et très probablement ont vu un paquet promettre cette fonctionnalité et fournir une syntaxe totalement différente de celle qu'une URL aurait sur le web, mais Get aussi résout cela.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

sur votre contrôleur/bloc/état/classe sans état:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

Vous pouvez également recevoir des NamedParameters avec Get easily :

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
      GetPage(
        name: '/',
        page: () => MyHomePage(),
      ),
      GetPage(
        name: '/profile/',
        page: () => MyProfile(),
      ),
       //You can define a different page for routes with arguments, and another without arguments, but for that you must use the slash '/' on the route that will not receive arguments as above.
       GetPage(
        name: '/profile/:user',
        page: () => UserProfile(),
      ),
      GetPage(
        name: '/third',
        page: () => Third(),
        transition: Transition.cupertino  
      ),
     ],
    )
  );
}
```

Envoyer des données sur le nom de l'itinéraire

```dart
Get.toNamed("/profile/34954");
```

Sur le deuxième écran prendre les données par paramètre

```dart
print(Get.parameters['user']);
// out: 34954
```

ou envoyer plusieurs paramètres comme ceci

```dart
Get.toNamed("/profile/34954?flag=true&country=italy");
```

ou

```dart
var parameters = <String, String>{"flag": "true","country": "italy",};
Get.toNamed("/profile/34954", parameters: parameters);
```

Sur le deuxième écran prendre les données par paramètres comme d'habitude

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
print(Get.parameters['country']);
// out: 34954 true italy
```

Et maintenant, tout ce que vous devez faire est d'utiliser Get. oNamed() pour naviguer sur vos routes nommées, sans aucun contexte (vous pouvez appeler vos routes directement depuis votre classe BLoC ou Controller), et lorsque votre application est compilée sur le web, vos routes apparaîtront dans l'url < 3

### Middleware

Si vous voulez écouter Recevoir des événements pour déclencher des actions, vous pouvez utiliser routingCallback vers lui

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Si vous n'utilisez pas GetMaterialApp, vous pouvez utiliser l'API manuelle pour attacher un observateur Middleware.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
      ],
    ),
  );
}
```

Créer une classe MiddleWare

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen.
    ///If you need to enter any of these 3 events directly here,
    ///you must specify that the event is != Than you are trying to do.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

Maintenant, utilisez Get on your code:

```dart
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/second");
          },
        ),
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/third");
          },
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

## Navigation sans contexte

### SnackBars

Pour avoir un SnackBar simple avec Flutter, vous devez obtenir le contexte de l'échafaudage, ou vous devez utiliser une GlobalKey attachée à votre Échafaudage

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// Find the Scaffold in the widget tree and use
// it to show a SnackBar.
Scaffold.of(context).showSnackBar(snackBar);
```

Avec Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Avec Get, tout ce que vous avez à faire est d'appeler votre Get.snackbar de n'importe où dans votre code ou de le personnaliser comme vous le souhaitez !

```dart
Get.snackbar(
  "Hey i'm a Get SnackBar!", // title
  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// ALL FEATURES //////////
  //     Color colorText,
  //     Duration duration,
  //     SnackPosition snackPosition,
  //     Widget titleText,
  //     Widget messageText,
  //     bool instantInit,
  //     Widget icon,
  //     bool shouldIconPulse,
  //     double maxWidth,
  //     EdgeInsets margin,
  //     EdgeInsets padding,
  //     double borderRadius,
  //     Color borderColor,
  //     double borderWidth,
  //     Color backgroundColor,
  //     Color leftBarIndicatorColor,
  //     List<BoxShadow> boxShadows,
  //     Gradient backgroundGradient,
  //     TextButton mainButton,
  //     OnTap onTap,
  //     bool isDismissible,
  //     bool showProgressIndicator,
  //     AnimationController progressIndicatorController,
  //     Color progressIndicatorBackgroundColor,
  //     Animation<Color> progressIndicatorValueColor,
  //     SnackStyle snackStyle,
  //     Curve forwardAnimationCurve,
  //     Curve reverseAnimationCurve,
  //     Duration animationDuration,
  //     double barBlur,
  //     double overlayBlur,
  //     Color overlayColor,
  //     Form userInputForm
  ///////////////////////////////////
```

Si vous préférez le snackbar traditionnel, ou si vous voulez le personnaliser à partir de zéro, y compris en ajoutant une seule ligne (Get. nackbar utilise un titre et un message obligatoires), vous pouvez utiliser
`Get.rawSnackbar();` qui fournit l'API RAW sur laquelle Get.snackbar a été construit.

### Dialogues

Pour ouvrir la boîte de dialogue :

```dart
Get.dialog(YourDialogWidget());
```

Pour ouvrir la boîte de dialogue par défaut :

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

Vous pouvez également utiliser Get.generalDialog au lieu de showGeneralDialog.

Pour tous les autres widgets de dialogue Flut, y compris les cupertinos, vous pouvez utiliser Get.overlayContext au lieu du contexte, et l'ouvrir n'importe où dans votre code.
Pour les widgets qui n'utilisent pas Overlay, vous pouvez utiliser Get.context .
Ces deux contextes fonctionneront dans 99% des cas pour remplacer le contexte de votre interface utilisateur à l'exception des cas où le Widget hérité est utilisé sans contexte de navigation.

### Feuilles en bas

Get.bottomSheet est comme showModalBottomSheet, mais pas besoin de contexte.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Music'),
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () {},
        ),
      ],
    ),
  )
);
```

## Navigation imbriquée

Rendez la navigation imbriquée de Flutter encore plus facile.
Vous n'avez pas besoin du contexte, et vous trouverez votre pile de navigation par Id.

- REMARQUE : La création de piles de navigation parallèle peut être dangereuse. L'idéal n'est pas d'utiliser NestedNavigators ou d'utiliser avec modération. Si votre projet l'exige, allez-y, mais gardez à l'esprit que garder plusieurs piles de navigation en mémoire peut ne pas être une bonne idée pour la consommation de mémoire.

Voyez à quel point c'est simple :

```dart
Navigator(
  key: Get.nestedKey(1), // create a key by index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetPageRoute(
        page: () => Scaffold(
          appBar: AppBar(
            title: Text("Main"),
          ),
          body: Center(
            child: TextButton(
              color: Colors.blue,
              onPressed: () {
                Get.toNamed('/second', id:1); // navigate by your nested route by index
              },
              child: Text("Go to second"),
            ),
          ),
        ),
      );
    } else if (settings.name == '/second') {
      return GetPageRoute(
        page: () => Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Main"),
            ),
            body: Center(
              child:  Text("second")
            ),
          ),
        ),
      );
    }
  }
),
```
