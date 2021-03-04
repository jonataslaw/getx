- [Gestion de route](#gestion-de-route)
  - [Utilisation](#utilisation)
  - [Navigation sans nom](#navigation-sans-nom)
  - [Navigation par nom](#navigation-par-nom)
    - [Envoyer des données aux routes nommées](#envoyer-des-donnes-aux-routes-nommes)
    - [Liens URL dynamiques](#liens-url-dynamiques)
    - [Middleware](#middleware)
  - [Navigation sans context](#navigation-sans-context)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [Nested Navigation](#nested-navigation)

# Gestion de route

C'est l'explication complète de tout ce qu'il y a à savoir sur Getx quand il s'agit de la gestion des routes.

## Utilisation

Ajoutez ceci à votre fichier pubspec.yaml:

```yaml
dependencies:
  get:
```

Si vous allez utiliser des routes/snackbars/dialogs/bottomsheets sans contexte, ou utiliser les API Get de haut niveau, vous devez simplement ajouter "Get" avant votre MaterialApp, en le transformant en GetMaterialApp et en profiter!

```dart
GetMaterialApp( // Avant: MaterialApp(
  home: MyHome(),
)
```

## Navigation sans nom

Pour accéder à un nouvel écran:

```dart
Get.to(NextScreen());
```

To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);
Pour fermer les snackbars, dialogs, bottomsheets ou tout ce que vous fermez normalement avec Navigator.pop (context);

```dart
Get.back();
```

Pour aller à l'écran suivant et aucune option pour revenir à l'écran précédent (pour une utilisation dans SplashScreens, écrans de connexion, etc.)

```dart
Get.off(NextScreen());
```

Pour aller à l'écran suivant et annuler toutes les routes précédents (utile dans les paniers d'achat e-commerce, les sondages et les tests)

```dart
Get.offAll(NextScreen());
```

Pour naviguer vers l'écran suivant et recevoir ou mettre à jour des données dès que vous en revenez:

```dart
var data = await Get.to(Payment());
```

sur l'autre écran, envoyez les données pour l'écran précédent:

```dart
Get.back(result: 'success');
```

Et utilisez-les:

ex:

```dart
if(data == 'success') madeAnything();
```

Vous ne voulez pas apprendre notre syntaxe?
Changez simplement le Navigateur (majuscule) en navigateur (minuscule), et vous aurez toutes les fonctions de la navigation standard, sans avoir à utiliser 'context'.
Exemple:

```dart

// Navigateur Flutter par défaut
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Utilisez la syntaxe Flutter sans avoir besoin de 'context'
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Syntaxe Get (c'est beaucoup mieux, mais vous avez le droit d'être en désaccord)
Get.to(HomePage());


```

## Navigation Par Nom

- Si vous préférez naviguer par namedRoutes, Get prend également en charge cela.

Pour aller à nextScreen

```dart
Get.toNamed("/NextScreen");
```

Pour naviguer et supprimer l'écran précédent du stack.

```dart
Get.offNamed("/NextScreen");
```

Pour naviguer et supprimer tous les écrans précédents du stack.

```dart
Get.offAllNamed("/NextScreen");
```

Pour définir des routes, utilisez GetMaterialApp:

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

Pour gérer la navigation vers des routes non définies (erreur 404), vous pouvez définir une page 'unknownRoute' dans GetMaterialApp.

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

### Envoyer des données aux routes nommées

Envoyez simplement ce que vous voulez comme arguments. Get accepte n'importe quoi ici, qu'il s'agisse d'une String, d'une Map, d'une List ou même d'une instance de classe.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

dans votre classe ou contrôleur:

```dart
print(Get.arguments);
//montre: Get is the best
```

### Liens URL dynamiques

Get propose des URL dynamiques avancées, tout comme sur le Web. Les développeurs Web ont probablement déjà voulu cette fonctionnalité sur Flutter, et ont très probablement vu un package promettre cette fonctionnalité et fournir une syntaxe totalement différente de celle d'une URL sur le Web, mais Get résout également cela.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

sur votre classe controller/bloc/stateful/stateless:

```dart
print(Get.parameters['id']);
// donne: 354
print(Get.parameters['name']);
// donne: Enzo
```

Vous pouvez également recevoir facilement des paramètres nommés avec Get:

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
       //Vous pouvez définir une page différente pour les routes avec arguments, et une autre sans arguments, mais pour cela vous devez utiliser la barre oblique '/' sur la route qui ne recevra pas d'arguments comme ci-dessus.
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

Envoyer des données sur le nom de la route

```dart
Get.toNamed("/profile/34954");
```

Sur le deuxième écran, recevez les données par paramètre

```dart
print(Get.parameters['user']);
// donne: 34954
```

Et maintenant, tout ce que vous avez à faire est d'utiliser Get.toNamed() pour parcourir vos routes nommées, sans aucun contexte (vous pouvez appeler vos routes directement à partir de votre classe BLoC ou Controller), et lorsque votre application est compilée sur le Web, vos routes apparaîtront dans l'url <3

### Middleware

Si vous souhaitez écouter les événements Get pour déclencher des actions, vous pouvez utiliser routingCallback pour le faire:

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Si vous n'utilisez pas GetMaterialApp, vous pouvez utiliser l'API manuelle pour attacher l'observateur Middleware.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // ICI !!!
      ],
    ),
  );
}
```

Créez une classe MiddleWare

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Vous pouvez écouter en plus des routes, des snackbars, des dialogs et des bottomsheets sur chaque écran.
    /// Si vous devez saisir l'un de ces 3 événements directement ici,
    /// vous devez spécifier que l'événement est != Ce que vous essayez de faire.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('dernière route');
    }
  }
}
```

Maintenant, utilisez Get sur votre code:

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

## Navigation sans context

### SnackBars

Pour avoir un simple SnackBar avec Flutter, vous devez obtenir le 'context' de Scaffold, ou vous devez utiliser un GlobalKey attaché à votre Scaffold

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// Trouvez le scaffold dans l'arborescence des widgets et utilisez-le pour afficher un SnackBar.
Scaffold.of(context).showSnackBar(snackBar);
```

Avec Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Avec Get, tout ce que vous avez à faire est d'appeler votre Get.snackbar à partir de n'importe où dans votre code ou de le personnaliser comme vous le souhaitez!

```dart
Get.snackbar(
  "Hey i'm a Get SnackBar!", // title
  "C'est incroyable! J'utilise SnackBar sans context, sans code standard, sans Scaffold, c'est quelque chose de vraiment incroyable!", // message
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// TOUTES LES FONCTIONNALITÉS //////////
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

Si vous préférez le snack-bar traditionnel, ou souhaitez le personnaliser à partir de zéro, y compris en ajoutant une seule ligne (Get.snackbar utilise un titre et un message obligatoires), vous pouvez utiliser
`Get.rawSnackbar ();` qui fournit l'API brute sur laquelle Get.snackbar a été construit.

### Dialogs

Pour ouvrir un 'dialog':

```dart
Get.dialog(VotreDialogWidget());
```

Pour ouvrir le 'dialog' par défaut:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

Vous pouvez également utiliser Get.generalDialog au lieu de showGeneralDialog.

Pour tous les autres widgets de la boîte de dialogue Flutter, y compris cupertinos, vous pouvez utiliser Get.overlayContext au lieu du context et l'ouvrir n'importe où dans votre code.
Pour les widgets qui n'utilisent pas Overlay, vous pouvez utiliser Get.context.
Ces deux contextes fonctionneront dans 99% des cas pour remplacer le context de votre interface utilisateur, sauf dans les cas où inheritedWidget est utilisé sans context de navigation.

### BottomSheets

Get.bottomSheet est comme showModalBottomSheet, mais n'a pas besoin de 'context'.

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

## Nested Navigation

Getx a rendu la navigation imbriquée de Flutter encore plus facile.
Vous n'avez pas besoin de 'context' et vous trouverez votre stack de navigation par ID.

- NOTE: La création de stacks de navigation parallèles peut être dangereuse. L'idéal est de ne pas utiliser NestedNavigators, ou de l'utiliser avec parcimonie. Si votre projet l'exige, allez-y, mais gardez à l'esprit que conserver plusieurs stacks de navigation en mémoire n'est peut-être pas une bonne idée pour la consommation de RAM.

Voyez comme c'est simple:

```dart
Navigator(
  key: Get.nestedKey(1), // créez une clé par index
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
                Get.toNamed('/second', id:1); // naviguer votre itinéraire imbriqué par index
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
