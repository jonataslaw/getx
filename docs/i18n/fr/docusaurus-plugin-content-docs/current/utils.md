---
sidebar_position: 4
---

# Utils

## Internationalisation

### Traductions

Les traductions sont conservées comme une simple carte de dictionnaire de valeur clé.
Pour ajouter des traductions personnalisées, créez une classe et étendez `Translations`.

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

#### Utiliser les traductions

Ajoute simplement `.tr` à la clé spécifiée et elle sera traduite, en utilisant la valeur actuelle de `Get.locale` et `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Utilisation de la traduction au singulier et au pluriel

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Utilisation de la traduction avec les paramètres

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

Passez les paramètres à `GetMaterialApp` pour définir la locale et les traductions.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### Changer la locale

Appelez `Get.updateLocale(locale)` pour mettre à jour la locale. Les traductions utilisent alors automatiquement la nouvelle locale.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Paramètres régionaux du système

Pour lire la locale du système, vous pouvez utiliser `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Changer de thème

Veuillez ne pas utiliser de widget de niveau supérieur à `GetMaterialApp` pour le mettre à jour. Cela peut déclencher des clés dupliquées. Beaucoup de gens sont habitués à l'approche préhistorique de la création d'un widget "Fournisseur de thèmes" simplement pour changer le thème de votre application, et ce n'est certainement PAS nécessaire avec **GetXTM**.

Vous pouvez créer votre thème personnalisé et l'ajouter simplement dans `Get.changeTheme` sans aucune boilerplate pour cela:

```dart
Get.changeTheme(ThemeData.light());
```

Si vous voulez créer quelque chose comme un bouton qui change le thème dans `onTap`, vous pouvez combiner deux API **GetXTM** pour cela :

- L'api qui vérifie si le sombre `Theme` est utilisé.
- Et le `Thème` Change API, vous pouvez juste le mettre dans un `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Quand `.darkmode` est activé, il bascule vers le thème \_light et quand le thème \_light devient actif, il passera à _dark theme_.

## Se connecter

GetConnect est un moyen facile de communiquer de votre dos à votre front avec http ou websockets

### Configuration par défaut

Vous pouvez simplement étendre GetConnect et utiliser les méthodes GET/POST/PUT/DELETE/SOCKET pour communiquer avec votre API Rest ou vos sockets.

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

### Configuration personnalisée

GetConnect est hautement personnalisable. Vous pouvez définir l'URL de base, comme modificateur de réponse, comme modificateur de requêtes, définir un authentificateur et même le nombre de tentatives dans lesquelles il essaiera de s'authentifier, en plus de donner la possibilité de définir un décodeur standard qui transformera toutes vos requêtes en modèles sans configuration supplémentaire.

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

## GetPage Middleware

La GetPage a maintenant une nouvelle propriété qui prend une liste de GetMiddleWare et les exécute dans l'ordre spécifique.

**Remarque** : lorsque GetPage a un Middlewares, tous les enfants de cette page auront automatiquement les mêmes marchandises du milieu.

### Priorité

L'ordre des Middlewares à exécuter peut être défini par la priorité dans le GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

ces middlewares seront exécutés dans cet ordre **-8 => 2 => 4 => 5**

### Rediriger

Cette fonction sera appelée lorsque la page de la route appelée sera recherchée. Il prend les paramètres de route comme un résultat vers lequel rediriger. Ou donnez-lui null et il n'y aura pas de redirection.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### sur la page appelée

Cette fonction sera appelée lorsque cette page sera appelée avant tout ce qui est créé
vous pouvez l'utiliser pour changer quelque chose à propos de la page ou lui donner une nouvelle page

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Cette fonction sera appelée juste avant l'initialisation de la liaison.
Ici, vous pouvez changer les Liens pour cette page.

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### Démarrage de la construction sur la page

Cette fonction sera appelée juste après l'initialisation des liaisons.
Ici, vous pouvez faire quelque chose après que vous avez créé les liaisons et avant de créer le widget de page.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Cette fonction sera appelée juste après que la fonction GetPage.page soit appelée et vous donnera le résultat de la fonction. et prendre le widget qui sera affiché.

### Disposer de la page

Cette fonction sera appelée juste après avoir éliminé tous les objets connexes (Contrôleurs, vues, ...) de la page.

## Autres API Avancées

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

### Paramètres globaux optionnels et configurations manuelles

GetMaterialApp configure tout pour vous, mais si vous voulez configurer Get manuellement.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

Vous pourrez également utiliser votre propre Middleware dans `GetObserver`, cela n'influencera rien.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

Vous pouvez créer _Paramètres globaux_ pour `Get`. Ajoute simplement `Get.config` à ton code avant d'envoyer n'importe quelle route.
Ou faites-le directement dans votre `GetMaterialApp`

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

Vous pouvez optionnellement rediriger tous les messages de log de `Get`.
Si vous voulez utiliser votre propre paquet de journalisation favori,
et que vous voulez y capturer les logs :

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

### Widgets d'état local

Ces Widgets vous permettent de gérer une seule valeur et de garder l'état éphémère et localement.
Nous avons des saveurs pour la réactivité et la simplicité.
Par exemple, vous pouvez les utiliser pour activer/désactiver obscureText dans un `TextField`, peut-être créer un panneau
personnalisé, ou peut-être modifier l'index actuel dans `BottomNavigationBar` en changeant le contenu
du corps dans un `Scaffold`.

#### Constructeur de valeur

Une simplification de `StatefulWidget` qui fonctionne avec un callback `.setState` qui prend la valeur mise à jour.

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

Similaire à [`ValueBuilder`](#valuebuilder), mais il s'agit de la version réactive, vous passez une instance Rx (souvenez-vous du .obs magique ?) et
se met à jour automatiquement... Ce n'est pas génial ?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Conseils utiles

`.obs`ervables (aussi connu sous le nom de _Rx_ Types) ont une grande variété de méthodes et d'opérateurs internes.

> Est très commun de _croire_ qu'une propriété avec `.obs` **IS** la valeur réelle... mais ne vous méprenez pas!
> Nous évitons la déclaration de type de la variable, car le compilateur de Dart est assez intelligent, et le code
> semble plus propre, mais:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Même si `message` _prints_ la valeur réelle de chaîne de caractères, le Type est **RxString**!

Donc, vous ne pouvez pas faire `message.substring( 0, 4 )`.
Vous devez accéder à la vraie `value` à l'intérieur du _observable_:
La méthode la plus "utilisée" est `. alue`, mais saviez-vous que vous pouvez aussi utiliser...

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

## Mixin

Une autre façon de gérer votre état `UI` est d'utiliser le `StateMixin<T>`.
Pour l'implémenter, utilisez le `with` pour ajouter le `StateMixin<T>`
à votre contrôleur qui permet un modèle T.

```dart
class Controller extends GetController with StateMixin<User>{}
```

La méthode `change()` change l'état quand nous le voulons.
Il suffit de transmettre les données et le statut de cette façon :

```dart
change(data, status: RxStatus.success());
```

RxStatus autorise ces statuts :

```dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Pour le représenter dans l'interface utilisateur, utilisez :

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

J'aime ce Widget, est si simple, mais si utile!

Est un Widget `const Stateless` qui a un getter `controller` pour un `Controller` enregistré, c'est tout.

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

#### Obtenir la vue Responsive

Étendre ce widget pour construire une vue responsive.
ce widget contient la propriété `screen` qui a toutes les informations
sur la taille et le type de l'écran.

##### Comment l'utiliser

Vous avez deux options pour le construire.

- avec la méthode `builder` vous retournez le widget à construire.
- avec les méthodes `desktop`, `tablet`,`phone`, `watch`. la méthode
  spécifique sera construite lorsque le type d'écran correspond à la méthode
  quand l'écran est \[ScreenType.Tablet] la méthode `tablet`
  sera expurgée, et ainsi de suite.
  **Note:** Si vous utilisez cette méthode, veuillez définir la propriété `alwaysUseBuilder` à `false`

Avec la propriété `settings` vous pouvez définir la limite de largeur pour les types d'écran.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code à cet écran
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

La plupart des gens n'ont aucune idée de ce Widget, ou complètement confondre son utilisation.
Le cas d'utilisation est très rare, mais très spécifique: Il `caches` un Contrôleur.
À cause du _cache_, ne peut pas être un `const Stateless`.

> Alors, quand avez-vous besoin de "cacher" un contrôleur ?

Si vous utilisez, une autre fonctionnalité "pas si commune" de **GetX**: `Get.create()`.

`Get.create(()=>Controller())` générera un nouveau `Controller` chaque fois que vous appelez
`Get.find<Controller>()`,

C'est là que réside `GetWidget`... comme vous pouvez l'utiliser, par exemple,
pour garder une liste des éléments de Todo. Donc, si le widget est reconstruit, il conservera la même instance de contrôleur.

#### GetxService

Cette classe est comme un `GetxController`, il partage le même cycle de vie ( `onInit()`, `onReady()`, `onClose()`).
Mais il n'y a pas de "logique" à l'intérieur. Il suffit de notifier **GetX** système d'injection de dépendance, que cette sous-classe
**ne peut pas** être retirée de la mémoire.

Il est donc super utile de garder vos "Services" toujours joignables et actives avec `Get.find()`. J'aime:
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

La seule façon de supprimer un `GetxService`, est d'utiliser `Get.reset()` qui est comme un
"Hot Reboot" de votre application. So remember, if you need absolute persistence of a class instance during the
lifetime of your app, use `GetxService`.

### Tests

Vous pouvez tester vos contrôleurs comme n'importe quelle autre classe, y compris leur cycle de vie :

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

#### Conseils

##### Mockito ou mocktail

Si vous avez besoin de bouchonner votre GetxController/GetxService, vous devriez étendre GetxController, et le mélanger avec Mock, de cette façon

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Utiliser la fonction Get.reset()

Si vous testez des widgets, ou des groupes de test, utilisez Get. à la fin de votre test ou dans tearDown pour réinitialiser tous les paramètres de votre test précédent.

##### Get.testMode

si vous utilisez votre navigation dans vos contrôleurs, utilisez `Get.testMode = true` au début de votre main.

# Interruption des changements à partir de 2.0

1- Types Rx :

| Avant                | Après      |
| -------------------- | ---------- |
| StringX              | `RxString` |
| IntX                 | `RxInt`    |
| MapX                 | `RxMap`    |
| Liste X              | `RxList`   |
| Nombre de unnamed@@0 | `RxNum`    |
| DoubleX              | `RxDouble` |

RxController et GetBuilder ont maintenant fusionné, vous n'avez plus besoin de mémoriser quel contrôleur vous voulez utiliser, il suffit d'utiliser GetxController, il fonctionnera pour une gestion simple de l'état et pour la réactive aussi.

2- NamedRoutes
Avant:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Maintenant :

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

Pourquoi ce changement ?
Souvent, il peut être nécessaire de décider quelle page sera affichée à partir d'un paramètre, ou un jeton de connexion, l'approche précédente était inflexible, car elle ne l'autorisait pas.
L'insertion de la page dans une fonction a considérablement réduit la consommation de mémoire, car les routes ne seront pas allouées en mémoire depuis que l'application a été démarrée, et elle a également permis de faire ce type d'approche :

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
