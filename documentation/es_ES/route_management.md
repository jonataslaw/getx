- [Gestión de Rutas](#gestión-de-rutas)
  - [¿Cómo utilizarlo](#cómo-utilizarlo)
  - [Navegación sin rutas nombradas](#navegación-sin-rutas-nombradas)
  - [Navegación con rutas nombradas](#navegación-con-rutas-nombradas)
    - [Enviar datos a rutas nombradas](#enviar-datos-a-rutas-nombradas)
    - [Enlaces de URL dinámicos](#enlaces-de-url-dinámicos)
    - [Middleware](#middleware)
  - [Navegación sin contexto](#navegación-sin-contexto)
    - [SnackBars](#snackbars)
    - [Diálogos](#diálogos)
    - [BottomSheets](#bottomsheets)
  - [Navegación anidada](#navegación-anidada)

# Gestión de Rutas

Cualquier contribución es bienvenida!

## ¿Cómo utilizarlo

Agregue esto a su archivo pubspec.yaml:

```yaml
dependencies:
  get:
```

Si va a utilizar rutas/snackbars/dialogs/bottomsheets sin contexto, o las APIs de GetX de alto nivel, simplemente debe agregar "Get" antes de su MaterialApp, ¡convertirlo en GetMaterialApp y disfrutar!

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Navegación sin rutas nombradas

Para navegar a una nueva pantalla:

```dart
Get.to(NextScreen());
```

Para cerrar snackbars, dialogs, bottomsheets o cualquier cosa que normalmente cierre con Navigator.pop(contexto);

```dart
Get.back();
```

Para ir a la siguiente pantalla, sin opción a volver (util por ejemplo en SplashScreens, LoginScreen, etc.)

```dart
Get.off(NextScreen());
```

Para ir a la siguiente pantalla y cancelar todas las rutas anteriores (útil en carritos de compras, encuestas y exámenes)

```dart
Get.offAll(NextScreen());
```

Para navegar a la siguiente ruta y recibir o actualizar datos tan pronto como se regrese de ella:

```dart
var data = await Get.to(Payment());
```

en la otra pantalla, envíe los datos para la ruta anterior:

```dart
Get.back(result: 'success');
```

Y luego usarlo:

ej:

```dart
if(data == 'success') madeAnything();
```

¿No quieres aprender nuestra sintaxis?

Simplemente cambie Navigator (mayúsculas) a navigator (minúsculas), y tendrá todas las funciones de la navegación estándar, pero sin tener que usar el contexto.

Ejemplo:

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

## Navegación con rutas nombradas

- Si prefiere navegar con rutas nombradas, con GetX también es posible.

Para navegar a la siguiente pantalla

```dart
Get.toNamed("/NextScreen");
```

Para navegar y eliminar la pantalla anterior del árbol.

```dart
Get.offNamed("/NextScreen");
```

Para navegar y eliminar todas las pantallas anteriores del árbol.

```dart
Get.offAllNamed("/NextScreen");
```

Para definir rutas, use GetMaterialApp:

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

Para manejar la navegación a rutas no definidas (error 404), puede definir una página de ruta desconocida en GetMaterialApp.

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

### Enviar datos a rutas nombradas

Envía lo que quieras usando el parámetro arguments. GetX acepta cualquier cosa aquí, ya sea un String, Map, List o incluso una instancia de clase.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

luego en su clase o controlador:

```dart
print(Get.arguments);
//print out: Get is the best
```

### Enlaces de URL dinámicos

GetX ofrece URLs dinámicas avanzadas como en la Web. Los desarrolladores web probablemente ya quisieron esta característica en Flutter, y lo más probable es que hayan visto un paquete que promete esta característica y pero que ofrece una sintaxis totalmente diferente a la que una URL tendría en la web, pero GetX lo resuelve.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

y luego en su clase controller/bloc/stateful/stateless:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

También puede recibir parámetros nombrados fácilmente:

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

Enviar datos sobre el nombre de la ruta

```dart
Get.toNamed("/second/34954");
```

Y en la segunda pantalla tome los datos por parámetro

```dart
print(Get.parameters['user']);
// out: 34954
```

Y ahora, todo lo que necesita hacer es usar Get.toNamed() para navegar por sus rutas nombradas, sin ningún contexto (puede llamar a sus rutas directamente desde su clase BLoC o Controller), y cuando su aplicación se compila para web, sus rutas aparecerán en la url del navegador <3

### Middleware

Si desea escuchar eventos  de GetX para activar acciones, puede usar el routingCallback:

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Si no está usando GetMaterialApp, puede usar la API para adjuntar el observador de Middleware.

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

Crear la clase MiddleWare:

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

Ahora, usa GetX en tu código:

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

## Navegación sin contexto

### SnackBars

Para tener simple SnackBar con Flutter, debe obtener el contexto de Scaffold, o debe utilizar una GlobalKey:

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

Con GetX esto se resume en:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Todo lo que tiene que hacer es llamar a Get.snackbar desde cualquier parte de su código y personalizarlo como desee:

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

Si prefiere el snackbar tradicional, o desea personalizarlo desde cero, inclyendo reducirlo a una sola línea de código (dado que Get.snackbar utiliza al menos un título y un mensaje obligatorios), puede usar `Get.rawSnackbar();` que proporciona la API en la que se creó el Get.snackbar.

### Diálogos

Para abrir el dialog:

```dart
Get.dialog(YourDialogWidget());
```

Para abrir un dialog predeterminado:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

También puede usar Get.generalDialog en lugar de showGeneralDialog.

Para todos los demás dialogs de Flutter, incluidos los cupertinos, puede usar Get.overlayContext en lugar de context, y abrirlo en cualquier parte de su código.

Para los widgets que no usan Overlay, puede usar Get.context.

Estos dos contexts funcionarán en el 99% de los casos para reemplazar el context de su UI, excepto en los casos donde inheritedWidget es usado sin un contexto de navegación.

### BottomSheets

Get.bottomSheet es como showModalBottomSheet, pero no necesita contexto.

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

## Navegación anidada

GetX hizo la navegación anidada de Flutter aún más fácil.

No necesita el contexto, y encontrará su pila de navegación por Id.

- NOTA: Crear pilas de navegación paralelas puede ser peligroso. Lo ideal es no usar NestedNavigators o hacerlo con moderación. Si su proyecto lo requiere, continúe, pero tenga en cuenta que mantener múltiples pilas de navegación en la memoria puede no ser una buena idea para el consumo de RAM.

Mira qué simple es:

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
