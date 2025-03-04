![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

*Idiomas: Español (este archivo), [Vietnamita](README-vi.md), [Indonesio](README.id-ID.md), [Urdu](README.ur-PK.md), [Lengua china](README.zh-cn.md), [Inglés](README.md), [Portugués de Brasil](README.pt-br.md), [Ruso](README.ru.md), [Polaco](README.pl.md), [Coreano](README.ko-kr.md), [Francés](README-fr.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![popularity](https://badges.bar/get/popularity)](https://pub.dev/packages/sentry/score)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
[![pub points](https://badges.bar/get/pub%20points)](https://pub.dev/packages/get/score)
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
  - [Artículos y vídeos](#artículos-y-vídeos-inglés)

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
## Internacionalización

### Traducciones
Las traducciones se guardan en un simple diccionario clave-valor.
Crea una clase y extiende `Translations` para añadir tus propias traducciones.

```dart
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
```

#### Usando traducciones

Simplemente añade `.tr` al final de una clave y será traducida usando el valor actual de `Get.locale` y `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Traducciones con singular y plural

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Traducciones con parámetros

```dart
import 'package:get/get.dart';


Map<String, Map<String, String>> get keys => {
    'en_US': {
        'logged_in': 'logged in as @name with email @email',
    },
    'es_ES': {
       'logged_in': 'iniciado sesión como @name con e-mail @email',
    }
};

Text('logged_in'.trParams({
  'name': 'Jhon',
  'email': 'jhon@example.com'
  }));
```

### Localización

Pasa parámetros a `GetMaterialApp` para definir las traducciones y la configuración regional.

```dart
return GetMaterialApp(
    translations: Messages(), // tus traducciones
    locale: Locale('en', 'US'), // las traducciones serán mostradas en la configuración regional especificada
    fallbackLocale: Locale('en', 'UK'), // especifica la configuración regional de respaldo usada cuando se selecciona una configuración regional inválida
);
```

#### Cambiar la configuración regional

Usa `Get.updateLocale(locale)` para actualizar la configuración regional. Las traducciones utilizarán automáticamente la nueva configuración regional. 

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Confgiuración regional del sistema

Puedes usar `Get.deviceLocale` para obtener la configuración regional del sistema.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Cambiar de tema

No utilice ningún widget de un nivel superior al de `GetMaterialApp` para actualizar el tema. Esto puede activar claves duplicadas. Mucha gente está acostumbrada al enfoque prehistórico de crear un widget "ThemeProvider" solo para cambiar el tema de su aplicación, y esto definitivamente NO es necesario con **GetX™**.

Puede crear su tema personalizado y simplemente agregarlo dentro de `Get.changeTheme` sin la necesidad de utilizar boilerplate para eso:

```dart
Get.changeTheme(ThemeData.light());
```

Si desea crear algo así como un botón que cambia el tema con `onTap`, puede combinar dos APIs **GetX™** para eso
   - La API que verifica si se está utilizando el `Theme` oscuro
   - La API de cambio de `Theme`, simplemente puede poner esto dentro de un `onPressed`:

   ```dart
   Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
   ```

Cuando el modo oscuro está activado, cambiará al tema claro, y cuando el tema claro esté activado, cambiará a oscuro.

Si quieres saber en profundidad cómo cambiar el tema, puedes seguir este tutorial en Medium que incluso enseña la persistencia del tema usando GetX:

- [Temas dinámicos en 3 líneas usando GetX](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial de [Rod Brown](https://github.com/RodBr).


## GetConnect
GetConnect es una forma sencilla de comunicar tu front con tu back utilizando http o websockets

### Configuración por defecto

Puedes simplemente extender GetConnect y utilizar los métodos GET/POST/PUT/DELETE/SOCKET para cominicarte con tu API Rest o tus websockets. 

```dart
class UserProvider extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // Post request with File
  Future<Response<CasesModel>> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
```

### Configuración personalizada

GetConnect is highly customizable You can define base Url, as answer modifiers, as Requests modifiers, define an authenticator, and even the number of attempts in which it will try to authenticate itself, in addition to giving the possibility to define a standard decoder that will transform all your requests into your Models without any additional configuration.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // It define baseUrl to
    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Even if the server sends data from the country "Brazil",
    // it will never be displayed to users, because you remove
    // that data from the response, even before the response is delivered
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Set the header
      request.headers['Authorization'] = "$token";
      return request;
    });

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

The GetPage has now new property that takes a list of GetMiddleWare and run them in the specific order.

**Note**: When GetPage has a Middlewares, all the children of this page will have the same middlewares automatically.

### Priority

The Order of the Middlewares to run can pe set by the priority in the GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

those middlewares will be run in this order **-8 => 2 => 4 => 5**

### Redirect

This function will be called when the page of the called route is being searched for. It takes RouteSettings as a result to redirect to. Or give it null and there will be no redirecting.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

This function will be called right before the Bindings are initialize.
Here you can change Bindings for this page.

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### OnPageBuildStart

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

### OnPageDispose

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

## Other Advanced APIs

```dart
// give the current args from currentScreen
Get.arguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Routing API from GetObserver
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
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Check the device type
GetPlatform.isMobile
GetPlatform.isDesktop
//All platforms are supported independently in web!
//You can tell if you are running inside a browser
//on Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

// Gives you the power to define half the screen, a third of it and so on.
// Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similar to MediaQuery.of(context).orientation;
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Get the shortestSide from screen
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

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

### Optional Global Settings and Manual configurations

GetMaterialApp configures everything for you, but if you want to configure Get manually.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

You will also be able to use your own Middleware within `GetObserver`, this will not influence anything.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

You can create _Global Settings_ for `Get`. Just add `Get.config` to your code before pushing any route.
Or do it directly in your `GetMaterialApp`

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

You can optionally redirect all the logging messages from `Get`.
If you want to use your own, favourite logging package,
and want to capture the logs there:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // pass the message to your favourite logging package here
  // please note that even if enableLog: false log messages will be pushed in this callback
  // you get check the flag if you want through GetConfig.isLogEnable
}

```

### Local State Widgets

These Widgets allows you to manage a single value, and keep the state ephemeral and locally.
We have flavours for Reactive and Simple.
For instance, you might use them to toggle obscureText in a `TextField`, maybe create a custom
Expandable Panel, or maybe modify the current index in `BottomNavigationBar` while changing the content
of the body in a `Scaffold`.

#### ValueBuilder

A simplification of `StatefulWidget` that works with a `.setState` callback that takes the updated value.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // same signature! you could use ( newValue ) => updateFn( newValue )
  ),
  // if you need to call something outside the builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

Similar to [`ValueBuilder`](#valuebuilder), but this is the Reactive version, you pass a Rx instance (remember the magical .obs?) and
updates automatically... isn't it awesome?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Useful tips

`.obs`ervables (also known as _Rx_ Types) have a wide variety of internal methods and operators.

> Is very common to _believe_ that a property with `.obs` **IS** the actual value... but make no mistake!
> We avoid the Type declaration of the variable, because Dart's compiler is smart enough, and the code
> looks cleaner, but:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Even if `message` _prints_ the actual String value, the Type is **RxString**!

So, you can't do `message.substring( 0, 4 )`.
You have to access the real `value` inside the _observable_:
The most "used way" is `.value`, but, did you know that you can also use...

```dart
final name = 'GetX'.obs;
// only "updates" the stream, if the value is different from the current one.
name.value = 'Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name('Hello');

// is like a getter, prints 'Hello'.
name() ;

/// numbers:

final count = 0.obs;

// You can use all non mutable operations from num primitives!
count + 1;

// Watch out! this is only valid if `count` is not final, but var
count += 1;

// You can also compare against values:
count > 2;

/// booleans:

final flag = false.obs;

// switches the value between true/false
flag.toggle();


/// all types:

// Sets the `value` to null.
flag.nil();

// All toString(), toJson() operations are passed down to the `value`
print( count ); // calls `toString()` inside  for RxInt

final abc = [0,1,2].obs;
// Converts the value to a json Array, prints RxList
// Json is supported by all Rx types!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList and RxSet are special Rx types, that extends their native types.
// but you can work with a List as a regular list, although is reactive!
abc.add(12); // pushes 12 to the list, and UPDATES the stream.
abc[3]; // like Lists, reads the index 3.


// equality works with the Rx and the value, but hashCode is always taken from the value
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() are deferred to the child, so you can implement override on them, and print() the observable directly.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Roi';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```
## StateMixin

Another way to handle your `UI` state is use the `StateMixin<T>` .
To implement it, use the `with` to add the `StateMixin<T>`
to your controller which allows a T model.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(data, status: RxStatus.success());
```

RxStatus allow these status:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

To represent it in the UI, use:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

I love this Widget, is so simple, yet, so useful!

Is a `const Stateless` Widget that has a getter `controller` for a registered `Controller`, that's all.

```dart
 class AwesomeController extends GetController {
   final String title = 'My Awesome View';
 }

  // ALWAYS remember to pass the `Type` you used to register your controller!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // just call `controller.something`
     );
   }
 }
```

#### GetResponsiveView

Extend this widget to build responsive view.
this widget contains the `screen` property that have all
information about the screen size and type.

##### How to use it

You have two options to build it.

- with `builder` method you return the widget to build.
- with methods `desktop`, `tablet`,`phone`, `watch`. the specific
  method will be built when the screen type matches the method
  when the screen is [ScreenType.Tablet] the `tablet` method
  will be exuded and so on.
  **Note:** If you use this method please set the property `alwaysUseBuilder` to `false`

With `settings` property you can set the width limit for the screen types.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Most people have no idea about this Widget, or totally confuse the usage of it.
The use case is very rare, but very specific: It `caches` a Controller.
Because of the _cache_, can't be a `const Stateless`.

> So, when do you need to "cache" a Controller?

If you use, another "not so common" feature of **GetX**: `Get.create()`.

`Get.create(()=>Controller())` will generate a new `Controller` each time you call
`Get.find<Controller>()`,

That's where `GetWidget` shines... as you can use it, for example,
to keep a list of Todo items. So, if the widget gets "rebuilt", it will keep the same controller instance.

#### GetxService

This class is like a `GetxController`, it shares the same lifecycle ( `onInit()`, `onReady()`, `onClose()`).
But has no "logic" inside of it. It just notifies **GetX** Dependency Injection system, that this subclass
**can not** be removed from memory.

So is super useful to keep your "Services" always reachable and active with `Get.find()`. Like:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Is a smart move to make your Services intiialize before you run the Flutter app.
/// as you can control the execution flow (maybe you need to load some Theme configuration,
/// apiKey, language defined by the User... so load SettingService before running ApiService.
/// so GetMaterialApp() doesnt have to rebuild, and takes the values directly.
void initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(SettingsService()).init();
  print('All services started...');
}

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType delays 2 sec');
    await 2.delay();
    print('$runtimeType ready!');
    return this;
  }
}

class SettingsService extends GetxService {
  void init() async {
    print('$runtimeType delays 1 sec');
    await 1.delay();
    print('$runtimeType ready!');
  }
}

```

The only way to actually delete a `GetxService`, is with `Get.reset()` which is like a
"Hot Reboot" of your app. So remember, if you need absolute persistence of a class instance during the
lifetime of your app, use `GetxService`.



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
