- [Gestion de route](#gestion-de-route)
  - [Utilisation](#utilisation)
  - [xNavigation sans routes nommées](#navigation-sans-routes-nommees)
  - [Navigation par nom](#navigation-par-nom)
    - [Send data to named Routes](#send-data-to-named-routes)
    - [Dynamic urls links](#dynamic-urls-links)
    - [Middleware](#middleware)
  - [Navigation without context](#navigation-without-context)
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

Et maintenant, tout ce que vous avez à faire est d'utiliser Get.toNamed () pour parcourir vos routes nommées, sans aucun contexte (vous pouvez appeler vos routes directement à partir de votre classe BLoC ou Controller), et lorsque votre application est compilée sur le Web, vos routes apparaîtront dans l'url <3

### Middleware

If you want listen Get events to trigger actions, you can to use routingCallback to it

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

If you are not using GetMaterialApp, you can use the manual API to attach Middleware observer.

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

Create a MiddleWare class

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

Now, use Get on your code:

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
        child: RaisedButton(
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
        child: RaisedButton(
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
        child: RaisedButton(
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

## Navigation without context

### SnackBars

To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold

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

With Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

With Get, all you have to do is call your Get.snackbar from anywhere in your code or customize it however you want!

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
  //     FlatButton mainButton,
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

If you prefer the traditional snackbar, or want to customize it from scratch, including adding just one line (Get.snackbar makes use of a mandatory title and message), you can use
`Get.rawSnackbar();` which provides the RAW API on which Get.snackbar was built.

### Dialogs

To open dialog:

```dart
Get.dialog(YourDialogWidget());
```

To open default dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

You can also use Get.generalDialog instead of showGeneralDialog.

For all other Flutter dialog widgets, including cupertinos, you can use Get.overlayContext instead of context, and open it anywhere in your code.
For widgets that don't use Overlay, you can use Get.context.
These two contexts will work in 99% of cases to replace the context of your UI, except for cases where inheritedWidget is used without a navigation context.

### BottomSheets

Get.bottomSheet is like showModalBottomSheet, but don't need of context.

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

Get made Flutter's nested navigation even easier.
You don't need the context, and you will find your navigation stack by Id.

- NOTE: Creating parallel navigation stacks can be dangerous. The ideal is not to use NestedNavigators, or to use sparingly. If your project requires it, go ahead, but keep in mind that keeping multiple navigation stacks in memory may not be a good idea for RAM consumption.

See how simple it is:

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
            child: FlatButton(
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
