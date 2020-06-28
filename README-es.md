![](get.png)

*Idiomas: Español (este archivo), [Inglés](README.md), [Portugués de Brasil](README.pt-br.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get) 
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

- GetX es una solución extra ligera y potente para Flutter. Combina gestión de estádo de alto rendimiento, inyección de dependencia inteligente y gestión de rutas, de forma rápida y práctica.  

- GetX no es para todos, se enfoca en el consumo mínimo de recursos (rendimiento) ([Mira los puntos de referencia](https://github.com/jonataslaw/benchmarks)), usando una sintaxis fácil y agradable (productividad), que permite el desacoplamiento total de la vista y la lógica de negocio (organización).

- GetX permite ahorrar horas de desarrollo, extraer el máximo rendimiento de una aplicación, siendo tatno fácil de implementar para principiantes como precisa para expertos. Navegue sin contexto, abra dialogs, snackbars y bottomsheets desde cualquier parte de su código, gestione estados e inyecte dependencias de una manera fácil y práctica. GetX es seguro, estable, actualizado y ofrece una amplia gama de APIs que no están presentes en el framework por defecto.

- Tiene una multitud de funciones que le permiten comenzar a programar sin preocuparse por nada. Cada una de estas funciones se encuentra en contenedores separados y solo se inicia después de su uso. Si solo usa State Management, solo State Management se compilará. Si solo usa rutas, no se compilará nada de gestión de estado. Puede compilar el repositorio de referencia, y verá que usando solo la gestión de estado de GetX, la aplicación compilada se ha vuelto más pequeña que todas las demás aplicaciones de otros paquetes que solo tienen la gestión de estado, porque nada de lo que no se use se compilará en su código, y cada solución GetX fue diseñada para ser extra liviana. El mérito aquí también proviene del AOT de Flutter, que es increíble y logra eliminar los recursos no utilizados como ningún otro framework lo hace.

**GetX hace que su desarrollo sea productivo, pero ¿quiere hacerlo aún más productivo? [Agregue la extensión a su VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)**

El proyecto "contador" creado por defecto en un nuevo proyecto en Flutter tiene más de 100 líneas (con comentarios). Para mostrar el poder de GetX, demostraré cómo hacer un "contador" cambiando el estado con cada clic, cambiando de página y compartiendo el estado entre pantallas, todo de manera organizada, separando la vista de la lógica de negocio, SOLO 26 LÍNEAS DE CÓDIGO INCLUIDOS COMENTARIOS.

- Paso 1:  
  Agregue "Get" antes de su materialApp, convirtiéndolo en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

Nota: esto no modifica el MaterialApp del Flutter, GetMaterialApp no es una MaterialApp modificado, es solo un Widget preconfigurado, que tiene como child un MaterialApp por defecto. Puede configurar esto manualmente, pero definitivamente no es necesario. GetMaterialApp creará rutas, las inyectará, inyectará traducciones, inyectará todo lo que necesita para la navegación de rutas. Si usa Get solo para la gestión de estado o dependencias, no es necesario usar GetMaterialApp. GetMaterialApp es necesario para rutas, snackbars, internacionalización, bottomSheets, diálogos y APIs de alto nivel relacionadas con rutas y ausencia de contexto.

- Paso 2:  
Cree su clase con la lógica de negocio colocando todas las variables, métodos y controladores dentro de ella. Puede hacer que cualquier variable sea observable usando un simple ".obs".

```dart
class Controller extends GETXController{
  var count = 0.obs; 
  increment() => count.value++;
}
```

- Paso 3:  
Cree su vista, use StatelessWidget y ahorre algo de RAM, con GetX ya no necesitará usar StatefulWidget.  

```dart
class Home extends StatelessWidget {

  // Instantiate your class using Get.put() to make it available for all "child" routes there.
  final Controller c = Get.put(Controller());

  @override
  Widget build(context) => Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: " + c.count.string))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: RaisedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text(c.count.string)));
}

```
Este es un proyecto simple pero ya deja en claro cuán poderoso es GetX. A medida que su proyecto crezca, esta diferencia se volverá más significativa. GetX fue diseñado para trabajar con equipos, pero también simplifica el trabajo de un desarrollador individual. Mejore sus plazos, entregue todo a tiempo, sin perder rendimiento. GetX no es para todos, pero si te identificaste con esa frase, ¡GET es para ti!

- [Gestión de Rutas](#gestión-de-rutas)
  - [¿Cómo utilizarlo?](#cómo-utilizarlo)
  - [Navegación sin rutas nombradas](#navegación-sin-rutas-nombradas)
  - [Navegación con rutas nombradas](#navegación-con-rutas-nombradas)
    - [Enviar datos a rutas nombradas:](#enviar-datos-a-rutas-nombradas)
    - [Enlaces de URL dinámicos](#enlaces-de-url-dinámicos)
    - [Middleware](#middleware)
  - [Navegación sin contexto](#navegación-sin-contexto)
    - [SnackBars](#snackbars)
    - [Diálogos](#diálogos)
    - [BottomSheets](#bottomsheets)
  - [Navegación anidada](#navegación-anidada)
- [Gestión del Estado](#gestión-del-estado)
  - [Gestor de Estado Simple](#gestor-de-estado-simple)
    - [Ventajas](#ventajas)
    - [Uso](#uso)
    - [Cómo maneja los Controllers](#cómo-maneja-los-controllers)
    - [Ya no necesitará StatefulWidgets](#ya-no-necesitará-statefulwidgets)
    - [Por qué existe](#por-qué-existe)
    - [Otras formas de usarlo](#otras-formas-de-usarlo)
    - [ID únicos](#id-únicos)
  - [Reactivo STATE_MANAGER](#reactivo-state_manager)
    - [Ventajas](#ventajas-1)
    - [Uso](#uso-1)
    - [Donde se pueden usar .obs](#donde-se-pueden-usar-obs)
    - [Nota sobre listas](#nota-sobre-listas)
    - [¿Por qué tengo que usar .value?](#por-qué-tengo-que-usar-value)
    - [Obx()](#obx)
    - [Workers:](#workers)
  - [Mezclando los dos State Managers](#mezclando-los-dos-state-managers)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)
- [Gestión de dependencias](#gestión-de-dependencias)
  - [Simple Instance Manager](#simple-instance-manager)
  - [Bindings](#bindings)
    - [Cómo utilizar](#cómo-utilizar)
  - [SmartManagement](#smartmanagement)
- [Utils](#utils)
  - [Cambiar de tema](#cambiar-de-tema)
  - [Otras API avanzadas y configuraciones manuales](#otras-api-avanzadas-y-configuraciones-manuales)
    - [Configuraciones globales opcionales](#configuraciones-globales-opcionales)
- [Rompiendo cambios desde 2.0](#rompiendo-cambios-desde-20)


*¿Quieres contribuir al proyecto? Estaremos orgullosos de destacarte como uno de nuestros colaboradores. Aquí hay algunos puntos en los que puede contribuir y hacer que GetX (y Flutter) sea aún mejor.*

- Ayudando a traducir el archivo Léame a otros idiomas.

- Agregar documentación al archivo Léame (ni siquiera la mitad de las funciones de GetX han sido documentadas todavía).

- Escriba artículos o haga videos que enseñen cómo usar GetX (se insertarán en el archivo Léame y en el futuro en nuestro Wiki).

- Ofreciendo PRs para código/pruebas.

- Incluyendo nuevas funciones.

# Gestión de Rutas

Cualquier contribución es bienvenida!

## ¿Cómo utilizarlo?

Agregue esto a su archivo pubspec.yaml:

```
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

### Enviar datos a rutas nombradas:

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
          onTap: () => {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () => {},
        ),
      ],
    ),
  );
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
        page: Scaffold(
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
        page: Center(
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

# Gestión del Estado

Actualmente hay varios State Managers para Flutter. Sin embargo, con la mayoría de ellos implica utilizar ChangeNotifier para actualizar widgets y este es un enfoque malo y muy malo para el rendimiento de aplicaciones medianas o grandes. Puede verificar en la documentación oficial de Flutter que [ChangeNotifier debe usarse con 1 o un máximo de 2 listeners](https://api.Flutter.dev/Flutter/foundation/ChangeNotifier-class.html), por lo que es prácticamente inutilizable para cualquier aplicación mediana o grande.

Otros state managers son buenos, pero tienen sus matices:

- BLoC es muy seguro y eficiente, pero es muy complejo para principiantes, lo que ha impedido que las personas se desarrollen con Flutter.

- MobX es más fácil que BLoC y reactivo, casi perfecto, diría, pero necesita usar un generador de código, que para aplicaciones grandes, reduce la productividad, ya que necesitará beber muchos cafés hasta que su código esté listo nuevamente después de un `flutter clean` (¡Y esto no es culpa de MobX, sino del codegen que es realmente lento!).

- Provider usa InheritedWidget para entregar el mismo listener, como una forma de resolver el problema mencionado anteriormente con ChangeNotifier, lo que implica que cualquier acceso a su clase ChangeNotifier debe estar dentro del árbol de widgets debido al contexto necesario para acceder.

GetX no es mejor ni peor que cualquier otro gestor de estado, pero debe analizar estos puntos, así como los puntos que se mencionan a continuación, para elegir entre usar GetX en forma pura (vanilla) o usarlo junto con otro gestor de estado. 

Definitivamente, GetX no es enemigo de ningún otro gestor de estado, porque GetX es más bien un microframework, no solo un gestor de estado, y se puede usar solo o en combinación con ellos.

## Gestor de Estado Simple

GetX tiene un gestor de estado que es extremadamente ligero y fácil de implementar, especialmente para aquellos nuevos en Flutter, que no utiliza ChangeNotifier, y satisface la necesidad, y no causará problemas en aplicaciones grandes.

### Ventajas

1. Actualiza solo los widgets necesarios.

2. No usa changeNotifier, es el gestor de estados que usa menos memoria (cerca de 0mb).

3. ¡Olvídate de StatefulWidget! Con GetX nunca lo necesitarás. Con los otros state managers, probablemente tendrá que usar un StatefulWidget para obtener la instancia de su Provider,BLoC,MobX Controller, etc. Pero alguna vez se detuvo para pensar que su appBar, su Scaffold y la mayoría de los widgets que están en tu clase son Stateless? Entonces, ¿por qué guardar el estado de una clase completa, si puede guardar solo el estado del widget que es Stateful? GetX también resuelve eso. Crea una clase Stateless, haz todo Stateless. Si necesita actualizar un solo componente, envuélvalo con GetBuilder, y se mantendrá su estado.

4. ¡Organiza tu proyecto de verdad! Los Controllers no deben estar en su UI, colocar su TextEditController o cualquier controller que utilice dentro de su clase Controller.

5. ¿Necesita activar un evento para actualizar un widget tan pronto como este se dibuje? GetBuilder tiene la propiedad "initState", al igual que en un StatefulWidget, y puede llamar a eventos desde su Controller, directamente desde él, sin que se coloquen más eventos en su initState.

6. ¿Necesita activar una acción como cerrar streams, timers, etc.? GetBuilder también tiene la propiedad dispose, donde puede llamar a eventos tan pronto como se destruya ese widget.

7. Use streams solo si es necesario. Puede usar sus StreamControllers dentro de su Controller normalmente, y usar StreamBuilder también normalmente, pero recuerde, un stream consume una cantidad azonablemente de memoria, la programación reactiva es hermosa, pero no debe abusar de ella. 30 streams abiertos simultáneamente pueden ser peores que un changeNotifier (y changeNotifier es muy malo).

8. Actualice los widgets sin consumir ram por eso. GetX almacena solo el creator ID de GetBuilder y lo actualiza cuando es necesario. El consumo de memoria del almacenamiento del Get ID en la memoria es muy bajo, incluso para miles de GetBuilders. Cuando crea un nuevo GetBuilder, en realidad está compartiendo el estado de GetBuilder que tiene un creator ID. No se crea un nuevo estado para cada GetBuilder, lo que ahorra MUCHA RAM para aplicaciones grandes. Básicamente, su aplicación será completamente Stateless, y los pocos Widgets que serán Stateful (dentro de GetBuilder) tendrán un solo estado y por lo tanto actualizar uno los actualizará a todos. El estado es solo uno.

9. GetX es omnisciente y, en la mayoría de los casos, sabe exactamente el momento de sacar un Controller de la memoria. No debe preocuparse por eso, GetX conoce el mejor momento para hacerlo.

### Uso

```dart
// Create controller class and extends GETXController
class Controller extends GETXController {
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

**¡Listo!**

- Ya has aprendido a gestionar estados con GetX.

- Nota: es posible que desee una organización más grande y no usar la propiedad init. Para eso, puede crear una clase y extender la clase Bindings, dentro de ella mencionar los Controllers que necesita crear dentro de esa ruta. Pero los Controllers no se crearán en ese momento, por el contrario, esto será solo una declaración, por lo que, la primera vez que use un Controller, GetX sabrá dónde buscarlo. GetX seguirá siendo lazyLoad y se ocupará de eliminar los controllers cuando ya no sean necesarios. Vea el ejemplo pub.dev para ver cómo funciona.

Si navega por muchas rutas y necesita datos que estaban en su Controller utilizado previamente, solo necesita usar nuevamente GetBuilder (sin init):

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

Si necesita usar su Controller en muchos otros lugares y fuera de GetBuilder, simplemente cree un get en su Controller y obténgalo fácilmente. (o use `Get.find <Controller>()`)

```dart
class Controller extends GETXController {

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

Y luego puede acceder a su Controller directamente, de esa manera:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(), 
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

Cuando presiona FloatingActionButton, todos los widgets que escuchan la variable 'counter' se actualizarán automáticamente.

### Cómo maneja los Controllers

Digamos que tenemos esto:

`Class a => Class B (has controller X) => Class C (has controller X)`

En la clase A, el Controller aún no está en la memoria, porque aún no lo ha utilizado (GetX es lazyLoad). En la clase B usaste el Controller y entró en la memoria. En la clase C usó el mismo Controller que en la clase B, GetX compartirá el estado del Controller B con el Controller C, y el mismo Controller todavía está en la memoria. Si cierra la pantalla C y la pantalla B, GetX eliminará automáticamente Controller X de la memoria y liberará recursos, porque la clase A no está utilizando Controller. Si navega nuevamente hacia B, Controller X ingresará nuevamente a la memoria, si en lugar de ir a la clase C, regresa nuevamente a la clase A, GetX eliminará el Controller de la misma manera. Si la clase C no usó el Controller, y usted sacó la clase B de la memoria, ninguna clase estaría usando Controller X y de la misma manera se eliminaría. La única excepción que puede interferir con GetX es si elimina B de la ruta de forma inesperada e intenta utilizar el Controller en C. En este caso, se eliminó el creator ID del Controller que estaba en B y GetX se programó para eliminar de la memoria cada controller que no tiene creator ID. Si tiene la intención de hacer esto, agregue el indicador "autoRemove: false" al GetBuilder de clase B y use "adoptID = true;" en GetBuilder de la clase C.

### Ya no necesitará StatefulWidgets

Usar StatefulWidgets significa almacenar el estado de pantallas enteras innecesariamente, incluso si necesita reconstruir mínimamente un widget, lo incrustará en un Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, que será será también otro StatefulWidget.

La clase StatefulWidget es una clase más grande que StatelessWidget, que asignará más RAM, y esto puede no hacer una diferencia significativa entre una o dos clases, ¡pero sin duda lo hará cuando tenga 100 de ellas!
A menos que necesite usar un mixin, como TickerProviderStateMixin, será totalmente innecesario usar un StatefulWidget con GetX.

Puede llamar a todos los métodos de un StatefulWidget directamente desde un GetBuilder. Si necesita llamar al método initState() o dispose(), por ejemplo, puede llamarlos directamente;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Un enfoque mucho mejor que esto es utilizar el método onInit() y onClose() directamente desde su Controller.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- NOTA: Si desea iniciar un método en el momento en que se llama al Controller por primera vez, NO NECESITA usar constructores para esto, de hecho, usando un paquete orientado al rendimiento como GetX, esto sería casi una mala práctica, debido a que se desvía de la lógica en la que los controllers son creados o asignados (si crea una instancia de este controller, se llamará al constructor inmediatamente, completará un Controller antes de que se use, estará asignando memoria sin ser usado, esto definitivamente perjudica los principios de esta biblioteca). Los métodos onInit(); y onClose(); fueron creados para esto, se los llamará cuando se cree el controller, o se use por primera vez, dependiendo de si está utilizando GetX.lazyPut o no. Si desea, por ejemplo, hacer una llamada a su API para llenar datos, puede olvidarse del viejo método initState/dispose, simplemente inicie su llamada a la API en onInit y si necesita ejecutar algún comando como cerrar streams, use onClose() para eso.

### Por qué existe

El propósito de este paquete es precisamente brindarle una solución completa para la navegación de rutas, la gestión de dependencias y de estados, utilizando la menor cantidad de dependencias posibles, con un alto grado de desacoplamiento. GetX se acopla internamente a todas las API de Flutter de alto y bajo nivel, para garantizar que trabaje con el menor acoplamiento posible. Centralizamos todo en un solo paquete, para garantizar que no tenga ningún otro tipo de acoplamiento en su proyecto. De esa manera, puede poner solo widgets en su vista y dejar libre la parte de su equipo que trabaja con la lógica de negocios, sin depender de ningún elemento de la vista. Esto proporciona un entorno de trabajo mucho más limpio y ordenado, de modo tal que parte de su equipo trabajará solo con widgets, sin preocuparse por tener que enviar datos a su Controller, mientras la otra parte de su equipo trabajará solo con lógica de negocios, sin depender de ningún elemento de la UI.

Entonces, para simplificar esto:

No necesita llamar a métodos en initState y enviarlos por parámetro a su Controller, ni usar un constructor Controller. Para eso tiene el método onInit() que se llamará en el momento adecuado para que sus servicios sean iniciados. No necesita llamar a dispose(), dado que dispone del método onClose() que se llamará en el momento exacto en que su Controller ya no se necesita, y se eliminará de la memoria. De esa manera, deje las vistas solo para widgets, y abstenerse de incluír cualquier tipo de lógica de negocios.

No llame a un método dispose() dentro de GETXController, no hará nada, recuerde que Controller no es un widget, no debe "eliminarlo" y GetX lo eliminará de forma automática e inteligente de la memoria. Si utilizó algún stream en él y desea cerrarlo, simplemente insértelo en el método de cierre. 

Ejemplo:

```dart
class Controller extends GETXController {
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

Ciclo de vida del Controller:

- onInit() donde se crea.
- onClose() donde está cerrado para cualquier tipo de modificación en preparación para ser removido.
- deleted: no tiene acceso a esta API porque literalmente el Controller está eliminando de la memoria, sin dejar rastro (literal).

### Otras formas de usarlo

Puede usar la instancia de Controller directamente en el value de GetBuilder:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

También puede necesitar una instancia de su Controller fuera de su GetBuilder, y puede usar estos enfoques para lograr esto:

```dart
class Controller extends GETXController {
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

o

```dart
class Controller extends GETXController {
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

- Puede utilizar enfoques "no canónicos" para hacer esto. Si está utilizando algún otro gestor de dependencias, como get_it, modular, etc., y solo desea entregar la instancia de Controller, puede hacer esto:

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

### ID únicos
Si desea refinar el control de actualización de widgets con GetBuilder, puede asignarles ID únicos:

```dart
GetBuilder<Controller>( 
  id: 'text' 
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

Y actualízalo de esta forma:

```dart
update(['text']);
```

También puede imponer condiciones para la actualización:

```dart
update(['text'], counter < 10);
```

GetX hace esto automáticamente y solo reconstruye el widget que usa la variable exacta que se modificó, si cambia una variable a la misma que la anterior y eso no implica un cambio de estado, GetX no reconstruirá el widget para ahorrar memoria y ciclos de CPU (ej. si se muestra 3 en pantalla y la variable cambia a 3 nuevamente, en la mayoría de los gestores de estados, esto provocará una nueva reconstrucción, pero con GetX el widget solo se reconstruirá si efectivamente su estado ha sido modificado).

## Reactivo STATE_MANAGER

La programación reactiva puede alienar a muchas personas porque se dice que es complicada. GetX convierte la programación reactiva en algo tan simple que puede ser aprendido y utilizado por aquellos que comenzaron en ese mismo momento en Flutter. No, no necesitará crear StreamControllers. Tampoco necesitará crear un StreamBuilder para cada variable. No necesitará crear una clase para cada estado. No necesitará crear un get para un valor inicial. La programación reactiva con GetX es tan fácil como usar setState (¡o incluso más fácil!).

Imaginemos que tiene una variable "name" y desea que cada vez que la modifique, todos los widgets que la usan cambien automáticamente.

Ej. esta es tu variable "name":

```dart
var name = 'Jonatas Borges';
```

Para que sea observable, solo necesita agregar ".obs" al final:

```dart
var name = 'Jonatas Borges'.obs;
```

Esto raya en lo absurdo cuando se trata de practicidad. ¿Qué hicimos, debajo del capó? Creamos un stream de Strings, asignamos el valor inicial "Jonatas Borges", advertimos a todos los widgets que usan "Jonatas Borges" que ahora pertenecen a esta variable, y cuando se modifica, ellos también lo harán. Esta es la magia de GetX, que solo Dart nos permite hacer.

De acuerdo, pero como sabemos, un widget solo se puede modificar si está dentro de una función, porque las clases estáticas no tienen el poder de "auto-change". Tendrá que crear un StreamBuilder, suscribirse para escuchar esta variable y crear una "cascada" de StreamBuilder si desea cambiar multiples variables en el mismo scope, ¿verdad?
No, no necesitas un StreamBuilder, pero tienes razón sobre las clases estáticas.

Bueno, en la vista, generalmente tenemos mucho boilerplate cuando queremos cambiar un widget específico. Con GetX también puedes olvidarte de esto. ¿StreamBuilder? ¿initialValue? ¿builder? No, solo necesitas jugar con esta variable dentro de un widget Obx.

```dart
Obx(() => Text (controller.name));
```

¿Qué necesitas memorizar? "Obx(() =>" 

Simplemente está pasando ese widget a través de una función de flecha en un Obx. Obx es inteligente, y solo se cambiará si se modifica el valor de "name". Si el nombre es "John" y usted lo cambia "John", no tendrá ningún cambio en la pantalla, y Obx simplemente ignorará este cambio y no reconstruirá ningún widget, para ahorrar recursos. ¿No es increíble?

¿Qué pasa si tengo 5 variables observables dentro de un Obx? Se actualizará cuando se modifique alguna de ellos. Y si tengo 30 variables en una clase, cuando actualizo una, ¿actualizará todas las variables que están en esa clase? No, solo el widget específico que usa esa variable. Y si ametrallo mi variable observable mil millones de veces con el mismo valor, ¿me congelaré en la pantalla para reconstrucciones innecesarias? No, GetX solo actualiza la pantalla cuando la variable cambia en la pantalla, si la pantalla sigue siendo la misma, no reconstruirá nada.

### Ventajas

GetBuilder está dirigido precisamente al control de múltiples estados. Imagine que agregó 30 productos a un carrito, hace clic en eliminar uno, al mismo tiempo que se actualiza la lista, se actualiza el precio y la insignia en el carrito de compras a un número menor. Este tipo de enfoque hace que GetBuilder sea superior, porque agrupa estados y los cambia todos a la vez sin ninguna "lógica computacional" para eso. GetBuilder se creó con este tipo de situación en mente, ya que para un cambio de estado efímero, puede usar setState y no necesitaría un gestor de estado. Sin embargo, hay situaciones en las que solo desea que el widget donde una determinada variable ha sido modificada sea reconstruida, y esto es lo que GetX hace con un dominio nunca antes visto.

De esa manera, si desea un controlador individual, puede asignar un ID o usar GetX. Esto depende de usted, recordando que cuantos más widgets "individuales" tenga, más se destacará el rendimiento de GetX, mientras que el rendimiento de GetBuilder debería ser superior cuando haya un cambio múltiple de estado.

Puede usar ambos en cualquier situación, pero si desea ajustar su aplicación al máximo rendimiento posible, diría que: 
- si sus variables se cambian en diferentes momentos, use GetX, porque no hay competencia para ello cuando el tema es para reconstruir solo lo que es necesario, 
- si no necesita ID únicos, porque todas sus variables cambiarán cuando realice una acción, use GetBuilder, porque es un simple actualizador de estado en bloques, hecho en unas pocas líneas de código, para que haga exactamente lo que promete hacer: actualizar el estado en bloques. No hay forma de comparar RAM, CPU o cualquier otra cosa, desde un gestor de estado gigante a un simple StatefulWidget (como GetBuilder) que se actualiza cuando se llama a update(). Se hizo de una manera simple, para involucrar la menor lógica computacional, para cumplir con un solo propósito y consumiendo la menor cantidad de recursos posibles.

Si quieres un poderoso gestor de estado, puedes ir sin temor a GetX. No funciona con variables, pero fluye, todo lo que contiene son streams bajo el capó. Puede usar rxDart junto con él, porque todo es streams, puede escuchar el evento de cada "variable", porque todo en él es streams, es literalmente BLoC, más fácil que MobX, y sin generador de código o decoraciones.

Si quieres poder, GetX te ofrece el gestor de estado más avanzado que puedas tener.

GetX fue construido 100% basado en Streams, y le brinda toda la potencia de fuego que BLoC le brindó, con una instalación más fácil que al de MobX.

Sin decoraciones, puede convertir cualquier cosa en Observable con solo un ".obs".

Máximo rendimiento: además de tener un algoritmo inteligente para una reconstrucción mínima, GetX utiliza comparadores para asegurarse de que el estado realmente haya cambiado. Si experimenta algún error en su aplicación y envía un cambio de estado duplicado, GetX se asegurará de que su aplicación no se colapse.

El estado solo cambia si los valores son modificados. Esa es la principal diferencia entre GetX y usar Computed de MobX. Al unir dos observables, cuando se cambia uno, la audiencia de ese observable cambiará. Con GetX, si une dos variables (lo cual sería innecesario), GetX (similar a Observer) solo cambiará si implica un cambio de estado real.

### Uso

Tienes 3 formas de convertir una variable en observable.

El primero es usar Rx{Type}.

```dart
var count = RxString();
```

El segundo es usar Rx y escribirlo con `Rx<Type>`

```dart
var count = Rx<String>();
```

El tercer enfoque, más práctico, fácil e increíble, es simplemente agregar un .obs a su variable.

```dart
var count = 0.obs;

// or Rxint count = 0.obs;
// or Rx<int> count = 0.obs;
```

Como sabemos, Dart ahora se dirige hacia el null safety. Con eso es una buena idea, de ahora en adelante, que comience a usar sus variables siempre con un valor inicial.

Transformar una variable en observable con un valor inicial con GetX es el enfoque más simple y práctico que existe actualmente en Flutter. Literalmente agregará un ".obs" al final de su variable, y eso es todo, lo ha hecho observable, y su valor será el valor inicial, ¡esto es fantástico!

Puede agregar variables, y si desea escribir un widget que le permita obtener su controlador dentro, solo necesita usar el widget GetX en lugar de Obx

```dart
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
GetX<Controller>(
  builder: (value) {
    print("count 1 rebuild");
    return Text('${value.count1.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("count 2 rebuild");
    return Text('${_.count2.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("count 3 rebuild");
    return Text('${_.sum}');
  },
),
```

Si incrementamos el número de counter1, solo se reconstruyen el counter1 y el counter3, porque el counter1 ahora tiene un valor de 1 y 1 + 0 = 1, cambiando el valor de la suma.

Si cambiamos el counter2, solo se reconstruyen el counter2 y 3, porque el valor de 2 ha cambiado y el resultado de la suma ahora es 2.

Si agregamos el número 1 para counter1, que ya contiene 1, no se reconstruye ningún widget. Si agregamos un valor de 1 para el counter1 y un valor de 2 para el counter2, solo se reconstruirán 2 y 3, porque GetX además de cambiar solo lo que es necesario, evita la duplicación de eventos.

- NOTA: Por defecto, el primer evento permitirá la reconstrucción incluso si es igual. Creamos este comportamiento debido a variables dualistas, como Boolean.

Imaginemos que hiciste esto:

```dart
var isLogged = false.obs;
```

y luego verifica si un usuario ha iniciado sesión para activar un evento en "ever".

```dart
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

si hasToken fuera falso, no habría cambios en isLogged, por lo que nunca se llamaría. Para evitar este tipo de comportamiento, el primer cambio a un observable siempre desencadenará un evento, incluso si es el mismo.

Puede eliminar este comportamiento si lo desea, utilizando: 
`isLogged.firstRebuild = false;`

Además, GetX proporciona control de estado refinado. Puede condicionar un evento (como agregar un objeto a una lista), en una determinada condición: 

```dart
list.addIf(item < limit, item);
```

Sin decoraciones, sin un generador de código, sin complicaciones, GetX cambiará la forma en que administra sus estados en Flutter, y eso no es una promesa, ¡es una certeza!

¿Conoces el counter de Flutter? Su clase de controlador podría verse así:

```dart
class CountCtl extends GetxController {
  final count = 0.obs;
}
```
Con un simple: 

```dart
ctl.count.value++
```

Puede actualizar la variable de contador en su IU, independientemente de dónde esté almacenada.

### Donde se pueden usar .obs

Puedes transformar cualquier cosa en obs:

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}

class User {
  User({String name, int age});
  final rx = RxUser();

  String get name => rx.name.value;
  set name(String value) => rx.name.value = value;

  int get age => rx.age.value;
  set age(int value) => rx.age.value = value;
}
```

```dart
void main() {
  final user = User();
  print(user.name);
  user.age = 23;
  user.rx.age.listen((int age) => print(age));
  user.age = 24;
  user.age = 25;
}
___________
out:
Camila
23
24
25
```

### Nota sobre listas

Trabajar con listas usando GetX es lo mejor y lo más divertido del mundo. Son completamente observables como lo son los objetos dentro de él. De esa manera, si agrega un valor a una lista, reconstruirá automáticamente los widgets que lo usan.

Tampoco necesita usar ".value" con las listas, la increíble api de Dart nos permitió eliminar eso, los tipos primitivos desafortunados como String e int no se pueden extender, haciendo que el uso de .value sea obligatorio, pero eso no será un problema si trabajas con gets y setters para estos.

```dart
final list = List<User>().obs;
```

```dart
ListView.builder (
  itemCount: list.lenght
)
```

No tiene que trabajar con Sets si no lo desea. puede usar la api "assign" y "assignAll".

La API "assign" borrará su lista y agregará un solo objeto, con el que quiere comenzar allí.

La API "assignAll" borrará la lista existente y agregará cualquier objeto iterable que le inyecte.

### ¿Por qué tengo que usar .value?

Podríamos eliminar la obligación de usar 'value' para String e int con una simple decoración y generador de código, pero el propósito de esta biblioteca es, precisamente, no necesitar ninguna dependencia externa. Ofrecer un entorno listo para la programación, que incluya lo esencial (gestión de rutas, dependencias y estados), de una manera simple, ligera y de gran rendimiento sin necesidad de ningún otro paquete externo. Literalmente, agrega GetX a su pubspec y puede comenzar a programar. 

Todas las soluciones incluidas por defecto, desde gestión de rutas a gestión de estádo, apuntan a la facilidad, la productividad y el rendimiento. El peso total de esta biblioteca es menor que el de un solo gestor de estado, aunque es una solución completa, y eso es lo que debe comprender. 

Si le molesta el ".value" y, como además si se trata de un generador de código, MobX ya es una gran alternativa, puede simplemente usarlo junto con GetX. 

Para aquellos que desean agregar una sola dependencia en pubspec y comenzar a programar sin preocuparse de que la versión de un paquete sea incompatible con otra, o si el error de una actualización de estado proviene de gestor de estado o dependencia, o aún, no quieren preocuparse por la disponibilidad de controladores, ya sea literalmente "solo programación", GetX es simplemente perfecto.

Si no tiene ningún problema con el generador de código de MobX, o no tiene ningún problema con el boilerplate de BLoC, simplemente puede usar GetX para las rutas y olvidar que incluye un gestor de estado. GetX, SEM y RSM nacieron por necesidad, mi empresa tenía un proyecto con más de 90 controladores, y el generador de código tardó más de 30 minutos en completar sus tareas después de un Flutter Clean en una máquina razonablemente buena. Si su proyecto tiene 5, 10, 15 controladores, cualquier gestor de estado te vendrá bien. Si tiene un proyecto absurdamente grande y el generador de código es un problema para usted, se le ha otorgado esta solución.

Obviamente, si alguien quiere contribuir al proyecto y crear un generador de código, o algo similar, lo añadiré a este archivo como una alternativa, mi necesidad no es la necesidad de todos los desarrolladores, pero lo que ahora digo es que hay buenas soluciones que ya hacen eso, como MobX.

### Obx()

El Typing en GetX usando Bindings es innecesario. Puede usar el widget Obx (en lugar de GetX), que solo recibe la función anónima que crea un widget.

Obviamente, si no usa un tipo, necesitará tener una instancia de su controlador para usar las variables, o usar `Get.find <Controller>()` .value o Controller.to.value para recuperar el valor.

### Workers:

Los workers lo ayudarán, activando callbacks específicos cuando ocurra un evento.

```dart
/// Called every time the variable $_ is changed
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example. 
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

- ever: se llama cada vez que se cambia su variable. Eso es.

- once: se llama solo la primera vez que se ha cambiado la variable.

- debounce: es muy útil en las funciones de búsqueda, donde solo desea que se llame a la API cuando el usuario termina de escribir. Si el usuario escribe "JONNY", tendrá 5 búsquedas en las API, por la letra J, O, N, N e Y. Con GetX esto no sucede, porque tendrá un worker "debounce" que solo se activará al final de la escritura.

- interval: es diferente del debouce. Con debouce si el usuario realiza 1000 cambios en una variable dentro de 1 segundo, enviará solo el último después del timer estipulado (el valor predeterminado es 800 milisegundos). En cambio, el interval ignorará todas las acciones del usuario durante el período estipulado. Si envía eventos durante 1 minuto, 1000 por segundo, la función antirrebote solo le enviará el último, cuando el usuario deje de enviar eventos. Interval entregará eventos cada segundo, y si se establece en 3 segundos, entregará 20 eventos ese minuto. Esto se recomienda para evitar abusos, en funciones en las que el usuario puede hacer clic rápidamente en algo y obtener alguna ventaja (imagine que el usuario puede ganar monedas haciendo clic en algo, si hace clic 300 veces en el mismo minuto, tendría 300 monedas, usando el interval, puede establecer un time frame de 3 segundos, e incluso luego hacer clic 300 o mil veces, el máximo que obtendría en 1 minuto sería 20 monedas, haciendo clic 300 o 1 millón de veces). El debouce es adecuado para anti-DDos, para funciones como la búsqueda donde cada cambio en onChange provocaría una consulta en su API. Debounce esperará a que el usuario deje de escribir el nombre para realizar la solicitud. Si se usara en el escenario de monedas mencionado anteriormente, el usuario solo ganaría 1 moneda, ya que solo se ejecuta cuando el usuario "hace una pausa" durante el tiempo establecido.

## Mezclando los dos State Managers

Algunas personas abrieron una feature request, ya que querían usar solo un tipo de variable reactiva, y la otra mecánica, y necesitaban insertar un Obx en un GetBuilder para esto. Pensando en ello, se creó MixinBuilder. Permite cambios reactivos cambiando las variables ".obs" y actualizaciones mecánicas a través de update(). Sin embargo, de los 4 widgets, es el que consume más recursos, ya que además de tener una suscripción para recibir eventos de cambio de sus hijos, se suscribe al método update de su controlador.

Extender GetxController es importante, ya que tienen ciclos de vida y pueden "iniciar" y "finalizar" eventos en sus métodos onInit() y onClose(). Puede usar cualquier clase para esto, pero le recomiendo que use la clase GetxController para colocar sus variables, sean observables o no.

## GetBuilder vs GetX vs Obx vs MixinBuilder

En una década trabajando con programación pude aprender algunas lecciones valiosas.

Mi primer contacto con la programación reactiva fue tan "guau, esto es increíble" y, de hecho, la programación reactiva es increíble.

Sin embargo, no es adecuado para todas las situaciones. A menudo, todo lo que necesita es cambiar el estado de 2 o 3 widgets al mismo tiempo, o un cambio de estado efímero, en cuyo caso la programación reactiva no es mala, pero no es apropiada.

La programación reactiva tiene un mayor consumo de RAM que se puede compensar con el workflow individual, lo que garantizará que solo se reconstruya un widget y cuando sea necesario, pero crear una lista con 80 objetos, cada uno con varios streams no es una buena idea. Abra el dart inspector y compruebe cuánto consume un StreamBuilder, y comprenderá lo que estoy tratando de decirle.

Con eso en mente, creé el Simple State Manager. Es simple, y eso es exactamente lo que debe exigirle: actualizar el estado en bloques de una manera simple y de la manera más económica.

GetBuilder es muy económico en RAM, y es difícil que haya un enfoque más económico que él (al menos no puedo imaginar uno, si existe, háganoslo saber).

Sin embargo, GetBuilder sigue siendo un gestor de estado mecánico, debe llamar a update() al igual que necesitaría llamar a notifyListeners() con Provider.

Hay otras situaciones, en las que la programación reactiva es realmente interesante, y no trabajar con ella es lo mismo que reinventar la rueda. Con eso en mente, GetX fue creado para proporcionar todo lo más moderno y avanzado en un gestor de estado. Actualiza solo lo necesario y solo si es necesario, si tiene un error y envía 300 cambios de estado simultáneamente, GetX lo filtrará y actualizará la pantalla solo si el estado realmente fue modificado.

GetX es aún más económico que cualquier otro gestor de estado reactivo, pero consume un poco más de RAM que GetBuilder. Pensando en ello y con el objetivo de maximizar el consumo de recursos es que se creó Obx. A diferencia de GetX y GetBuilder, no podrá inicializar un controlador dentro de un Obx, es solo un Widget con una stream suscription que recibe eventos de cambio de sus children, eso es todo. Es más económico que GetX, pero pierde con GetBuilder, lo que era de esperar, ya que es reactivo, y GetBuilder tiene el enfoque más simplista que existe, de almacenar el código hash de un widget y su StateSetter. Con Obx no necesita escribir su tipo de controlador, y puede escuchar el cambio desde varios controladores diferentes, pero debe inicializarse antes, ya sea utilizando el enfoque de ejemplo al comienzo de este archivo o utilizando la clase Bindings.

# Gestión de dependencias

## Simple Instance Manager

- Nota: si está utilizando el gestor de estado de GetX, no tiene que preocuparse por esto, solo lea para obtener información, pero preste más atención a la API de bindings, que hará todo esto automáticamente por usted.

¿Ya estás utilizando GetX y quieres que tu proyecto sea lo más ágil posible? GetX tiene un gestor de dependencias simple y poderoso que le permite recuperar la misma clase que su BLoC o Controller con solo una líneas de código, sin contexto de Provider, sin inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

En lugar de crear una instancia de su clase dentro de la clase que está utilizando, la está creando dentro de la instancia GetX, que la hará disponible en toda su aplicación. Entonces puede usar su Controller (o BLoC) normalmente.

```dart
controller.fetchApi();
```

Imagine que ha navegado a través de numerosas rutas y necesita datos que quedaron en su controlador, necesitaría un gestor de estado combinado con Providere o Get_it, ¿correcto? No con GetX. Solo necesita pedirle a GetX que "encuentre" su controlador, no necesita dependencias adicionales:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Y luego podrá recuperar los datos de su controlador que se obtuvieron allí:

```dart
Text(controller.textFromApi);
```

¿Buscando lazy loading? Puede declarar todos sus controladores, y se llamará solo cuando alguien lo necesite. Puedes hacer esto con:

```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock will only be called when someone uses Get.find<Service> for the first time
```

Si desea registrar una instancia asincrónica, puede usar Get.putAsync.

```dart
Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 12345);
    return prefs;
});
```

uso:

```dart
  int count = Get.find<SharedPreferences>().getInt('counter');
  print(count);
  // out: 12345
}
```

Para eliminar una instancia de GetX:

```dart
Get.delete<Controller>();
```

## Bindings

Una de las grandes diferencias de este paquete, tal vez, es la posibilidad de una integración completa de las rutas, gestor de estado y dependencias.

Cuando se elimina una ruta del stack, todos los controladores, variables e instancias de objetos relacionados con ella se eliminan de la memoria. Si está utilizando stream o timers, se cerrarán automáticamente y no tendrá que preocuparse por nada de eso.

En la versión 2.10 GetX se implementó por completo la API de bindings.

Ahora ya no necesita usar el método init. Ni siquiera tiene que escribir sus controladores si no lo desea. Puede iniciar sus controladores y servicios en un lugar apropiado para eso.

La clase Binding es una clase que desacoplará la inyección de dependencia, al tiempo que vinculará rutas con el gestor de estado y el gestor de dependencias.

Esto permite conocer qué pantalla se muestra cuando se utiliza un controlador en particular y saber dónde y cómo descartarlo.

Además, la clase Binding le permitirá tener el control de configuración SmartManager. Puede configurar las dependencias que se organizarán al eliminar una ruta de la pila, o cuando el widget que lo usó se presenta, o ninguno de los dos. Tendrá una gestión inteligente de dependencias que funcione para usted, pero aun así, puede configurarla como desee.

### Cómo utilizar

- Crea una clase e implementa Binding

```dart
class HomeBinding implements Bindings{
```

Su IDE le pedirá automáticamente que anule el método de "dependencies", y solo necesita hacer clic en la lámpara, anular el método e insertar todas las clases que va a utilizar en esa ruta:

```dart
class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
    Get.lazyPut<Service>(()=> Api());
  }
}
```

Ahora solo necesita informar su ruta, que utilizará ese binding para establecer la conexión entre el gestor de rutas, las dependencias y los estados.

- Uso de rutas nombradas:

```dart
namedRoutes: {
  '/': GetRoute(Home(), binding: HomeBinding())
}
```

- Usando rutas normales:

```dart
Get.to(Home(), binding: HomeBinding());
```

Allí, ya no tiene que preocuparse por la administración de memoria de su aplicación, GetX lo hará por usted.

La clase Binding se llama cuando se llama una ruta, puede crear un initialBinding en su GetMaterialApp para insertar todas las dependencias que se crearán.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

## SmartManagement

Siempre prefiera usar SmartManagement estándar (full), no necesita configurar nada para eso, GetX ya se lo proporciona de forma predeterminada. Seguramente eliminará todos los controladores en desuso de la memoria, ya que su control refinado elimina la dependencia, incluso si se produce un error y un widget que lo utiliza no se elimina correctamente.

El modo "full" también es lo suficientemente seguro como para usarlo con StatelessWidget, ya que tiene numerosos callbacks de seguridad que evitarán que un controlador permanezca en la memoria si ningún widget lo está utilizando, y los disposers no son importante aquí. Sin embargo, si le molesta el comportamiento predeterminado, o simplemente no quiere que suceda, GetX ofrece otras opciones más indulgentes para la administración inteligente de la memoria, como SmartManagement.onlyBuilders, que dependerá de la eliminación efectiva de los widgets que estén usando el controller para eliminarlo, y puede evitar que se implemente un controlador usando "autoRemove: false" en su GetBuilder/GetX.

Con esta opción, solo se eliminarán los controladores iniciados en "init:" o cargados en un enlace con "Get.lazyPut"; si usa Get.put o cualquier otro enfoque, SmartManagement no tendrá permisos para excluir esta dependencia.

Con el comportamiento predeterminado, incluso los widgets instanciados con "Get.put" se eliminarán, a diferencia de SmartManagement.onlyBuilders.

SmartManagement.keepFactory es como SmartManagement.full, con una diferencia. SmartManagement.full purga los factories de las premises, de modo que Get.lazyPut() solo podrá llamarse una vez y su factory y sus referencias se autodestruirán. SmartManagement.keepFactory eliminará sus dependencias cuando sea necesario, sin embargo, mantendrá la "forma" de estas, para hacer una igual si necesita una instancia de eso nuevamente.

En lugar de usar SmartManagement.keepFactory, puede usar Bindings.

Bindings crea factories transitorios, que se crean en el momento en que hace clic para ir a otra pantalla, y se destruirán tan pronto como ocurra la animación de cambio de pantalla. Es tan poco tiempo que el analizador ni siquiera podrá registrarlo. Cuando navegue de nuevo a esta pantalla, se llamará a una nueva factory temporal, por lo que es preferible usar SmartManagement.keepFactory, pero si no desea crear enlaces o desea mantener todas sus dependencias en el mismo enlace, sin duda te ayudará. Las factories ocupan poca memoria, no tienen instancias, sino una función con la "forma" de esa clase que desea. Esto es muy poco, pero dado que el propósito de esta lib es obtener el máximo rendimiento posible utilizando los recursos mínimos, GetX elimina incluso las factories por defecto. Use el que sea más conveniente para usted.

- NOTA: NO USE SmartManagement.keepFactory si está utilizando bindings múltiples. Fue diseñado para usarse sin bindings, o con uno único vinculado en el binding inicial de GetMaterialApp.

- NOTA2: El uso de bindings es completamente opcional, puede usar Get.put() y Get.find() en clases que usan un controlador dado sin ningún problema.

Sin embargo, si trabaja con Servicios o cualquier otra abstracción, le recomiendo usar binding para una organización más grande.

# Utils

## Cambiar de tema

No utilice ningún widget de nivel superior que GetMaterialApp para actualizarlo. Esto puede activar claves duplicadas. Mucha gente está acostumbrada al enfoque prehistórico de crear un widget "ThemeProvider" solo para cambiar el tema de su aplicación, y esto definitivamente NO es necesario con GetX.

Puede crear su tema personalizado y simplemente agregarlo dentro de Get.changeTheme sin ningun boilerplate para eso:

```dart
Get.changeTheme(ThemeData.light());
```

Si desea crear algo así como un botón que cambia el tema con onTap, puede combinar dos APIs GetX para eso, la API que verifica si se está utilizando el tema oscuro y la API de cambio de tema, simplemente puede poner esto dentro de un onPressed:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Cuando el modo oscuro está activado, cambiará al tema claro, y cuando el tema claro esté activado, cambiará a oscuro.

Si quieres saber en profundidad cómo cambiar el tema, puedes seguir este tutorial en Medium que incluso enseña la persistencia del tema usando GetX:

- [Temas dinámicos en 3 líneas usando GetX](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial de [Rod Brown](https://github.com/RodBr).

## Otras API avanzadas y configuraciones manuales

GetMaterialApp configura todo para usted, pero si desea configurar GetX manualmente utilizando APIs avanzadas.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

También podrá usar su propio Middleware dentro de GetObserver, esto no influirá en nada.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver(MiddleWare.observer)], // Here
);
```

```dart
Get.arguments // give the current args from currentScreen

Get.previousArguments // give arguments of previous route

Get.previousRoute // give name of previous route

Get.rawRoute // give the raw route to access for example, rawRoute.isFirst()

Get.routing // give access to Rounting API from GetObserver

Get.isSnackbarOpen // check if snackbar is open

Get.isDialogOpen // check if dialog is open

Get.isBottomSheetOpen // check if bottomsheet is open

Get.removeRoute() // remove one route.

Get.until() // back repeatedly until the predicate returns true.

Get.offUntil() // go to next route and remove all the previous routes until the predicate returns true.

Get.offNamedUntil() // go to next named route and remove all the previous routes until the predicate returns true.

GetPlatform.isAndroid/isIOS/isWeb... //(This method is completely compatible with FlutterWeb, unlike the framework. "Platform.isAndroid")

Get.height / Get.width // Equivalent to the method: MediaQuery.of(context).size.height, but they are immutable. If you need a changeable height/width (like browser windows that can be scaled) you will need to use context.height and context.width

Get.context // Gives the context of the screen in the foreground anywhere in your code.

Get.contextOverlay // Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.

```

### Configuraciones globales opcionales

Puede crear configuraciones globales para GetX. Simplemente agregue Get.config a su código antes de insertar cualquier ruta o hágalo directamente en su GetMaterialApp

```dart
GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  opaqueRoute: Get.isOpaqueRouteDefault,
  popGesture: Get.isPopGestureEnable,
  transitionDuration: Get.defaultDurationTransition,
  defaultGlobalState: Get.defaultGlobalState,
);

Get.config(
  enableLog = true,
  defaultPopGesture = true,
  defaultTransition = Transitions.cupertino
)
```

# Rompiendo cambios desde 2.0

1- Rx types:

Antes: StringX ahora: RxString

Antes: IntX ahora: RxInt

Antes: MapX ahora: RxMax

Antes: ListX ahora: RxList

Antes: NumX ahora: RxNum

Antes: RxDouble ahora: RxDouble

RxController y GetBuilder ahora se han fusionado, ya no necesita memorizar qué controlador desea usar, solo use GETXController, funcionará para gestión de estádo simple y también para reactivo.

2- Rutas Nombradas

Antes:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Ahora:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page:()=> Home()),
  ]
)
```

¿Por qué este cambio?

A menudo, puede ser necesario decidir qué página se mostrará desde un parámetro o un token de inicio de sesión, el enfoque anterior era inflexible, ya que no permitía esto.

Insertar la página en una función ha reducido significativamente el consumo de RAM, ya que las rutas no se asignarán en la memoria desde que se inició la aplicación, y también permitió hacer este tipo de enfoque:

```dart
GetStorage box = GetStorage();

GetMaterialApp(
  getPages: [
    GetPage(name: '/', page:(){  
      return box.hasData('token') ? Home() : Login();
    })
  ]
)
```

Esta librería siempre se actualizará e implementará nuevas características. Siéntase libre de ofrecer PRs y contribuir a ellas.
