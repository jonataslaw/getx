![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

*Idiomas: Español (este archivo), [Indonesio](README.id-ID.md), [Urdu](README.ur-PK.md), [Chino](README.zh-cn.md), [Inglés](README.md), [Portugués de Brasil](README.pt-br.md), [Ruso](README.ru.md), [Polaco](README.pl.md), [Coreano](README.ko-kr.md), [Francés](README-fr.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)
[![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)

<h3>Lamentamos la inconsistencia en la traducción. El paquete GetX se actualiza con bastante frecuencia y es posible que las traducciones a documentos no sean tan rápidas. Entonces, para que esta documentación aún tenga todo el contenido, dejaré aquí todos los textos nuevos sin traducir (considero que es mejor tener los documentos en inglés que no tenerlos), por lo que si alguien quiere traducir, sería de gran ayuda 😁</h3>

- [Sobre GetX](#sobre-getx)
- [Instalación](#instalación)
- [Proyecto contador con GetX](#proyecto-contador-con-getx)
- [Los tres pilares](#los-tres-pilares)
  - [Gestión del Estado](#gestión-del-estado)
    - [Reactivo STATE_MANAGER](#reactivo-state_manager)
    - [Más detalles sobre la gestión del estado.](#más-detalles-sobre-la-gestión-del-estado)
    - [Explicación en video sobre state management](#explicación-en-video-sobre-state-management)
  - [Gestión de Rutas](#gestión-de-rutas)
    - [Más detalles sobre la gestión de rutas.](#más-detalles-sobre-la-gestión-de-rutas)
    - [Explicación del video](#explicación-del-video)
  - [Gestión de dependencias](#gestión-de-dependencias)
    - [Más detalles sobre la gestión de dependencias.](#más-detalles-sobre-la-gestión-de-dependencias)
- [Utilidades](#utilidades)
  - [Cambiar de tema](#cambiar-de-tema)
  - [Otras API avanzadas y configuraciones manuales](#otras-api-avanzadas-y-configuraciones-manuales)
    - [Configuraciones globales opcionales](#configuraciones-globales-opcionales)
  - [Video explanation of Other GetX Features](#video-explanation-of-other-getx-features)
- [Cambios importantes desde 2.0](#cambios-importantes-desde-20)
- [¿Por qué Getx?](#por-qué-getx)
- [Comunidad](#comunidad)
  - [Canales de la comunidad](#canales-de-la-comunidad)
  - [Cómo contribuir](#cómo-contribuir)
  - [Artículos y vídeos](#artículos-y-vídeos)

# Sobre GetX

- GetX es una solución extra ligera y potente para Flutter. Combina gestión de estádo de alto rendimiento, inyección de dependencia inteligente y gestión de rutas de forma rápida y práctica.

- GetX tiene 3 principios básicos, esto significa que esta es la prioridad para todos los recursos de la biblioteca.
  - **RENDIMIENTO:** GetX se centra en el rendimiento y el consumo mínimo de recursos. Los puntos de referencia casi siempre no son importantes en el mundo real, pero si lo desea, aquí hay un indicador de consumo.([benchmarks](https://github.com/jonataslaw/benchmarks)), donde GetX lo hace mejor que otros enfoques de gestión estatal, por ejemplo. La diferencia no es grande, pero muestra nuestra preocupación por no desperdiciar sus recursos.
  - **PRODUCTIVIDAD:** GetX utiliza una sintaxis fácil y agradable.
  - **ORGANIZACIÓN:** GetX permite el desacoplamiento total de la vista de la lógica de negocio.

* GetX ahorrará horas de desarrollo y extraerá el máximo rendimiento que su aplicación puede ofrecer, siendo fácil para los principiantes y precisa para los expertos. Navega sin contexto, abre diálogos, snackbars o bottomsheets desde cualquier lugar de tu código, gestiona estados e inyecta dependencias de forma fácil y práctica. Get es seguro, estable, actualizado y ofrece una amplia gama de API que no están presentes en el marco predeterminado.

- GetX no es bloated. Tiene una multitud de características que le permiten comenzar a programar sin preocuparse por nada, pero cada una de estas características se encuentran en contenedores separados y solo se inician después de su uso. Si solo usa State Management, solo se compilará State Management. Si solo usa rutas, no se compilará nada de la administración estatal. Puede compilar el repositorio de referencia y verá que al usar solo la administración de estado de Get, la aplicación compilada con Get se ha vuelto más pequeña que todas las demás aplicaciones que solo tienen la administración de estado de otros paquetes, porque nada que no se use se compilará en su código, y cada solución GetX fue diseñada para ser muy liviana. El mérito aquí también proviene del movimiento del árbol de Flutter, que es increíble y logra eliminar los recursos no utilizados como ningún otro marco lo hace.

**GetX hace que su desarrollo sea productivo, pero ¿quiere hacerlo aún más productivo? [Agregue la extensión a su VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)**

# Instalación

Añada la librería Get en tu archivo pubspec.yaml:

```yaml
dependencies:
  get:
```

Importe Get en los archivos en los que se utilizará:

```dart
import 'package:get/get.dart';
```

# Proyecto Contador con GetX

Vea una explicación más detallada de la administración del estado [aquí](./documentation/es_ES/state_management.md). Allí verá más ejemplos y también la diferencia entre el Gestión del Estado simple y el Gestión del Estado reactivo

El proyecto "contador" creado por defecto en un nuevo proyecto en Flutter tiene más de 100 líneas (con comentarios). Para mostrar el poder de GetX, demostraré cómo hacer un "contador" cambiando el estado con cada clic, cambiando de página y compartiendo el estado entre pantallas, todo de manera organizada, separando la vista de la lógica de negocio, SOLO 26 LÍNEAS DE CÓDIGO INCLUIDOS COMENTARIOS.

- Paso 1: Agregue "Get" antes de su materialApp, convirtiéndolo en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

**Nota**: esto no modifica el MaterialApp del Flutter, GetMaterialApp no es una MaterialApp modificado, es solo un Widget preconfigurado que tiene como child un MaterialApp por defecto. Puede configurar esto manualmente, pero definitivamente no es necesario. GetMaterialApp creará rutas, las inyectará, inyectará traducciones, inyectará todo lo que necesita para la navegación de rutas. Si usa Get solo para la gestión de estado o dependencias, no es necesario usar GetMaterialApp. GetMaterialApp es necesario para rutas, snackbars, internacionalización, bottomSheets, diálogos y APIs de alto nivel relacionadas con rutas y ausencia de contexto.

**Nota²:** Este paso solo es necesario si va a usar route management (`Get.to()`, `Get.back()` y así). Si no lo va a usar, no es necesario que realice el paso 1

- Paso 2: Cree su clase con la lógica de negocio colocando todas las variables, métodos y controladores dentro de ella. Puede hacer que cualquier variable sea observable usando un simple ".obs".

```dart
class Controller extends GetxController {
  var count = 0.obs;
  increment() => count.value++;
}
```

- Paso 3: Cree su vista, use StatelessWidget y ahorre algo de RAM, con GetX ya no necesitará usar StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Cree una instancia de su clase usando Get.put() para que esté disponible para todas las rutas "secundarias" allí.
    final Controller c = Get.put(Controller());
    
    return Scaffold(
      // Utilice Obx(()=> para actualizar Text() siempre que se cambie el recuento.
      appBar: AppBar(title: Obx(() => Text("Clicks: " + c.count.string))),

      // Reemplace el Navigator.push de 8 líneas por un simple Get.to(). No necesitas contexto
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // Puede pedirle a Get que busque un controlador que está siendo utilizado por otra página y le redirija a él.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Acceder a la variable de recuento actualizada
     return Scaffold(body: Center(child: Text(c.count.string)));
  }
}

```

Resultado:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

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

**Vea una explicación más detallada de la administración del estado [aquí](./documentation/es_ES/state_management.md). Allí verá más ejemplos y también la diferencia entre el Gestión del Estado simple y el Gestión del Estado reactivo**

### Explicación en video sobre state management

Darwin Morocho hizo una increíble serie de videos sobre state management! Link: [Complete GetX State Management](https://www.youtube.com/watch?v=PTjj0DFK8BA&list=PLV0nOzdUS5XtParoZLgKoVwNSK9zROwuO)

Obtendrá una buena idea de la potencia de GetX.

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

**Vea una explicación más detallada de la Gestión de Rutas [aquí](./documentation/es_ES/route_management.md).**

### Explicación del video

Amateur Coder hizo un excelente video que cubre route management con Get! aquí esta el link: [Complete Getx Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI)

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

Imagine que ha navegado a través de numerosas rutas y necesita datos que quedaron en su controlador, necesitaría un gestor de estado combinado con Provider o Get_it, ¿correcto? No con GetX. Solo necesita pedirle a GetX que "encuentre" su controlador, no necesita dependencias adicionales:

```dart
Controller controller = Get.find();
//Sí, parece que es magia, Get encontrará su controlador y se lo entregará. Puede tener 1 millón de controladores instanciados, Get siempre le dará el controlador correcto.
```

Y luego podrá recuperar los datos de su controlador que se obtuvieron allí:

```dart
Text(controller.textFromApi);
```

¿Buscando lazy loading? Puede declarar todos sus controladores, y se llamará solo cuando alguien lo necesite. Puedes hacer esto con:

```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock solo se llamará cuando alguien use Get.find<Service> por primera vez
```

### Más detalles sobre la gestión de dependencias.

**Vea una explicación más detallada de la Gestión de dependencias [aquí](./documentation/es_ES/dependency_management.md).**

# Utilidades

## Cambiar de tema

No utilice ningún widget de nivel superior que GetMaterialApp para actualizarlo. Esto puede activar claves duplicadas. Mucha gente está acostumbrada al enfoque prehistórico de crear un widget "ThemeProvider" solo para cambiar el tema de su aplicación, y esto definitivamente NO es necesario con GetX.

Puede crear su tema personalizado y simplemente agregarlo dentro de Get.changeTheme sin ningún boilerplate para eso:

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
// dar los argumentos actuales de currentScreen
Get.arguments

// dar el nombre de la ruta anterior
Get.previousRoute

// dar la ruta sin procesar para acceder, por ejemplo, rawRoute.isFirst()
Get.rawRoute

// dar acceso a Routing API desde GetObserver
Get.routing

// comprobar si la cafetería está abierta
Get.isSnackbarOpen

// comprobar si el diálogo está abierto
Get.isDialogOpen

// comprobar si  bottomsheet está abierto
Get.isBottomSheetOpen

// eliminar una ruta.
Get.removeRoute()

// volver repetidamente hasta que predicate devuelva verdadero.
Get.until()

//ir a la siguiente ruta y eliminar todas las rutas anteriores hasta que predicate devuelva verdadero.
Get.offUntil()

// ir a la siguiente ruta con nombre y eliminar todas las rutas anteriores hasta que predicate devuelve verdadero.
Get.offNamedUntil()

//Verifique en qué plataforma se ejecuta la aplicación
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isWeb

// Equivalente al método: MediaQuery.of(context).size.height, pero son inmutables.
Get.height
Get.width

// Da el contexto de la pantalla en primer plano en cualquier parte de su código.
Get.context

// Da el contexto de la barra de bocadillos / diálogo / hoja inferior en primer plano en cualquier parte de su código.
Get.contextOverlay

// Note: los siguientes métodos son extensiones de context. Desde que tu
// tiene acceso al contexto en cualquier lugar de su interfaz de usuario, puede usarlo en cualquier lugar del código de la interfaz de usuario

// Si necesita un cambiable height/width (como las ventanas del navegador que se pueden escalar) necesitará usar context.
context.width
context.height



// le da el poder de definir la mitad de la pantalla ahora, un tercio y así sucesivamente.
// Útil para aplicaciones receptivas.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar a MediaQuery.of(context).size
context.mediaQuerySize()

/// similar a MediaQuery.of(context).padding
context.mediaQueryPadding()

/// similar a MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// similar a MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// similar a MediaQuery.of(context).orientation;
context.orientation()

/// comprobar si el dispositivo esta en landscape mode
context.isLandscape()

/// comprobar si el dispositivo esta en portrait mode
context.isPortrait()

/// similar a MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// similar a MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// obtener el lado más corto de la pantalla
context.mediaQueryShortestSide()

/// Verdadero si el ancho es mayor que 800
context.showNavbar()

/// Verdadero si el lado más corto es menor que 600p
context.isPhone()

/// Verdadero si el lado más corto es más grande que 600p
context.isSmallTablet()

/// Verdadero si el lado más corto es mayor que 720p
context.isLargeTablet()

/// Verdadero si el dispositivo actual es una tableta
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

Opcionalmente, puede redirigir todos los mensajes de registro de Get. Si desea utilizar su propio paquete de registro favorito y desea capturar los registros allí.

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
 // pase el mensaje a su paquete de registro favorito aquí
  //Nota: incluso si los mensajes de registro están desactivados
  // con el comando "enableLog: false", los mensajes seguirán pasando por aquí
  // Debe verificar esta configuración manualmente aquí si desea respetarla
}

```

## Video explanation of Other GetX Features

Amateur Coder hizo un video asombroso sobre utilidades, almacenamiento, enlaces y otras características! Link: [GetX Other Features](https://youtu.be/ttQtlX_Q0eU)

# Cambios importantes desde 2.0

1- Rx types:

| Antes   | Ahora      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

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
    GetPage(name: '/', page: () => Home()),
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

1- Después de una actualización de Flutter, muchos paquetes suelen romperse. A veces se producen errores de compilación, errores de los que aún no hay respuestas y el desarrollador necesita saber el origen del error, poder rastrear, y solo entonces intentar abrir un issue en el repositorio correspondiente, para finalmente ver su problema resuelto. Getx centraliza los principales recursos para el desarrollo (gestión de estado, dependencia y rutas), lo que le permite agregar un único paquete a su pubspec y comenzar a trabajar. Después de una actualización de Flutter, lo único que debe hacer es actualizar la dependencia Get y ponerse a trabajar. Get también resuelve problemas de compatibilidad. ¿Cuántas veces una versión de un paquete no es compatible con la versión de otro, porque una usa una dependencia en una versión y la otra en otra? Tampoco es una preocupación usando Get, ya que todo estará en el mismo paquete y será totalmente compatible.

2- Flutter es fácil, Flutter es increíble, pero todavía tiene algo repetitivo que puede ser no deseado para la mayoría de los desarrolladores, como `Navigator.of(context).push (context, builder [...]`. Get simplifica el desarrollo. En lugar de escribir 8 líneas de código para simplemente llamar a una ruta, simplemente puede hacerlo: `Get.to(Home())` y listo, irá a la página siguiente. Algo doloroso de hacer con Flutter actualmente, mientras que con GetX es estúpidamente simple. Gestionar estados en Flutter y dependencias también es algo que genera mucho debate, ya que hay cientos de patrones en el pub. Pero no hay nada tan fácil como agregar un ".obs" al final de su variable, y colocar su widget dentro de un Obx, y eso es todo, todas las actualizaciones de esa variable se actualizarán automáticamente en la pantalla.

3- Facilidad sin preocuparse por el rendimiento. El rendimiento de Flutter ya es sorprendente, pero imagine que usa un gestor de estado y un localizador para distribuir sus clases de bloc/stores/controllers/ etc. Tendrá que llamar manualmente a la exclusión de esa dependencia cuando no la necesite. Pero, ¿alguna vez pensó en simplemente usar el controlador, y cuando ya no sea necesario, simplemente se elimine de la memoria? Eso es lo que hace GetX. Con SmartManagement, todo lo que no se está utilizando se elimina de la memoria, y no debería tener que preocuparse por nada más que la programación. Se le garantiza el consumo mínimo de recursos, sin siquiera haber creado una lógica para esto.

4- Desacoplamiento real. Es posible que haya escuchado la idea de "separar la vista de la lógica de negocio". Esta no es una peculiaridad de BLoC, MVC, MVVM, cualquier otro estándar en el mercado tiene este concepto. Sin embargo, a menudo se puede mitigar en Flutter debido al uso del contexto.
Si necesita contexto para encontrar un InheritedWidget, lo necesita en la vista o pasado por parámetro. En particular, encuentro esta solución muy fea, y para trabajar en equipo siempre tendremos una dependencia de la lógica de negocios de la vista. Getx no es ortodoxo con el enfoque estándar, y aunque no prohíbe completamente el uso de StatefulWidgets, InitState, etc., siempre tiene un enfoque similar que puede ser más limpio. Los controladores tienen ciclos de vida, y cuando necesita hacer una solicitud API REST, por ejemplo, no depende de nada en la vista. Puede usar onInit para iniciar la llamada http, y cuando lleguen los datos, se rellenarán las variables. Como GetX es completamente reactivo (realmente, y funciona bajo streams), una vez que se llenan los elementos, todos los widgets que usan esa variable se actualizarán automáticamente en la vista. Esto permite que las personas con experiencia en IU trabajen solo con widgets y no tengan que enviar nada a la lógica de negocios que no sean eventos de usuario (como hacer clic en un botón), mientras que las personas que trabajan con lógica de negocios podrán crearla y probarla por separado.

Esta librería siempre se actualizará e implementará nuevas características. Siéntase libre de ofrecer PRs y contribuir a ellas.

# Comunidad

## Canales de la comunidad

GetX tiene una comunidad muy activa e implicada. Si tiene dudas, o necesita cualquier tipo de asistencia sobre el uso de este framework, no dude en unirse a nuestr, tu duda será resuelta lo antes posible. Este repositorio es de uso exclusivo para abrir issues, pero siéntase libre de unirse a la Comunidad de GetX.


| **Slack (🇬🇧)**                                                                                                                   | **Discord (🇬🇧 y 🇵🇹)**                                                                                                                 | **Telegram (🇵🇹)**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |


# Cómo contribuir

_¿Quieres contribuir al proyecto? Estaremos orgullosos de destacarte como uno de nuestros colaboradores. Aquí hay algunos puntos en los que puede contribuir y hacer que GetX (y Flutter) sea aún mejor._

- Ayudando a traducir el archivo Léame a otros idiomas.

- Agregar documentación al archivo Léame (ni siquiera la mitad de las funciones de GetX han sido documentadas todavía).

- Escriba artículos o haga videos que enseñen cómo usar GetX (se insertarán en el archivo Léame y en el futuro en nuestro Wiki).

- Ofreciendo PRs para código/pruebas.

- Incluyendo nuevas funciones.

¡Cualquier contribución es bienvenida!

## Artículos y vídeos (inglés)

- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - Tutorial by [Pesa Coder](https://github.com/UsamaElgendy).
- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman).
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Dependency Injection by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter.
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - by [Roi Peker](https://github.com/roipeker)
