![](get.png)

*Idiomas: Español (este archivo), [Inglés](README.md), [Portugués de Brasil](README.pt-br.md), [Polaco](README.pl.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
![](getx.png)

<h3>We are sorry for the inconsistency in the translation. The GetX package is updated quite often and translations to docs may not come as fast. So in order for this documentation still has all content, i'll leave here all new untranslated texts (I consider is better to have the english docs then to not have at all), so if anyone wants to translate, it would be very helpful 😁</h3>

- [Communication and support channels:](#communication-and-support-channels)
- [Sobre GetX](#sobre-getx)
- [Como contribuir](#como-contribuir)
- [Installing](#installing)
- [Proyeto Counter no GetX](#proyeto-counter-no-getx)
- [Los tres pilares](#los-tres-pilares)
  - [Gestión del Estado](#gestión-del-estado)
    - [Reactivo STATE_MANAGER](#reactivo-state_manager)
    - [Más detalles sobre la gestión del estado.](#más-detalles-sobre-la-gestión-del-estado)
    - [Video explanation about state management](#video-explanation-about-state-management)
  - [Gestión de Rutas](#gestión-de-rutas)
    - [Más detalles sobre la gestión de rutas.](#más-detalles-sobre-la-gestión-de-rutas)
    - [Video Explanation](#video-explanation)
  - [Gestión de dependencias](#gestión-de-dependencias)
    - [Más detalles sobre la gestión de dependencias.](#más-detalles-sobre-la-gestión-de-dependencias)
- [Utils](#utils)
  - [Cambiar de tema](#cambiar-de-tema)
  - [Otras API avanzadas y configuraciones manuales](#otras-api-avanzadas-y-configuraciones-manuales)
    - [Configuraciones globales opcionales](#configuraciones-globales-opcionales)
  - [Video explanation of Other GetX Features](#video-explanation-of-other-getx-features)
- [Rompiendo cambios desde 2.0](#rompiendo-cambios-desde-20)
- [¿Por qué Getx?](#por-qué-getx)

# Communication and support channels:

[**Slack (English)**](https://communityinviter.com/apps/getxworkspace/getx)

[**Discord (English and Portuguese)**](https://discord.com/invite/9Y3wK9)

[**Telegram (Portuguese)**](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)

# Sobre GetX

- GetX es una solución extra ligera y potente para Flutter. Combina gestión de estádo de alto rendimiento, inyección de dependencia inteligente y gestión de rutas, de forma rápida y práctica.  

- GetX no es para todos, se enfoca en el consumo mínimo de recursos (rendimiento) ([Mira los puntos de referencia](https://github.com/jonataslaw/benchmarks)), usando una sintaxis fácil y agradable (productividad), que permite el desacoplamiento total de la vista y la lógica de negocio (organización).

- GetX permite ahorrar horas de desarrollo, extraer el máximo rendimiento de una aplicación, siendo tatno fácil de implementar para principiantes como precisa para expertos. Navegue sin contexto, abra dialogs, snackbars y bottomsheets desde cualquier parte de su código, gestione estados e inyecte dependencias de una manera fácil y práctica. GetX es seguro, estable, actualizado y ofrece una amplia gama de APIs que no están presentes en el framework por defecto.

- Tiene una multitud de funciones que le permiten comenzar a programar sin preocuparse por nada. Cada una de estas funciones se encuentra en contenedores separados y solo se inicia después de su uso. Si solo usa State Management, solo State Management se compilará. Si solo usa rutas, no se compilará nada de gestión de estado. Puede compilar el repositorio de referencia, y verá que usando solo la gestión de estado de GetX, la aplicación compilada se ha vuelto más pequeña que todas las demás aplicaciones de otros paquetes que solo tienen la gestión de estado, porque nada de lo que no se use se compilará en su código, y cada solución GetX fue diseñada para ser extra liviana. El mérito aquí también proviene del AOT de Flutter, que es increíble y logra eliminar los recursos no utilizados como ningún otro framework lo hace.

**GetX hace que su desarrollo sea productivo, pero ¿quiere hacerlo aún más productivo? [Agregue la extensión a su VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)**

# Como contribuir

*¿Quieres contribuir al proyecto? Estaremos orgullosos de destacarte como uno de nuestros colaboradores. Aquí hay algunos puntos en los que puede contribuir y hacer que GetX (y Flutter) sea aún mejor.*

- Ayudando a traducir el archivo Léame a otros idiomas.

- Agregar documentación al archivo Léame (ni siquiera la mitad de las funciones de GetX han sido documentadas todavía).

- Escriba artículos o haga videos que enseñen cómo usar GetX (se insertarán en el archivo Léame y en el futuro en nuestro Wiki).

- Ofreciendo PRs para código/pruebas.

- Incluyendo nuevas funciones.

# Installing

Add Get to your pubspec.yaml file:

```yaml
dependencies:
  get:
```

Import get in files that it will be used:

```dart
import 'package:get/get.dart';
```

# Proyeto Counter no GetX

Vea una explicación más detallada de la administración del estado [aquí](./docs/es_ES/state_management.md). Allí verá más ejemplos y también la diferencia entre el Gestión del Estado simple y el Gestión del Estado reactivo

El proyecto "contador" creado por defecto en un nuevo proyecto en Flutter tiene más de 100 líneas (con comentarios). Para mostrar el poder de GetX, demostraré cómo hacer un "contador" cambiando el estado con cada clic, cambiando de página y compartiendo el estado entre pantallas, todo de manera organizada, separando la vista de la lógica de negocio, SOLO 26 LÍNEAS DE CÓDIGO INCLUIDOS COMENTARIOS.

- Paso 1:  
  Agregue "Get" antes de su materialApp, convirtiéndolo en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

**Nota**: esto no modifica el MaterialApp del Flutter, GetMaterialApp no es una MaterialApp modificado, es solo un Widget preconfigurado, que tiene como child un MaterialApp por defecto. Puede configurar esto manualmente, pero definitivamente no es necesario. GetMaterialApp creará rutas, las inyectará, inyectará traducciones, inyectará todo lo que necesita para la navegación de rutas. Si usa Get solo para la gestión de estado o dependencias, no es necesario usar GetMaterialApp. GetMaterialApp es necesario para rutas, snackbars, internacionalización, bottomSheets, diálogos y APIs de alto nivel relacionadas con rutas y ausencia de contexto.

**Note²:** This step in only necessary if you gonna use route management (`Get.to()`, `Get.back()` and so on). If you not gonna use it then it is not necessary to do step 1

- Paso 2:  
Cree su clase con la lógica de negocio colocando todas las variables, métodos y controladores dentro de ella. Puede hacer que cualquier variable sea observable usando un simple ".obs".

```dart
class Controller extends GetxController {
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
}

```

Resultado:

![](counter-app-gif.gif)

Este es un proyecto simple pero ya deja en claro cuán poderoso es GetX. A medida que su proyecto crezca, esta diferencia se volverá más significativa. GetX fue diseñado para trabajar con equipos, pero también simplifica el trabajo de un desarrollador individual. Mejore sus plazos, entregue todo a tiempo, sin perder rendimiento. GetX no es para todos, pero si te identificaste con esa frase, ¡GET es para ti!

# Los tres pilares

## Gestión del Estado

Actualmente hay varios State Managers para Flutter. Sin embargo, con la mayoría de ellos implica utilizar ChangeNotifier para actualizar widgets y este es un enfoque malo y muy malo para el rendimiento de aplicaciones medianas o grandes. Puede verificar en la documentación oficial de Flutter que [ChangeNotifier debe usarse con 1 o un máximo de 2 listeners](https://api.Flutter.dev/Flutter/foundation/ChangeNotifier-class.html), por lo que es prácticamente inutilizable para cualquier aplicación mediana o grande.

GetX no es mejor ni peor que cualquier otro gestor de estado, pero debe analizar estos puntos, así como los puntos que se mencionan a continuación, para elegir entre usar GetX en forma pura (vanilla) o usarlo junto con otro gestor de estado.

Definitivamente, GetX no es enemigo de ningún otro gestor de estado, porque GetX es más bien un microframework, no solo un gestor de estado, y se puede usar solo o en combinación con ellos.

### Reactivo STATE_MANAGER

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

¿StreamBuilder? ¿initialValue? ¿builder? No, solo necesitas jugar con esta variable dentro de un widget Obx.

```dart
Obx(() => Text (controller.name));
```

### Más detalles sobre la gestión del estado.

**Vea una explicación más detallada de la administración del estado [aquí](./docs/es_ES/state_management.md). Allí verá más ejemplos y también la diferencia entre el Gestión del Estado simple y el Gestión del Estado reactivo**

### Video explanation about state management


Amateur Coder did an awesome video about state management! Link: [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw)

You will get a good idea of GetX power.

## Gestión de Rutas

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

### Más detalles sobre la gestión de rutas.

**Vea una explicación más detallada de la Gestión de Rutas [aquí](./docs/es_ES/route_management.md).**

### Video Explanation

Amateur Coder did an excellent video that cover route management with Get! here is the link: [Complete Getx Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI)

## Gestión de dependencias

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

### Más detalles sobre la gestión de dependencias.

**Vea una explicación más detallada de la Gestión de dependencias [aquí](./docs/es_ES/dependency_management.md).**

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
// give the current args from currentScreen
Get.arguments

// give arguments of previous route
Get.previousArguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Rounting API from GetObserver
Get.routing

// check if snackbar is open
Get.isSnackbarOpen

// check if dialog is open
Get.isDialogOpen

// check if bottomsheet is open
Get.isBottomSheetOpen

// remove one route.
Get.removeRoute()

// back repeatedly until the predicate returns true.
Get.until()

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil()

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil()

//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isWeb

// Equivalent to the method: MediaQuery.of(context).size.height, but they are immutable.
Get.height
Get.width

// Gives the context of the screen in the foreground anywhere in your code.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like browser windows that can be scaled) you will need to use context.
context.width
context.height



// gives you the power to define half the screen now, a third of it and so on.
//Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// similar to MediaQuery.of(context).orientation;
context.orientation()

/// check if device is on landscape mode
context.isLandscape()

/// check if device is on portrait mode
context.isPortrait()

/// similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// get the shortestSide from screen
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// True if the shortestSide is smaller than 600p
context.isPhone()

/// True if the shortestSide is largest than 600p
context.isSmallTablet()

/// True if the shortestSide is largest than 720p
context.isLargeTablet()

/// True if the current device is Tablet
context.isTablet()
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

## Video explanation of Other GetX Features


Amateur Coder did an awesome video about utils, storage, bindings and other features! Link: [GetX Other Features](https://youtu.be/ttQtlX_Q0eU)

# Rompiendo cambios desde 2.0

1- Rx types:

Antes: StringX ahora: RxString

Antes: IntX ahora: RxInt

Antes: MapX ahora: RxMax

Antes: ListX ahora: RxList

Antes: NumX ahora: RxNum

Antes: RxDouble ahora: RxDouble

RxController y GetBuilder ahora se han fusionado, ya no necesita memorizar qué controlador desea usar, solo use GetXController, funcionará para gestión de estádo simple y también para reactivo.

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

# ¿Por qué Getx?

1- Después de una actualización de Flutter, muchos paquetes suelen romperse. A veces se producen errores de compilación, errores de los que aún no hay respuestas y el desarrollador necesita saber el origen del error, poder rastrearlo, y solo entonces intentar abrir un issue en el repositorio correspondiente, para finalmente ver su problema resuelto. Getx centraliza los principales recursos para el desarrollo (gestión de estado, dependencia y rutas), lo que le permite agregar un único paquete a su pubspec y comenzar a trabajar. Después de una actualización de Flutter, lo único que debe hacer es actualizar la dependencia Get y ponerse a trabajar. Get también resuelve problemas de compatibilidad. ¿Cuántas veces una versión de un paquete no es compatible con la versión de otro, porque una usa una dependencia en una versión y la otra en otra? Tampoco es una preocupación usando Get, ya que todo estará en el mismo paquete y será totalmente compatible.

2- Flutter es fácil, Flutter es increíble, pero todavía tiene algo repetitivo que puede ser no deseado para la mayoría de los desarrolladores, como `Navigator.of(context).push (context, bulder [...]`. Get simplifica el desarrollo. En lugar de escribir 8 líneas de código para simplemente llamar a una ruta, simplemente puede hacerlo: `Get.to(Home())` y listo, irá a la página siguiente. Algo doloroso de hacer con Flutter actualmente, mientras que con GetX es estúpidamente simple. Gestionar estados en Flutter y dependencias también es algo que genera mucho debate, ya que hay cientos de patrones en el pub. Pero no hay nada tan fácil como agregar un ".obs" al final de su variable, y colocar su widget dentro de un Obx, y eso es todo, todas las actualizaciones de esa variable se actualizarán automáticamente en la pantalla.

3- Facilidad sin preocuparse por el rendimiento. El rendimiento de Flutter ya es sorprendente, pero imagine que usa un gestor de estado y un localizador para distribuir sus clases de bloc/stores/controllers/ etc. Tendrá que llamar manualmente a la exclusión de esa dependencia cuando no la necesite. Pero, ¿alguna vez pensó en simplemente usar el controlador, y cuando ya no sea necesario, simplemente se elimine de la memoria? Eso es lo que hace GetX. Con SmartManagement, todo lo que no se está utilizando se elimina de la memoria, y no debería tener que preocuparse por nada más que la programación. Se le garantiza el consumo mínimo de recursos, sin siquiera haber creado una lógica para esto.

4- Desacoplamiento real. Es posible que haya escuchado la idea de "separar la vista de la lógica de negocio". Esta no es una peculiaridad de BLoC,MVC,MVVM, cualquier otro estándar en el mercado tiene este concepto. Sin embargo, a menudo se puede mitigar en Flutter debido al uso del contexto.
Si necesita contexto para encontrar un InheritedWidget, lo necesita en la vista o pasado por parámetro. En particular, encuentro esta solución muy fea, y para trabajar en equipo siempre tendremos una dependencia de la lógica de negocios de la vista. Getx no es ortodoxo con el enfoque estándar, y aunque no prohíbe completamente el uso de StatefulWidgets, InitState, etc., siempre tiene un enfoque similar que puede ser más limpio. Los controladores tienen ciclos de vida, y cuando necesita hacer una solicitud API REST, por ejemplo, no depende de nada en la vista. Puede usar onInit para iniciar la llamada http, y cuando lleguen los datos, se rellenarán las variables. Como GetX es completamente reactivo (realmente, y funciona bajo streams), una vez que se llenan los elementos, todos los widgets que usan esa variable se actualizarán automáticamente en la vista. Esto permite que las personas con experiencia en IU trabajen solo con widgets y no tengan que enviar nada a la lógica de negocios que no sean eventos de usuario (como hacer clic en un botón), mientras que las personas que trabajan con lógica de negocios podrán crearla y probarla por separado.

Esta librería siempre se actualizará e implementará nuevas características. Siéntase libre de ofrecer PRs y contribuir a ellas.
