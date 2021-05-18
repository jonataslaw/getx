![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Langues: Français (Ce fichier), [Anglais](README.md),  [Indonésien](README.id-ID.md), [Urdu](README.ur-PK.md), [Chinois](README.zh-cn.md), [Portuguais du Brésil](README.pt-br.md), [Espagnol](README-es.md), [Russe](README.ru.md), [Polonais](README.pl.md), [Koréen](README.ko-kr.md).**

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)
[![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)
<a href="https://github.com/Solido/awesome-flutter">
<img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Achetez moi un cafe" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)

- [A Propos de Get](#a-propos-de-get)
- [Installation](#installation)
- [L'application 'Counter' avec GetX](#application-counter-avec-getx)
- [Les trois pilliers](#les-trois-pilliers)
  - [Gestion d'état (State management)](#gestion-d-etat)
    - [Gestionnaire d'état réactif (Reactive State Manager)](#gestionnaire-d-etat-reactif)
    - [Plus de détails sur la gestion d'état](#plus-de-details-sur-la-gestion-d-etat)
  - [Gestion de route](#gestion-de-route)
    - [Plus de détails sur la gestion de route](#plus-de-details-sur-la-gestion-de-route)
  - [Gestion des dépendances](#gestion-des-dependances)
    - [Plus de détails sur la gestion des dépendances](#plus-de-details-sur-la-gestion-des-dependances)
- [Utils](#utils)
  - [Internationalization](#internationalization)
    - [Traductions](#traductions)
      - [Utiliser les traductions](#utiliser-les-traductions)
    - [Locales](#locales)
      - [Changer la locale](#changer-la-locale)
      - [Locale du Système](#locale-du-systeme)
  - [Changer le Thème](#changer-le-theme)
  - [GetConnect](#getconnect)
    - [Configuration par défaut](#configuration-par-defaut)
    - [Configuration personnalisée](#configuration-personnalisee)
  - [Middleware GetPage](#middleware-getpage)
    - [Priority](#priority)
    - [Redirect](#redirect)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [Autres APIs](#autres-apis)
    - [Paramètres globaux et configurations manuelles facultatifs](#parametres-globaux-et-configurations-manuelles-facultatifs)
    - [State Widgets Locaux](#state-widgets-locaux)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [Conseils utiles](#conseils-utiles)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [Guide d'utilisation](#guide-d-utilisation)
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
- [Changements par rapport à 2.0](#changements-par-rapport-a-20)
- [Pourquoi Getx?](#pourquoi-getx)
- [Communité](#communite)
  - [Chaînes communautaires](#chaines-communautaires)
  - [Comment contribuer](#comment-contribuer)
  - [Articles et videos](#articles-et-videos)

# A Propos de Get

- GetX est une solution extra-légère et puissante pour Flutter. Il combine une gestion d'état (state management) de haute performance, une injection de dépendances (dependency injection) intelligente et une gestion de route (route management) rapide et pratique.

- GetX a 3 principes de base. Cela signifie que ces principes sont les priorités pour toutes les ressources de la bibliothèque GetX: **PRODUCTIVITÉ, PERFORMANCE ET ORGANIZATION.**

  - **PERFORMANCE:** GetX se concentre sur la performance et la consommation minimale de ressources. GetX n'utilise ni Streams ni ChangeNotifier.

  - **PRODUCTIVITÉ:** GetX utilise une syntaxe simple et agréable. Peu importe ce que vous voulez faire, il existe toujours un moyen plus simple avec GetX. Cela économisera des heures de développement et fournira les performances maximales que votre application peut offrir.

    En règle générale, le développeur doit s'occuper lui-même de la suppression des contrôleurs de la mémoire. Avec GetX, cela n'est pas nécessaire car les ressources sont, par défaut, supprimées de la mémoire lorsqu'elles ne sont pas utilisées. Si vous souhaitez les conserver en mémoire, vous devez déclarer explicitement "permanent: true" comme paramètre lors de la création de la ressource. De cette façon, en plus de gagner du temps, vous risquez moins d'avoir des ressources inutiles dans la mémoire. L'initialisation des ressources est également 'lazy' par défaut (i.e. se fait seulement lorsque la ressource est nécessaire).
    
  - **ORGANIZATION:** GetX permet le découplage total de la Vue (View), de la Logique de Présentation (Presentation Logic), de la Business Logic, de l'injection de dépendances (Dependency Injection) et de la Navigation. Vous n'avez pas besoin de contexte pour naviguer entre les routes, vous n'êtes donc pas dépendant de la hiérarchisation des widgets (visualisation) pour cela. Vous n'avez pas besoin de 'context' pour accéder à vos contrôleurs/blocs via un inheritedWidget, vous dissociez donc complètement votre logique de présentation (Vue) et votre Business logic de votre couche de visualisation. Vous n'avez pas besoin d'injecter vos classes Controlleûrs / Modèles / Blocs le long de la hiérarchie de Widgets via `MultiProvider`. Pour cela, GetX utilise sa propre fonction d'injection de dépendances (DI), découplant complètement la DI de sa Vue.
  
    Avec GetX, vous savez où trouver chaque module de votre application, avec un code propre par défaut. En plus de rendre la maintenance facile, cela rend le partage de modules quelque chose qui jusque-là dans Flutter était impensable, quelque chose de totalement possible.
    BLoC était un point de départ pour organiser le code dans Flutter, il sépare la Business logic de la visualisation. GetX en est une évolution naturelle, séparant non seulement la Business logic mais aussi la logique de présentation. L'injection de dépendances et les routes sont également découplées, et la couche de données est séparée du tout. Vous savez où tout se trouve, et tout cela d'une manière plus facile que de construire un 'Hello World''.
    GetX est le moyen le plus simple, pratique et évolutif de créer des applications hautes performances avec le SDK Flutter. Il possède un vaste écosystème qui fonctionne parfaitement, c'est facile pour les débutants et précis pour les experts. Il est sécurisé, stable, à jour et offre une vaste gamme d'API intégrées qui ne sont pas présentes dans le SDK Flutter par défaut.
    
- GetX possède une multitude de fonctionnalités qui vous permettent de démarrer la programmation sans vous soucier de quoi que ce soit, mais chacune de ces fonctionnalités se trouve dans des conteneurs séparés et ne démarre qu'après utilisation. Si vous n'utilisez que la gestion des états (State Management), seule la gestion des états sera compilée. Si vous n'utilisez que des routes, rien de la gestion d'état ne sera compilé.

- GetX a un énorme écosystème, une grande communauté, un grand nombre de collaborateurs, et sera maintenu tant que Flutter existera. GetX est également capable de fonctionner avec le même code sur Android, iOS, Web, Mac, Linux, Windows et sur votre serveur. Il est possible de réutiliser entièrement votre code créé sur le frontend et le backend avec Get Server.
  **Il est possible d'entièrement réutiliser votre code écrit sur le frontend, pour le backend avec [Get Server](https://github.com/jonataslaw/get_server)**.

**De plus, l'ensemble du processus de développement peut être complètement automatisé, à la fois sur le serveur et sur le front-end avec [Get CLI](https://github.com/jonataslaw/get_cli)**.

**De plus, pour augmenter encore votre productivité, nous avons l'[extension pour VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) et l'[extension pour Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# Installation

Ajoutez Get à votre fichier pubspec.yaml:

```yaml
dependencies:
  get:
```

Importez Get dans les fichiers dans lesquels il doit être utilisé:

```dart
import 'package:get/get.dart';
```

# Application Counter avec Getx

Le projet "Counter" créé par défaut sur chaque nouveau projet Flutter comporte plus de 100 lignes (avec commentaires). Pour montrer la puissance de Get, je vais vous montrer comment faire un "compteur" changeant d'état à chaque clic, naviguer entre les pages et partager l'état entre les écrans, le tout de manière organisée, en séparant la Business logic de la Vue, en SEULEMENT 26 LIGNES DE CODE INCLUANT LES COMMENTAIRES.
- Step 1:
  Ajoutez "Get" avant MaterialApp, pour le transformer en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Note: cela ne modifie pas le MaterialApp de Flutter, GetMaterialApp n'est pas un MaterialApp modifié, il s'agit simplement d'un widget préconfiguré, qui a le MaterialApp par défaut comme enfant (child: ). Vous pouvez le configurer manuellement, mais ce n'est certainement pas nécessaire. GetMaterialApp créera des routes, les injectera, injectera les traductions, injectera tout ce dont vous avez besoin pour la navigation de routes. Si vous utilisez Get uniquement pour la gestion de l'état (State management) ou la gestion des dépendances (DI), il n'est pas nécessaire d'utiliser GetMaterialApp. GetMaterialApp est nécessaire pour les routes, les 'snackbars', l'internationalisation, les 'bottomSheets', les dialogues et les API de haut niveau liés aux routes et à l'absence de 'context'.

- Note²: Cette étape n'est nécessaire que si vous allez utiliser la gestion de routes (Get.to(), Get.back(), etc). Si vous ne l'utiliserez pas, il n'est pas nécessaire de faire l'étape 1.

- Step 2:
  Créez votre classe de Business logic et placez-y toutes les variables, méthodes et contrôleurs.
    Vous pouvez rendre toute variable observable en utilisant un simple ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Step 3:
  Créez votre Vue, utilisez StatelessWidget et économisez de la RAM, avec Get, vous n'aurez peut-être plus besoin d'utiliser StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instanciez votre classe en utilisant Get.put() pour le rendre disponible pour tous les routes "descendantes".
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Utilisez Obx(()=> pour mettre à jour Text() chaque fois que count est changé.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Remplacez les 8 lignes Navigator.push par un simple Get.to(). Vous n'avez pas besoin de 'context'
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // Vous pouvez demander à Get de trouver un contrôleur utilisé par une autre page et de vous y rediriger.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Accéder à la variable 'count' qui est mise à jour
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Résultat:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

C'est un projet simple mais il montre déjà à quel point Get est puissant. Au fur et à mesure que votre projet se développe, cette différence deviendra plus significative.

Get a été conçu pour fonctionner avec des équipes, mais il simplifie le travail d'un développeur individuel.

Améliorez vos délais, livrez tout à temps sans perte de performances. Get n'est pas pour tout le monde, mais si vous vous êtes identifié à cette phrase, Get est fait pour vous!

# Les trois pilliers

## Gestion d Etat

Get a deux gestionnaires d'état différents: le gestionnaire d'état simple (nous l'appellerons GetBuilder) et le gestionnaire d'état réactif (GetX / Obx).

### Gestionnaire d Etat Reactif

La programmation réactive peut aliéner de nombreuses personnes car on dit qu'elle est compliquée. GetX fait de la programmation réactive quelque chose d'assez simple:

- Vous n'aurez pas besoin de créer des StreamControllers.
- Vous n'aurez pas besoin de créer un StreamBuilder pour chaque variable
- Vous n'aurez pas besoin de créer une classe pour chaque état.
- Vous n'aurez pas besoin de créer un 'get' pour une valeur initiale.
- Vous n'aurez pas besoin d'utiliser des générateurs de code

La programmation réactive avec Get est aussi simple que d'utiliser setState.

Imaginons que vous ayez une variable 'name' et que vous souhaitiez que chaque fois que vous la modifiez, tous les widgets qui l'utilisent soient automatiquement modifiés.

Voici votre variable:

```dart
var name = 'Jonatas Borges';
```

Pour la rendre observable, il vous suffit d'ajouter ".obs" à la fin:

```dart
var name = 'Jonatas Borges'.obs;
```

Et dans l'interface utilisateur, lorsque vous souhaitez afficher cette valeur et mettre à jour l'écran chaque fois qu'elle change, faites simplement:

```dart
Obx(() => Text("${controller.name}"));
```

C'est _tout_. Si simple que ca.

### Plus de details sur la gestion d Etat 

**Lire une explication plus approfondie de la gestion d'état [ici](./documentation/fr_FR/state_management.md). Là-bas, vous verrez plus d'exemples surtout pour la différence entre le gestionnaire d'état simple et le gestionnaire d'état réactif.**

Vous pourrez vous faire une meilleure idée de la puissance de GetX.

## Gestion de route

Si vous envisagez d'utiliser des routes/snackbars/dialogs/bottomsheets sans 'context', GetX est également excellent pour vous, voyez par vous-même:

Ajoutez "Get" avant votre MaterialApp, en le transformant en GetMaterialApp

```dart
GetMaterialApp( // Avant: MaterialApp(
  home: MyHome(),
)
```

Accédez à un nouvel écran:

```dart

Get.to(ÉcranSuivant());
```

Accédez au nouvel écran par le nom. Voir plus de détails sur les itinéraires nommés (named routes) [ici](./documentation/fr_FR/route_management.md#navigation-avec-des-itinraires-nomms)

```dart

Get.toNamed('/details');
```

Pour fermer des snackbars, dialogs, bottomsheets, ou tout ce que vous auriez normalement fermé avec Navigator.pop(context);

```dart
Get.back();
```

Pour aller à l'écran suivant avec aucune option pour revenir à l'écran précédent (pour une utilisation dans SplashScreens, écrans de connexion, etc.)

```dart
Get.off(NextScreen());
```

Pour aller à l'écran suivant et annuler tous les itinéraires précédents (utile dans les paniers d'achat en ligne, les sondages et les tests)

```dart
Get.offAll(NextScreen());
```

Avez-vous remarqué que vous n'avez eu besoin d'utiliser 'context' pour aucune de ces opérations? C'est l'un des plus grands avantages de l'utilisation de la gestion de route avec Get. Avec cela, vous pouvez appeler toutes ces méthodes à partir de votre classe de contrôleur, sans soucis.

### Plus de details sur la gestion de route

**Get fonctionne avec des itinéraires nommés (named routes) et offre également un contrôle plus granulaire de vos routes! Il y a une documentation approfondie [ici](./documentation/fr_FR/route_management.md)**

## Gestion des dependances

Get a un gestionnaire de dépendances (dependency manager) simple et puissant qui vous permet de récupérer la même classe que votre Bloc ou Controller avec seulement 1 ligne de code, pas de 'context' Provider, pas d'inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Au lieu de Controller controller = Controller();
```

- Remarque: Si vous utilisez le gestionnaire d'état de Get, accordez plus d'attention à l'API 'Bindings', qui facilitera la connexion de vos Vues à vos contrôleurs.

Au lieu d'instancier votre classe dans la classe que vous utilisez, vous l'instanciez dans l'instance Get, ce qui la rendra disponible dans toute votre application.
Vous pouvez donc utiliser votre contrôleur (ou classe Bloc) normalement.

**Conseil:** La gestion des dépendances est découplée des autres parties du package, donc si, par exemple, votre application utilise déjà un gestionnaire d'état (n'importe lequel, peu importe), vous n'avez pas besoin de tout réécrire, vous pouvez l'utiliser avec l'injection de dépendance de Get sans aucun problème.

```dart
controller.fetchApi();
```

Imaginez que vous ayez parcouru de nombreuses routes et que vous ayez besoin de données qui ont été laissées dans votre contrôleur, vous auriez besoin d'un gestionnaire d'état combiné avec le 'Provider' ou 'Get_it', n'est-ce pas? Pas avec Get. Il vous suffit de demander à Get de "trouver" votre contrôleur, vous n'avez pas besoin de dépendances supplémentaires:
```dart
Controller controller = Get.find();
//Oui, cela ressemble à de la magie. Get trouvera votre contrôleur et vous le livrera. Vous pouvez avoir 1 million de contrôleurs instanciés, Get vous retournera toujours le bon contrôleur.
```

Et puis vous pourrez récupérer les données de votre contrôleur obtenu précédemment:

```dart
Text(controller.textFromApi);
```

### Plus de details sur la gestion des dependances

**Trouvez une explication plus détaillée sur la gestion des dépendances [ici](./documentation/fr_FR/dependency_management.md)**

# Utils

## Internationalization

### Traductions

Les traductions sont enregistrées sous forme de dictionaire clé-valeur simple.
Pour ajouter des traductions, créez une classe qui 'extend' `Translations`.

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

Ajouter juste `.tr` à la clé et elle sera traduite selon la valeur actuelle `Get.locale` et de `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Utiliser les traductions avec le singulier et le pluriel

```dart
var products = [];
Text('cléAuSingulier'.trPlural('cléAuPluriel', products.length, Args));
```

#### Utiliser les traductions avec paramètres

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

'Locales' signifie lieux.
Pour definir les traductions, passer les paramètres 'locale' et 'translations' à GetMaterialApp. 

```dart
return GetMaterialApp(
    translations: Messages(), // Vos traductions
    locale: Locale('en', 'US'), // Les traductions seront faites dans cette 'locale' (langue)
    fallbackLocale: Locale('en', 'UK'), // definit le 'language de secours' au cas oú un language invalide est sélectionné.
);
```

#### Changer la locale

Appelez `Get.updateLocale (locale)` pour mettre à jour la locale. Les traductions utilisent alors automatiquement la nouvelle langue.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Locale du systeme

Pour lire les paramètres régionaux ('locales') du système, vous pouvez utiliser `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Changer le Theme

Veuillez ne pas utiliser de widget de niveau supérieur à `GetMaterialApp` pour le mettre à jour. Cela peut créer des clés ('keys') en double. Beaucoup de gens sont habitués à l'approche préhistorique de la création d'un widget "ThemeProvider" juste pour changer le thème de votre application, et ce n'est certainement PAS nécessaire avec **GetX ™**.

Vous pouvez créer votre thème personnalisé et l'ajouter simplement dans `Get.changeTheme` sans aucune préconfiguration pour cela:

```dart
Get.changeTheme(ThemeData.light());
```

Si vous voulez créer quelque chose comme un bouton qui change le thème dans `onTap`, vous pouvez combiner deux API **GetX ™** pour cela:

- L'API qui vérifie si le "Thème" sombre est utilisé.
- Et l'API de changement de thème, vous pouvez simplement le mettre dans un 'onPressed':

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Lorsque 'onPressed' est appelé, si `.darkmode` est activé, il passera au _thème clair_, et lorsque le _thème clair_ est actif, il passera au _thème sombre_.

## GetConnect

GetConnect est un moyen facile de communiquer de votre backend à votre frontend avec http ou websockets.

### Configuration par defaut

Vous pouvez simplement 'extends' GetConnect et utiliser les méthodes GET / POST / PUT / DELETE / SOCKET pour communiquer avec votre API Rest ou vos websockets.

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

### Configuration personnalisee


GetConnect est hautement personnalisable. Vous pouvez définir l'URL de base, comme modificateurs de réponse, comme modificateurs de requêtes, définir un authentificateur, et même le nombre de tentatives oú il tentera de s'authentifier, en plus de donner la possibilité de définir un décodeur standard qui transformera toutes vos Requêtes dans vos Modèles sans aucune configuration supplémentaire.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // Toute 'Request' passera à jsonEncode donc CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; 
    // Il définit baseUrl pour Http et websockets si utilisé sans instance [httpClient]

    // Cela attachera la propriété 'apikey' sur l'en-tête ('header') de toutes les 'request's
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Même si le serveur envoie des données avec le pays "Brésil",
    // cela ne sera jamais affiché aux utilisateurs, car vous supprimez
    // ces données de la réponse, même avant que la réponse ne soit délivrée
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazil');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Définit l'en-tête
      request.headers['Authorization'] = "$token";
      return request;
    });

    // L'Autenticator sera appelé 3 fois si HttpStatus est HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
  

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## Middleware GetPage

GetPage a maintenant une nouvelle propriété qui prend une liste de GetMiddleWare et les exécute dans l'ordre spécifique.

**Note**: Lorsque GetPage a un Middleware, tous les enfants de cette page auront automatiquement les mêmes middlewares.

### Priority

L'ordre des middlewares à exécuter peut être défini par la priorité dans GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

ces middlewares seront exécutés dans cet ordre **-8 => 2 => 4 => 5**

### Redirect
    
    Cette fonction sera appelée lors de la recherche de la page de l'itinéraire appelé. Elle reçoit RouteSettings comme résultat vers oú rediriger. Sinon donnez-lui la valeur null et il n'y aura pas de redirection.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login');
}
```

### onPageCalled

Cette fonction sera appelée lorsque cette page sera appelée.
Vous pouvez l'utiliser pour changer quelque chose sur la page ou lui donner une nouvelle page.

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Cette fonction sera appelée juste avant l'initialisation des liaisons ('bidings').
Ici, vous pouvez modifier les liaisons de cette page.

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

Cette fonction sera appelée juste après l'initialisation des liaisons ('bidings').
Ici, vous pouvez faire quelque chose après avoir créé les liaisons et avant de créer le widget de page.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('les liaisons sont prêtes');
  return page;
}
```

### OnPageBuilt
Cette fonction sera appelée juste après l'appel de la fonction GetPage.page et vous donnera le résultat de la fonction et prendra le widget qui sera affiché.

### OnPageDispose

Cette fonction sera appelée juste après avoir disposé tous les objets associés (contrôleurs, vues, ...) à la page.

## Autres APIs

```dart
// donne les arguments actuels de currentScreen
Get.arguments

// donne le nom de l'itinéraire précédent
Get.previousRoute

// donne la route brute d'accès par exemple, rawRoute.isFirst()
Get.rawRoute

// donne accès à l'API de routing de GetObserver
Get.routing

// vérifier si le snackbar est ouvert
Get.isSnackbarOpen

// vérifier si la boîte de dialogue est ouverte
Get.isDialogOpen

// vérifie si la bottomSheet est ouverte
Get.isBottomSheetOpen

// supprime une route.
Get.removeRoute()

// retourne à plusieurs reprises jusqu'à ce que le prédicat retourne 'true'.
Get.until()

// passe à la route suivante et supprime toutes les routes précédentes jusqu'à ce que le prédicat retourne 'true'.
Get.offUntil()

// passe à la route nommée suivante et supprime toutes les routes précédentes jusqu'à ce que le prédicat retourne 'true'.
Get.offNamedUntil()

// Vérifie sur quelle plate-forme l'application s'exécute
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// Vérifie le type d'appareil
GetPlatform.isMobile
GetPlatform.isDesktop
// Toutes les plates-formes sont prises en charge indépendamment, dans le Web!
// Vous pouvez dire si vous utilisez un navigateur
// sur Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Équivaut à: MediaQuery.of(context).size.height,
// mais immuable.
Get.height
Get.width

// Donne le 'context' actuel de 'Navigator'.
Get.context

// Donne le contexte du snackbar / dialogue / bottomsheet au premier plan, n'importe où dans votre code.
Get.contextOverlay

// Remarque: les méthodes suivantes sont des extensions sur le 'context'. Puisque vous
// avez accès au contexte à n'importe quel endroit de votre interface utilisateur, vous pouvez l'utiliser n'importe où dans le code de l'interface utilisateur

// Si vous avez besoin d'une hauteur / largeur variable (comme les fenêtres de bureau ou de navigateur qui peuvent être mises à l'échelle), vous devrez utiliser le contexte.
context.width
context.height

// Vous donne le pouvoir de définir la moitié de l'écran, un tiers de celui-ci et ainsi de suite.
// Utile pour les applications responsives.
// paramètre dividedBy (double) optionnel - par défaut: 1
// paramètre reducedBy (double) facultatif - par défaut: 0
context.heightTransformer ()
context.widthTransformer ()

/// Similaire à MediaQuery.of(context).size
context.mediaQuerySize()

/// Similaire à MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similaire à MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similaire à MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similaire à MediaQuery.of(context).orientation;
context.orientation()

/// Vérifie si l'appareil est en mode paysage
context.isLandscape()

/// Vérifie si l'appareil est en mode portrait
context.isPortrait()

/// Similaire à MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similaire à MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Obtenir le côté le plus court de l'écran
context.mediaQueryShortestSide()

/// Vrai si la largeur est supérieure à 800p
context.showNavbar()

/// Vrai si le côté le plus court est inférieur à 600p
context.isPhone()

/// Vrai si le côté le plus court est plus grand que 600p
context.isSmallTablet()

/// Vrai si le côté le plus court est plus grand que 720p
context.isLargeTablet()

/// Vrai si l'appareil actuel est une tablette
context.isTablet()

/// Renvoie une valeur <T> en fonction de la taille de l'écran
/// peut donner une valeur pour:
/// watch: si le côté le plus court est inférieur à 300
/// mobile: si le côté le plus court est inférieur à 600
/// tablette: si le côté le plus court est inférieur à 1200
/// bureautique: si la largeur est supérieure à 1200
context.responsiveValue<T>()
```

### Parametres globaux et configurations manuelles facultatifs

GetMaterialApp configure tout pour vous, mais si vous souhaitez configurer Get manuellement:

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

Vous pourrez également utiliser votre propre middleware dans `GetObserver`, cela n'influencera rien.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Ici
  ],
);
```

Vous pouvez créer _Global Settings_ pour `Get`. Ajoutez simplement `Get.config` à votre code avant de changer de route.
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

Vous pouvez éventuellement rediriger tous les messages de journalisation (logging) de `Get`.
Si vous souhaitez utiliser votre propre package de journalisation préféré,
et souhaitez capturer les logs là-bas:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // transmettez le message à votre package de journalisation préféré ici
  // veuillez noter que même si enableLog: false, les messages du journal seront poussés dans ce 'callback'
  // vérifiez le 'flag' si vous le souhaitez via GetConfig.isLogEnable
}

```

### State Widgets Locaux

Ces Widgets vous permettent de gérer une valeur unique, et de garder l'état éphémère et localement.
Nous avons des saveurs pour réactif et simple.
Par exemple, vous pouvez les utiliser pour basculer obscureText dans un `TextField`, peut-être créer un
Panneau extensible, ou peut-être modifier l'index actuel dans `BottomNavigationBar` tout en modifiant le contenu
de 'body' dans un `Scaffold`.

#### ValueBuilder

Une simplification de `StatefulWidget` qui fonctionne avec un callback `.setState` qui prend la valeur mise à jour.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // même signature! vous pouvez utiliser (newValue) => updateFn (newValue)
  ),
  // si vous devez appeler quelque chose en dehors de la méthode du builder.
  onUpdate: (value) => print("Valeur mise à jour: $value"),
  onDispose: () => print("Widget détruit"),
),
```

#### ObxValue

Similaire à [`ValueBuilder`](#valuebuilder), mais c'est la version Reactive, vous passez une instance Rx (rappelez-vous les .obs magiques?) et il
 se met à jour automatiquement ... n'est-ce pas génial?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx a une fonction _callable_! Vous pouvez utiliser (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Conseils utiles

`.obs`ervables (également appelés types _Rx_) ont une grande variété de méthodes et d'opérateurs internes.

> Il est très courant de croire qu'une propriété avec `.obs` ** EST ** la valeur réelle ... mais ne vous y trompez pas!
> Nous évitons la déclaration Type de la variable, car le compilateur de Dart est assez intelligent, et le code
> semble plus propre, mais:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" est de Type ${message.runtimeType}');
```

Bien que `message` _prints_ la vraie valeur du String, le Type est **RxString**!

Donc, vous ne pouvez pas faire `message.substring( 0, 4 )`.
Vous devez utiliser la vraie `valeur` dans _observable_:
La façon "la plus utilisée" est `.value`, mais, que vous pouviez aussi...

```dart
final name = 'GetX'.obs;
// "met à jour" le flux, uniquement si la valeur est différente de la valeur actuelle.
name.value = 'Hey';

// Toutes les propriétés Rx sont "appelables" et renvoie la nouvelle valeur.
// mais cette approche n'accepte pas `null`, l'interface utilisateur ne sera pas reconstruite.
name('Hello');

// est comme un getter, affiche `Hello`.
name() ;

/// nombres:

final count = 0.obs;

// Vous pouvez utiliser toutes les opérations non mutables à partir de num primitives!
count + 1;

// Fais attention! ceci n'est valable que si `count` n'est pas final, mais var
count += 1;

// Vous pouvez également comparer avec des valeurs:
count > 2;

/// booleans:

final flag = false.obs;

// bascule la valeur entre true / false
flag.toggle();


/// tous les types:

// Définit la `valeur` sur null.
flag.nil();

// Toutes les opérations toString (), toJson () sont transmises à la `valeur`
print( count ); // appelle `toString ()` à l'intérieur de RxInt

final abc = [0,1,2].obs;
// Convertit la valeur en un Array json, affiche RxList
// Json est pris en charge par tous les types Rx!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList et RxSet sont des types Rx spéciaux, qui étendent leurs types natifs.
// mais vous pouvez travailler avec une liste comme une liste régulière, bien qu'elle soit réactive!
abc.add(12); // pousse 12 dans la liste et MET À JOUR le flux.
abc[3]; // comme Lists, lit l'index 3.


// l'égalité fonctionne avec le Rx et la valeur, mais hashCode est toujours pris à partir de la valeur
final number = 12.obs;
print( number == 12 ); // retource > true

/// Modèles Rx personnalisés:

// toJson (), toString () sont différés à l'enfant, vous pouvez donc implémenter 'override' sur eux, et print() l'observable directement.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age ans';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` est" réactif ", mais les propriétés à l'intérieur NE SONT PAS!
// Donc, si nous changeons une variable à l'intérieur ...
user.value.name = 'Roi';
// Le widget ne se reconstruira pas !,
// `Rx` n'a aucun indice lorsque vous changez quelque chose à l'intérieur de l'utilisateur.
// Donc, pour les classes personnalisées, nous devons "notifier" manuellement le changement.
user.refresh();

// ou utiliser `update()`!
user.update((value){
  value.name='Roi';
});

print( user );
```

#### GetView

J'adore ce widget. Si simple, mais si utile!

C'est un widget `const Stateless` qui a un getter` controller` pour un `Controller` enregistré, c'est tout.

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // N'oubliez PAS de passer le `Type` que vous avez utilisé pour enregistrer votre contrôleur!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // appelez `controller.quelqueChose`
     );
   }
 }
```

#### GetResponsiveView

Étendez ce widget pour créer une vue réactive.
ce widget contient la propriété `screen` qui a toutes les
informations sur la taille et le type de l'écran.

##### Guide d utilisation

Vous avez deux options pour le créer:

- avec la méthode `builder` vous renvoyez le widget à construire.
- avec les méthodes `desktop`,` tablet`, `phone`,` watch`. la méthode spécifique sera exécutée lorsque le type d'écran correspond à la méthode.
  Lorsque l'écran est [ScreenType.Tablet], la méthode `tablet` sera exécutée et ainsi de suite.
  **Note:** Si vous utilisez cette méthode, veuillez définir la propriété `alwaysUseBuilder` à `false`

Avec la propriété `settings`, vous pouvez définir la limite de largeur pour les types d'écran.

![exemple](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code pour cet écran
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

La plupart des gens n'ont aucune idée de ce widget ou confondent totalement son utilisation.
Le cas d'utilisation est très rare, mais très spécifique: il `met en cache` un contrôleur.
En raison du _cache_, ne peut pas être un `const Stateless`.

> Alors, quand avez-vous besoin de "mettre en cache" un contrôleur?

Si vous utilisez, une autre fonctionnalité "pas si courante" de **GetX**: `Get.create()`.

`Get.create(()=>Controller())` générera un nouveau `Controller` chaque fois que vous appelez
`Get.find<Controller>()`.

C'est là que `GetWidget` brille ... comme vous pouvez l'utiliser, par exemple,
pour conserver une liste de <Todo>s. Donc, si le widget est "reconstruit", il conservera la même instance de contrôleur.

#### GetxService

Cette classe est comme un `GetxController`, elle partage le même cycle de vie ( `onInit()`, `onReady()`, `onClose()`), mais n'a pas de "logique" en elle. 
Il notifie simplement le **GetX** Dependency Injection system, que cette sous-classe
**ne peut pas** être supprimé de la mémoire.

Donc est très utile pour garder vos "Services" toujours à portée de main et actifs avec `Get.find()`. Comme:
`ServiceAPI`, `ServiceDeSauvegarde`, `ServiceDeCaching`.

```dart
Future<void> main() async {
  await initServices(); /// Attend l'initialisation des services.
  runApp(SomeApp());
}

/// Est une démarche intelligente pour que vos services s'initialisent avant d'exécuter l'application Flutter.
/// car vous pouvez contrôler le flux d'exécution (peut-être devez-vous charger une configuration de thème,
/// apiKey, langue définie par l'utilisateur ... donc chargez SettingService avant d'exécuter ApiService.
/// donc GetMaterialApp () n'a pas besoin de se reconstruire et prend les valeurs directement.
void initServices() async {
  print('starting services ...');
  /// C'est ici que vous mettez get_storage, hive, shared_pref initialization.
  /// ou les connexions moor, ou autres choses async.
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(SettingsService()).init();
  print('Tous les services ont démarré...');
}

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType retarde de 2 sec');
    await 2.delay();
    print('$runtimeType prêts!');
    return this;
  }
}

class SettingsService extends GetxService {
  void init() async {
    print("$runtimeType retarde d'1 sec");
    await 1.delay();
    print('$runtimeType prêts!');
  }
}

```

La seule façon de supprimer réellement un `GetxService`, est d'utiliser` Get.reset () `qui est comme un
"Hot Reboot" de votre application. N'oubliez donc pas que si vous avez besoin d'une persistance absolue d'une instance de classe
durée de vie de votre application, utilisez `GetxService`.

# Changements par rapport a 2.0

1- Types Rx:

| Avant   | Après      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController et GetBuilder ont maintenant fusionné, vous n'avez plus besoin de mémoriser le contrôleur que vous souhaitez utiliser, utilisez simplement GetxController, cela fonctionnera pour une gestion simple de l'état et également pour la réactivité.


2- NamedRoutes

Avant:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Maintenant:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

Pourquoi ce changement?
Souvent, il peut être nécessaire de décider quelle page sera affichée à partir d'un paramètre, ou d'un 'login token', l'approche précédente était inflexible, car elle ne le permettait pas.
L'insertion de la page dans une fonction a considérablement réduit la consommation de RAM, puisque les routes ne seront pas allouées en mémoire depuis le démarrage de l'application, et cela a également permis de faire ce type d'approche:
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

# Pourquoi Getx?

1- Plusieurs fois après une mise à jour de Flutter, plusieurs de vos packages seront invalides. Parfois, des erreurs de compilation se produisent, des erreurs apparaissent souvent pour lesquelles il n'y a toujours pas de réponses, et le développeur doit savoir d'où vient l'erreur, suivre l'erreur, puis seulement essayer d'ouvrir un problème dans le référentiel correspondant et voir son problème résolu. Get centralise les principales ressources pour le développement (gestion des états, des dépendances et des routes), vous permettant d'ajouter un package unique à votre pubspec et de commencer à travailler. Après une mise à jour Flutter, la seule chose à faire est de mettre à jour la dépendance Get et de vous mettre au travail. Get résout également les problèmes de compatibilité. Combien de fois une version d'un package n'est pas compatible avec la version d'un autre, parce que l'une utilise une dépendance dans une version et l'autre dans une autre version? Ce n'est pas non plus un problème avec Get, car tout est dans le même package et est entièrement compatible.

2- Flutter est facile, Flutter est incroyable, mais Flutter a encore quelques règles standard qui peuvent être indésirables pour la plupart des développeurs, comme `Navigator.of (context) .push (context, builder [...]`. Get simplifie le développement. Au lieu de écrire 8 lignes de code pour simplement appeler une route, vous pouvez simplement le faire: `Get.to (Home ())` et vous avez terminé, vous passerez à la page suivante. Les URL Web dynamiques sont une chose vraiment pénible à voir avec Flutter actuellement, et cela avec GetX est stupidement simple. La gestion des états dans Flutter et la gestion des dépendances sont également quelque chose qui génère beaucoup de discussions, car il y a des centaines de modèles dans la pub. Mais rien n'est aussi simple que d'ajouter un ".obs" à la fin de votre variable, et placez votre widget dans un Obx, et c'est tout, toutes les mises à jour de cette variable seront automatiquement mises à jour à l'écran.

3- Facilité sans vous soucier des performances. Les performances de Flutter sont déjà étonnantes, mais imaginez que vous utilisez un gestionnaire d'état et un localisateur pour distribuer vos classes blocs / stores / contrôleurs / etc. Vous devrez appeler manuellement l'exclusion de cette dépendance lorsque vous n'en avez pas besoin. Mais avez-vous déjà pensé à simplement utiliser votre «contrôleur`, et quand il n'était plus utilisé par personne, il serait simplement supprimé de la mémoire? C'est ce que fait GetX. Avec SmartManagement, tout ce qui n'est pas utilisé est supprimé de la mémoire et vous ne devriez pas avoir à vous soucier d'autre chose que de la programmation. Vous serez assuré de consommer le minimum de ressources nécessaires, sans même avoir créé de logique pour cela.

4- Découplage réel. Vous avez peut-être entendu le concept "séparer la vue de la business logic". Ce n'est pas une particularité de BLoC, MVC, MVVM, et tout autre standard sur le marché a ce concept. Cependant, ce concept peut souvent être atténué dans Flutter en raison de l'utilisation de `context`.
   Si vous avez besoin de contexte pour trouver un InheritedWidget, vous en avez besoin dans la vue, ou passez le `context` par paramètre. Je trouve particulièrement cette solution très moche, et pour travailler en équipe, nous serons toujours dépendants de la 'business logic' de View. Getx n'est pas orthodoxe avec l'approche standard, et même s'il n'interdit pas complètement l'utilisation de StatefulWidgets, InitState, etc., il a toujours une approche similaire qui peut être plus propre. Les contrôleurs ont des cycles de vie, et lorsque vous devez faire une requête APIREST par exemple, vous ne dépendez de rien de la vue. Vous pouvez utiliser onInit pour lancer l'appel http et lorsque les données arrivent, les variables sont remplies. Comme GetX est totalement réactif (vraiment, et fonctionne sous streams), une fois les éléments remplis, tous les widgets qui utilisent cette variable seront automatiquement mis à jour dans la vue.
   Cela permet aux personnes ayant une expertise de l'interface utilisateur de travailler uniquement avec des widgets et de ne pas avoir à envoyer quoi que ce soit à la business logic autre que des événements utilisateur (comme cliquer sur un bouton), tandis que les personnes travaillant avec la business logic seront libres de créer et de tester la Business logic séparément.


# Communite

## Chaines communautaires

GetX a une communauté très active et utile. Si vous avez des questions, ou souhaitez obtenir de l'aide concernant l'utilisation de ce framework, veuillez rejoindre nos canaux communautaires, votre question sera répondue plus rapidement, et ce sera l'endroit le plus approprié. Ce référentiel est exclusif pour l'ouverture des issues Github et la demande de ressources, mais n'hésitez pas à faire partie de la communauté GetX.
| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get sur Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Comment contribuer

_Voulez-vous contribuer au projet? Nous serons fiers de vous mettre en avant comme l'un de nos collaborateurs. Voici quelques points sur lesquels vous pouvez contribuer et améliorer encore Get (et Flutter)._

- Aider à traduire les 'Readme's dans d'autres langues.
- Ajout de documentation au readme (beaucoup de fonctions de Get n'ont pas encore été documentées).
- Rédiger des articles ou réaliser des vidéos pour apprendre à utiliser Get (ils seront insérés dans le Readme et à l'avenir dans notre Wiki).
- Offrir des PRs pour code / tests.
- Ajouter de nouvelles fonctions.

Toute contribution est bienvenue!

## Articles et videos

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
