---
sidebar_position: 2
---

# Ruta

Esta es la explicación completa de todo lo que hay para Getx cuando el asunto es la gestión de rutas.

## Cómo usar

Añade esto a tu archivo pubspec.yaml:

```yaml
dependencies:
  get:
```

Si va a usar rutas/barras/barras/diálogo/hojas de abajo sin contexto, o utilizar las APIs de alto nivel, tienes que simplemente añadir "Get" antes de tu MaterialApp, convirtiéndola en GetMaterialApp y disfrutar!

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Navegación sin rutas con nombre

Para navegar a una nueva pantalla:

```dart
Get.to(NextScreen());
```

Para cerrar barras de rejillas, diálogos, hojas de fondo, o cualquier cosa que normalmente cierre con Navigator.pop(context);

```dart
Get.back();
```

Para ir a la siguiente pantalla y no hay opción para volver a la pantalla anterior (para uso en SplashScreens, pantallas de inicio de sesión y etc.)

```dart
Get.off(NextScreen());
```

Para ir a la siguiente pantalla y cancelar todas las rutas anteriores (útil en carritos de la compra, encuestas y pruebas)

```dart
Get.offAll(NextScreen());
```

Para navegar a la siguiente ruta, y recibir o actualizar los datos tan pronto como regrese de él:

```dart
var data = await Get.to(Payment());
```

en otra pantalla, enviar datos para la ruta anterior:

```dart
Get.back(result: 'success');
```

Y úsalo:

ex:

```dart
if(data == 'success') madeAnything();
```

¿No quieres aprender nuestra sintaxis?
Simplemente cambia el Navigator (mayúsculas) a navegador (minúsculas), y tendrá todas las funciones de la navegación estándar, sin tener que utilizar el contexto
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

## Navegación con rutas con nombre

- Si prefiere navegar por namedRoutes, Get también soporta esto.

Para navegar a la siguiente pantalla

```dart
Get.toNamed("/NextScreen");
```

Para navegar y quitar la pantalla anterior del árbol.

```dart
Get.offNamed("/NextScreen");
```

Para navegar y eliminar todas las pantallas anteriores del árbol.

```dart
Get.offAllNamed("/NextScreen");
```

Para definir rutas, utilice GetMaterialApp:

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

Para manejar la navegación a rutas no definidas (error 404), puede definir una página desconocida en GetMaterialApp.

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

Envía lo que quieras para los argumentos. Obtén cualquier cosa aquí, ya sea una cadena, un mapa, una lista o incluso una instancia de clase.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

en tu clase o controlador:

```dart
print(Get.arguments);
//print out: Get is the best
```

### Enlaces de urls dinámicos

Obtenga urls dinámicas avanzadas como en la Web. Probablemente los desarrolladores web ya han querido esta característica en Flutter, y lo más probable es que hayan visto una promesa de paquete esta característica y entregado una sintaxis totalmente diferente de la que tendría una URL en la web, pero Obtener también resuelve eso.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

en tu clase controlador/bloque/stateful/stateless :

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

También puedes recibir NamedParameters con facilidad:

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

Enviar datos al nombre de ruta

```dart
Get.toNamed("/profile/34954");
```

En la segunda pantalla tomar los datos por parámetro

```dart
print(Get.parameters['user']);
// out: 34954
```

o enviar múltiples parámetros como este

```dart
Get.toNamed("/profile/34954?flag=true&country=italy");
```

o

```dart
var parameters = <String, String>{"flag": "true","country": "italy",};
Get.toNamed("/profile/34954", parameters: parameters);
```

En la segunda pantalla tomar los datos por parámetros como normalmente

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
print(Get.parameters['country']);
// out: 34954 true italy
```

Y ahora, todo lo que necesitas hacer es usar Get. oNamed() para navegar por sus rutas nombradas, sin ningún contexto (puede llamar a sus rutas directamente desde su clase BLoC o Controlador), y cuando tu aplicación esté compilada en la web, tus rutas aparecerán en la url < 3

### Medios

Si quieres escuchar Obtener eventos para activar acciones, puedes usar routingCallback a él

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Si no está usando GetMaterialApp, puede utilizar la API manual para adjuntar observador de Middleware.

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

Crear una clase MiddleWare

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

Ahora, usa Get on your code:

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

Para tener un SnackBar simple con Flutter, debes tener el contexto de Scaffold, o debes usar una GlobalKey conectada a tu Scaffold

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

Con obtener:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Con Get, todo lo que tienes que hacer es llamar a tu Get.snackbar desde cualquier lugar de tu código o personalizarlo como quieras!

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

Si prefieres la tradicional barra de barras o quieres personalizarla desde cero, incluyendo añadir una sola línea (Obtén. nackbar hace uso de un título y mensaje obligatorios), puedes usar
`Get.rawSnackbar();` que proporciona la API RAW en la que se construyó Get.snackbar.

### Diálogos

Para abrir el diálogo:

```dart
Get.dialog(YourDialogWidget());
```

Para abrir el cuadro de diálogo predeterminado:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

También puede utilizar Get.generalDialog en lugar de showGeneralDialog.

Para todos los demás widgets de diálogo de Flutter, incluyendo cupertinos, puede usar Get.overlayContext en lugar de contexto, y abrirlo en cualquier lugar de su código.
Para los widgets que no usan Overlay, puede usar Get.context.
Estos dos contextos funcionarán en el 99% de los casos para reemplazar el contexto de tu interfaz de usuario excepto los casos en los que herededWidget se utiliza sin un contexto de navegación.

### Hojas

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

Haz que la navegación anidada de Flutter sea aún más fácil.
No necesita el contexto, y encontrará su pila de navegación por Id.

- NOTA: Crear pilas de navegación paralelas puede ser peligroso. Lo ideal es no utilizar NestedNavigators ni utilizar esparcidamente. Si su proyecto lo necesita, siga adelante, pero ten en cuenta que mantener múltiples pilas de navegación en memoria puede no ser una buena idea para el consumo de RAM.

Mira lo simple que es:

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
