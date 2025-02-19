---
sidebar_position: 4
---

# Utils

## Internacionalización

### Traducciones

Las traducciones se mantienen como un simple mapa del diccionario clave-valor.
Para añadir traducciones personalizadas, crea una clase y extiende `traducciones`.

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

Simplemente añade `.tr` a la clave especificada y se traducirá, usando el valor actual de `Get.locale` y `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Utilizando la traducción con singular y plural

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Utilizando la traducción con parámetros

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

### Locales

Pasar los parámetros a `GetMaterialApp` para definir la localización y las traducciones.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### Cambiar idioma

Llama a `Get.updateLocale(locale)` para actualizar la locale. A continuación, las traducciones utilizan automáticamente el nuevo idioma.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Localización del sistema

Para leer la configuración regional del sistema, puede utilizar `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Cambiar tema

Por favor, no utilice ningún widget de nivel superior a `GetMaterialApp` para actualizarlo. Esto puede desencadenar claves duplicadas. Muchas personas están acostumbradas al enfoque prehistórico de crear un widget "ThemeProvider" sólo para cambiar el tema de tu aplicación, y esto definitivamente NO es necesario con **GetXTM**.

Puedes crear tu tema personalizado y simplemente añadirlo en `Get.changeTheme` sin ningún tipo de aviso para eso:

```dart
Get.changeTheme(ThemeData.light());
```

Si quieres crear algo como un botón que cambia el tema en `onTap`, puedes combinar dos API **GetXTM** para eso:

- La api que comprueba si el oscuro `Theme` está siendo usado.
- Y el API de cambio de `Theme`, puedes poner esto dentro de un `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Cuando `.darkmode` está activado, cambiará al _light theme_, y cuando el _light theme_ se activa, cambiará a _tema oscuro_.

## Conectar

GetConnect es una forma fácil de comunicarse desde la parte trasera a tu frente con http o websockets

### Configuración por defecto

Puede simplemente extender GetConnect y utilizar los métodos GET/POST/PUT/DELETE/SOCKET para comunicarse con su API Rest o websockets.

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

GetConnect es altamente personalizable. Puedes definir la Url base, como modificadores de respuesta, como modificadores de peticiones, definen un autenticador, e incluso el número de intentos en los que intentará autoautenticarse. además de dar la posibilidad de definir un decodificador estándar que transformará todas sus peticiones en sus modelos sin ninguna configuración adicional.

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

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## Obtener Middleware

GetPage tiene ahora una nueva propiedad que toma una lista de GetMiddleWare y ejecutarlos en el orden específico.

**Nota**: Cuando GetPage tenga un Middlewares, todos los hijos de esta página tendrán los mismos middlewares automáticamente.

### Prioridad

La Orden de los Middlewares a ejecutar puede ser establecida por la prioridad en el GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

esos middlewares se ejecutarán en este orden **-8 => 2 => 4 => 5**

### Redirigir

Esta función será llamada cuando se busque la página de la ruta llamada. Se necesita RouteSettings como resultado para redirigirse. O dale nulo y no habrá redireccionamiento.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### en la página llamada

Esta función se llamará cuando se llame a esta página antes de cualquier cosa creada
puedes usarla para cambiar algo sobre la página o darle una nueva página

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Esta función se llamará justo antes de que los enlaces sean inicializados.
Aquí puedes cambiar los enlaces para esta página.

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### Inicio OnPageBuild

Esta función se llamará justo después de que los enlaces sean inicializados.
Aquí puedes hacer algo después de que hayas creado los enlaces y antes de crear el widget de página.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Esta función será llamada justo después de que la función GetPage.page sea llamada y le dará el resultado de la función. y tome el widget que se mostrará.

### Disponer en la página

Esta función se llamará justo después de eliminar todos los objetos relacionados (Controladores, vistas, ...) de la página.

## Otras API avanzadas

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

/// Similar to MediaQuery.sizeOf(context);
context.mediaQuerySize()

/// Similar to MediaQuery.paddingOf(context);
context.mediaQueryPadding()

/// Similar to MediaQuery.viewPaddingOf(context);
context.mediaQueryViewPadding()

/// Similar to MediaQuery.viewInsetsOf(context);
context.mediaQueryViewInsets()

/// Similar to MediaQuery.orientationOf(context);
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.devicePixelRatioOf(context);
context.devicePixelRatio()

/// Similar to MediaQuery.textScaleFactorOf(context);
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

### Configuración global opcional y configuraciones manuales

GetMaterialApp configura todo para ti, pero si quieres configurar Get manualmente.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

También podrá utilizar su propio Middleware dentro de `GetObserver`, esto no influirá en nada.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

Puedes crear _Configuración global_ para `Get`. Simplemente añade `Get.config` a tu código antes de empujar cualquier ruta.
O hazlo directamente en tu `GetMaterialApp`

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

Opcionalmente puede redirigir todos los mensajes de registro de `Get`.
Si quieres usar tu propio paquete de registro favorito,
y quieres capturar los registros ahí:

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

### Widgets del estado local

Estos Widgets te permiten administrar un único valor, y mantener el estado efemeral y localmente.
Tenemos sabores para Reactive y simples.
Por ejemplo, puedes usarlos para alternar obscureText en un `TextField`, tal vez crear un Panel
Personalizable, o tal vez modificar el índice actual en `BottomNavigationBar` cambiando el contenido
del cuerpo en un `Scaffold`.

#### Constructor de valores

Una simplificación de `StatefulWidget` que funciona con un callback `.setState` que toma el valor actualizado.

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

Similar a [`ValueBuilder`](#valuebuilder), pero esta es la versión Reactiva, pasas una instancia Rx (¿recuerdas los .obs mágicos?) y
actualizaciones automáticamente... ¿No es increíble?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Consejos útiles

Los tipos `.obs`ervables (también conocidos como _Rx_ Types) tienen una amplia variedad de métodos y operadores internos.

> Es muy común _creer_ que una propiedad con `.obs` **IS** el valor real... ¡pero no te equivoques!
> Evitamos la declaración Type de la variable, porque el compilador de Dart es suficientemente inteligente, y el código
> se ve más limpio, pero:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

¡Incluso si `message` _imprime_ el valor real de cadena, el tipo es **RxString**!

Así que no puedes hacer `message.substring( 0, 4 )`.
Tienes que acceder al verdadero `valor` dentro del _observable_:
La forma más "utilizada" es `. alue`, pero, ¿sabías que también puedes usar...

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

## Mixin de estado

Otra forma de manejar tu estado `UI` es usar el `StateMixin<T>` .
Para implementarlo, usa el `con` para agregar el `StateMixin<T>`
a tu controlador que permite un modelo T.

```dart
class Controller extends GetController with StateMixin<User>{}
```

El método `change()` cambia el Estado siempre que queremos.
Simplemente pase los datos y el estado de esta manera:

```dart
change(data, status: RxStatus.success());
```

RxStatus permite estos estados:

```dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Para representarlo en la interfaz de usuario, use:

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

Me encanta este Widget, es tan simple, pero tan útil!

Es un Widget `const Stateless` que tiene un getter `controller` para un `Controller` registrado, eso es todo.

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

#### Ver Responsiva

Extender este widget para crear una vista receptiva.
este widget contiene la propiedad `screen` que tiene toda la información
sobre el tamaño y el tipo de pantalla.

##### Cómo usarlo

Tienes dos opciones para construirlo.

- con el método `builder` devuelve el widget a construir.
- con métodos `desktop`, `tablet`,`phone`, `watch`. el método
  específico se construirá cuando el tipo de pantalla coincida con el método
  cuando la pantalla sea \[ScreenType.Tablet] el método `tablet`
  se existirá, y así sucesivamente.
  **Nota:** Si usas este método, por favor establece la propiedad `alwaysUseBuilder` a `false`

Con la propiedad `settings` puedes establecer el límite de ancho para los tipos de pantalla.

[example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Código a esta pantalla
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

La mayoría de la gente no tiene ni idea de este Widget, o confunde totalmente el uso de él.
El caso de uso es muy raro, pero muy específico: `caches` un Controller.
Debido a la _cache_, no puede ser un `const Stateless`.

> Entonces, ¿cuándo necesitas "cache" un Controlador?

Si usas, otra característica "no tan común" de **GetX**: `Get.create()`.

`Get.create(()=>Controller())` generará un nuevo `Controller` cada vez que llame
`Get.find<Controller>()`,

Ahí es donde brilla `GetWidget`... como puedes usarlo, por ejemplo,
para mantener una lista de elementos de Tarea Así que, si el widget es "reconstruido", mantendrá la misma instancia del controlador.

#### GetxService

Esta clase es como un `GetxController`, comparte el mismo ciclo de vida ( `onInit()`, `onReady()`, `onClose()`).
Pero no tiene una "lógica" dentro de ella. Acaba de notificar al sistema de Inyección de Dependencia **GetX**, que esta subclase
**no** puede ser removida de la memoria.

Así que es super útil para mantener sus "Servicios" siempre accesible y activo con `Get.find()`. Me gusta:
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

La única forma de eliminar un `GetxService`, es con `Get.reset()` que es como un
"Reinicio caliente" de tu aplicación. Así que recuerda, si necesitas persistencia absoluta de una instancia de clase durante la vida útil de
de tu aplicación, usa `GetxService`.

### Tests

Puedes probar tus controladores como cualquier otra clase, incluyendo sus ciclos de vida:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Change value to name2
    name.value = 'name2';
  }

  @override
  void onClose() {
    name.value = '';
    super.onClose();
  }

  final name = 'name1'.obs;

  void changeName() => name.value = 'name3';
}

void main() {
  test('''
Test the state of the reactive variable "name" across all of its lifecycles''',
      () {
    /// You can test the controller without the lifecycle,
    /// but it's not recommended unless you're not using
    ///  GetX dependency injection
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// If you are using it, you can test everything,
    /// including the state of the application after each lifecycle.
    Get.put(controller); // onInit was called
    expect(controller.name.value, 'name2');

    /// Test your functions
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose was called
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### Consejos

##### Mockito o cola de mocktail

Si necesita simular su GetxController/GetxService, debería extender GetxController, y mezclarlo con Mock, de esa manera

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Usando Get.reset()

Si estás probando widgets, o grupos de pruebas, usa Obtener. eset al final de tu prueba o en tearDown para reiniciar todas las configuraciones de tu prueba anterior.

##### Get.testMode

si estás usando tu navegación en tus controladores, usa `Get.testMode = true` al principio de tu principal.

# Rompiendo cambios desde 2.0

1- Tipos Rx:

| Antes    | Después    |
| -------- | ---------- |
| StringX  | `RxString` |
| IntX     | `RxInt`    |
| MapX     | `RxMap`    |
| Lista X  | `RxList`   |
| Número X | `RxNum`    |
| DoubleX  | `Duplicar` |

Ahora RxController y GetBuilder se han fusionado, ya no necesita memorizar qué controlador desea utilizar. sólo tiene que utilizar GetxController, funcionará para la gestión simple del estado y también para la reactividad.

2- Rutas Nombradas
Before:

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
A menudo, puede ser necesario decidir qué página se mostrará desde un parámetro, o un token de inicio de sesión, el enfoque anterior era inflexible, ya que no permitía esto.
Insertar la página en una función ha reducido significativamente el consumo de RAM, ya que las rutas no se asignarán en la memoria desde que se inició la aplicación, y también permitieron hacer este tipo de método:

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
