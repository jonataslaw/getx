<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" align="right" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
![](get.png)

*Languages: [English](README.md), [Brazilian Portuguese](README.pt-br.md), [Polish]().*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get) 
![building](https://github.com/jonataslaw/get/workflows/Test,%20build%20and%20deploy/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

Gry jest bardzo lekką i potężną biblioteką do Flattera, która da Ci supermoce i zwiększy produktywność w tworzeniu projektu. Nawiguj bez podawania kontekstu, używaj open dialogów, snackbarów oraz bottomsheetów z każdego miejsca w kodzie. Zarządzaj stanami i dodawaj dependencies w prosty i praktyczny sposób! Get jest bezpieczny, stabilny i aktualny. Oprócz tego oferuje szeroki zakres API, które nie są zawarte w standardowym frameworku.

## Wprowadzenie

Konwencjonalna nawigacja we Flutterze posiada dużo niepotrzebnej obudowy wokół siebie. Takiej jak podawanie kontekstu. Do tego open dialogi oraz używanie snackbarów, co jest nudne i nużące. Ta biblioteką zmieni sposób w jaki pracujesz z Frameworkiem i oszczędzi Ci czas stracony na pisaniu niepotrzebnego kodu zwiększy to produktywność i zapewniając najnowsze podejście w temacie zarządzania stanami, ścieżkami i dependencies.
- **[Użycie](#wprowadzenie)**
- **[Nawigacja bez named routes](#nawigój-bez-named-routes)**
- **[SnackBars](#snackbars)**
- **[Dialogi](#dialogi)**
- **[BottomSheets]()**
- **[Prosty Menadżer Stanów]()**
- **[Reaktywny Menadżer Stanów]()**
- **[Przypisania]()**
- **[Workery]()**
- **[Nawigacja z named routes]()**
- **[Przekazywanie danych do named routes]()**
- **[Dynamiczne linki URL]()**
- **[Oprogramowanie pośrednie]()**
- **[Opcjonalne ustawienia globalne]()**
- **[Zagnieżdżone nawigatory]()**
- **[Inne zaawansowane API i manualne konfigurację]()**

Możesz uczestniczyć w rozwoju projektu na różny sposób:
- Pomagając w tłumaczeniu readme na inne języki.
- Dodając dokumentację do readme ( nawet nie połowa funkcji została jeszcze opisana).
- Pisząc artykuły i nagrywając filmy uczące użycia biblioteki Get (będą zamieszczone w readme, a w przyszłości na naszej Wiki).
- Oferując PR-y dla kodu i testów.
- Dodając nowe funkcje.

Każda współpraca jest mile widziana!

## Nawiguj bez named routes
By nawigować do nowego ekranu:

```dart
Get.to(NextScreen());
```

By powrócić do poprzedniego ekranu

```dart
Get.back();
```

By przejść do następnego ekranu bez możliwości powrotu do poprzedniego (do zastosowania SplashScreenów, ekranów logowania itd.)

```dart
Get.off(NextScreen());
```

By przejść do następnego ekranu niszcząc poprzednie routy (użyteczne w koszykach, ankietach i testach)

```dart
Get.offAll(NextScreen());
```

By nawigować do następnego routa i otrzymać, lub uaktualnić dane zaraz po tym jak z niego wrócisz:
```dart
var data = await Get.to(Payment());
```
w innym ekranie wyślij dane z poprzedniego routa:

```dart
Get.back(result: 'sucess');
```
I użyj następujące np.:
```dart
if(data == 'sucess') madeAnything();
```

Nie chcesz się uczyć naszej składni?
Wystarczy, że zmienisz 'Nawigator' (upercase) na 'navigator' (lowercase), a będziesz mieć wszystkie funkcjonalności standardowej nawigacji, bez konieczności używania kontekstu.

Przykład:

```dart

// Standardowa nawigacja we Flatterze
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) { 
      return HomePage();
    },
  ),
);

// Zacznij używać Flatterowej składni bez podawania kontekstu
navigator.push(
  MaterialPageRoute(
    builder: (_) { 
      return HomePage();
    },
  ),
);

// Składnia Get (Jest lepsza, choć oczywiście każdy może mieć własne zdanie))
Get.to(HomePage());


```
### SnackBars

By wykorzystać SnackBar we Flatterze musisz podać context Scaffoldu, albo musisz użyć GlobalKey przypisanego do Scaffolda.
```dart
final snackBar = SnackBar(
  content: Text('Cześć!'),
  action: SnackBarAction(
    label: 'Jestem starym i brzydkim snackbarem :(',
    onPressed: (){}
  ),
);
// Znajdź Scaffold w drzewie widżetów i użyj
// go do pokazania SnackBara.
Scaffold.of(context).showSnackBar(snackBar);
```
Z wykorzystaniem Get:

```dart
Get.snackbar('Cześć!', 'Jestem nowoczesnym snackbar');
```
Z Get wszystko co musisz zrobić to wywołać swój Get.snackbar gdziekolwiek w swoim kodzie i dostosować go jak tylko chcesz!

```dart
Get.snackbar(
  "Hej, jestem Get Snackbar!", // title
  "Niewiarygodne! Używam SnackBara bez context, miepotrzebnego opakowania i Scaffoldu, jest to naprawdę niesamowite!", // message
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
Jeśli preferujesz tradycyjne snackbary, albo chcesz budować ją od zera dodając tylko jedną lineijkę kodu (Get.snackbar używa obowiązkowo title i message). Możesz użyć `Get.rawSnackbar();` który zapewnia surowe API, na którym zbudowany jest Get.snackbar.

### Dialogi

By otworzyć dialog:

```dart
Get.dialog(YourDialogWidget());
```

By otworzyć domyślny dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog stworzony w trzech linijkach kodu"
);
```

Możesz także użyć Get.generalDialog zamiast showGeneralDialog.

W przypadku wszystkich innych Flutterowych dialogog widżetów włączając cupertinowe możesz używać Get.overlayContext w zamian za context i otwierać go z każdego miejsca w kodzie.
Dla widżetów nieużywających Overlay możesz użyć Get.context.
Te dwa konteksty zadziałają w 99% przypadków, w których zastępujesz context UI, z wyłączeniem przypadków gdzie inheritedWidget jest używany w nawigacji bez kontekstu.

### BoottomSheets
Get.bottomSheet działa jak showModalBottomSheet, tylko bez użycia kontekstu.

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
## Simple State Menager
Obecnie istnieje kilka menadżeów dla Fluttera. Jednak większość z nich wymaga używania ChangeNotifier, po to aby zaktualizować widżety, co nie sprawdza się pod kątem wydajności w średnich i dużych aplikacach. Możesz sprawdzić w oficjalnej dokumentacji, że ChangeNotifier powinien być używany z maksimum dwoma listinerami (https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), będąc praktycznie bezużytecznym w średnich i duzych projektach. Inne menadzery są dobre, ale mają swoje mankamenty. BLoC jest bardzo bezpieczny i efektywny,ale ma wysoki próg wejścia dla początkujących, powstrzymywując wielu przed pisaniem we Flutterze. MobX jest prostrzy od BLoC i reaktywnny, powiedziałbym prawe perfekcyjny, tylko że musisz używać generatora kodu redukującego produktywność w dużych aplikacjach. W takim przypadku będziesz potrzebował hektolitrów kawy nim twój kod będzie działać po Flutterowym czyszczeniu (Nie jest toowina MobXa, ale codegen będący bardzo wolny). Provider używa InheritedWidget dostarczając ten sam listiner, jako sposób na problem z ChangeNotifier wyżej wymieniony. To skutkuje tym, że każdy dostęp do klasy ChangeNotifier musi być w tym samym drzewie widżetów, ze względu na kontekst uzyskujacy dostęp do Inherited.

Get nie jest ani lepszy, ani gorszy od innych menadżerów stanów, ale powinieneś rozpatrzyć te punkty jak i poniższe, aby wybrać między użyciem Get w czystej formie (Vanilla), albo używaniem go wraz z innym menadżerem. Definitywnie Get nie jest przeciwnikiem żadnego innego menadżera, ponieważ jest on mikroframeworkiem, nie tylko menadżerem stanu. Może być użyty samodzielnie, lub w koegzystencji.

Get ma bardzo lekki i prosty menadżer stanu (napisany w tylko 95 lini kodu), który nie używa ChangeNotifier. Sprosta on wymaganiom szczególnie nowych we Flutterze i nie sprawi problemu nawer w dużych aplikacjach.

Które ulepszenia wydajności zapewnia Get?

1- Aktualizowanie tylko niezbędnych widżetów,

linijka 300
