- [Navegação sem rotas nomeadas](#navegação-sem-rotas-nomeadas)
  - [SnackBars](#snackbars)
  - [Dialogs](#dialogs)
  - [BottomSheets](#bottomsheets)
- [Navegar com rotas nomeadas](#navegar-com-rotas-nomeadas)
  - [Enviar dados para rotas nomeadas](#enviar-dados-para-rotas-nomeadas)
    - [Links de Url dinâmicos](#links-de-url-dinâmicos)
    - [Middleware](#middleware)
  - [Change Theme](#change-theme)
  - [Configurações Globais Opcionais](#configurações-globais-opcionais)
  - [Nested Navigators](#nested-navigators)

## Navegação sem rotas nomeadas

Para navegar para uma próxima tela:

```dart
Get.to(ProximaTela());
```

Para fechar snackbars, dialogs, bottomsheets, ou qualquer coisa que você normalmente fecharia com o `Navigator.pop(context)` (como por exemplo fechar a View atual e voltar para a anterior):

```dart
Get.back();
```

Para ir para a próxima tela e NÃO deixar opção para voltar para a tela anterior (bom para SplashScreens, telas de login e etc.):

```dart
Get.off(ProximaTela());
```

Para ir para a próxima tela e cancelar todas as rotas anteriores (útil em telas de carrinho, votações ou testes):

```dart
Get.offAll(ProximaTela());
```

Para navegar para a próxima rota, e receber ou atualizar dados assim que retornar da rota:

```dart
var dados = await Get.to(Pagamento());
```

Na outra tela, envie os dados para a rota anterior:

```dart
Get.back(result: 'sucesso');
```

E use-os:

```dart
if (dados == 'sucesso') fazerQualquerCoisa();
```

Não quer aprender nossa sintaxe?
Apenas mude o `Navigator` (letra maiúscula) para `navigator` (letra minúscula), e você terá todas as funcionalidades de navegação padrão, sem precisar usar `context`

Exemplo:

```dart
// Navigator padrão do Flutter
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Get usando a sintaxe Flutter sem precisar do context
navigator.push(
  MaterialPageRoute(
      builder: (_) {
      return HomePage();
    },
  ),
);

// Sintaxe do Get (é bem melhor, mas você tem o direito de discordar)
Get.to(HomePage());
```

### SnackBars

Para ter um `SnackBar` simples no Flutter, você precisa do `context` do Scaffold, ou uma `GlobalKey` atrelada ao seu Scaffold.

```dart
final snackBar = SnackBar(
  content: Text('Olá!'),
  action: SnackBarAction(
    label: 'Eu sou uma SnackBar velha e feia :(',
    onPressed: (){}
  ),
);
// Encontra o Scaffold na árvore de Widgets e
// o usa para mostrar o SnackBar
Scaffold.of(context).showSnackBar(snackBar);
```

Com o Get:

```dart
Get.snackbar('Olá', 'eu sou uma SnackBar moderna e linda!');
```

Com Get, tudo que você precisa fazer é chamar `Get.snackbar()` de qualquer lugar no seu código, e/ou customizá-lo da forma que quiser!

```dart
Get.snackbar(
  "Ei, eu sou uma SnackBar Get!", // título
  "É inacreditável! Eu estou usando uma SnackBar sem context, sem boilerplate, sem Scaffold!", // mensagem
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// TODOS OS RECURSOS //////////
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

Se você prefere a SnackBar tradicional, ou quer customizar por completo, como por exemplo fazer ele ter uma só linha (`Get.snackbar` tem os parâmetros `title` e `message` obrigatórios), você pode usar `Get.rawSnackbar();` que fornece a API bruta na qual `Get.snackbar` foi contruído.

### Dialogs

Para abrir um dialog:

```dart
Get.dialog(SeuWidgetDialog());
```

Para abrir um dialog padrão:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code",
);
```

Você também pode usar `Get.generalDialog` em vez de `showGeneralDialog`.

Para todos os outros Widgets do tipo dialog do Flutter, incluindo os do Cupertino, você pode usar `Get.overlayContext` em vez do `context`, e abrir em qualquer lugar do seu código.

Para widgets que não usam `overlayContext`, você pode usar `Get.context`. Esses dois contextos vão funcionar em 99% dos casos para substituir o context da sua UI, exceto em casos onde o `inheritedWidget` é usado sem a navigation context.

### BottomSheets

`Get.bottomSheet()` é tipo o `showModalBottomSheet()`, mas não precisa do context.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Música'),
          onTap: () => {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Vídeo'),
          onTap: () => {},
        ),
      ],
    ),
  ),
);
```

## Navegar com rotas nomeadas

- Se você prefere navegar por rotas nomeadas, Get também dá suporte a isso:

Para navegar para uma nova tela

```dart
Get.toNamed("/ProximaTela");
```

Para navegar para uma tela sem a opção de voltar para a rota atual.

```dart
Get.offNamed("/ProximaTela");
```

Para navegar para uma nova tela e remover todas rotas anteriores da stack

```dart
Get.offAllNamed("/ProximaTela");
```

Para definir rotas, use o `GetMaterialApp`:

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/cadastro', page: () => Cadastro(), transition: Transition.cupertino),
      ]
    )
  );
}
```

### Enviar dados para rotas nomeadas

Apenas envie o que você quiser no parâmetro `arguments`. Get aceita qualquer coisa aqui, seja String, Map, List, ou até a instância de uma classe.

```dart
Get.toNamed("/ProximaTela", arguments: 'Get é o melhor');
```

Na sua classe ou controller:

```dart
print(Get.arguments); //valor: Get é o melhor
```

#### Links de Url dinâmicos

Get oferece links de url dinâmicos assim como na Web.
Desenvolvedores Web provavelmente já queriam essa feature no Flutter, e muito provavelmente viram um package que promete essa feature mas entrega uma sintaxe totalmente diferente do que uma url teria na web, mas o Get também resolve isso.

```dart
Get.offAllNamed("/ProximaTela?device=phone&id=354&name=Enzo");
```

na sua classe controller/bloc/stateful/stateless:

```dart
print(Get.parameters['id']); // valor: 354
print(Get.parameters['name']); // valor: Enzo
```

Você também pode receber parâmetros nomeados com o Get facilmente:

```dart
void main() => runApp(
  GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => Home()),
      /// Importante! ':user' não é uma nova rota, é somente uma
      /// especificação do parâmentro. Não use '/segunda/:user/' e '/segunda'
      /// se você precisa de uma nova rota para o user, então
      /// use '/segunda/user/:user' se '/segunda' for uma rota
      GetPage(name: '/segunda/:user', page: () => Segunda()), // recebe a ID
      GetPage(name: '/terceira', page: () => Terceira(), transition: Transition.cupertino),
    ]
  ),
);
```

Envie dados na rota nomeada

```dart
Get.toNamed("/segunda/34954");
```

Na segunda tela receba os dados usando `Get.parameters[]`

```dart
print(Get.parameters['user']); // valor: 34954
```

E agora, tudo que você precisa fazer é usar `Get.toNamed)` para navegar por suas rotas nomeadas, sem nenhum `context` (você pode chamar suas rotas diretamente do seu BLoc ou do Controller), e quando seu aplicativo é compilado para a web, suas rotas vão aparecer na url ❤

#### Middleware

Se você quer escutar eventos do Get para ativar ações, você pode usar `routingCallback` para isso

```dart
GetMaterialApp(
  routingCallback: (route){
    if(routing.current == '/segunda'){
      openAds();
    }
  }
)
```

Se você não estiver usando o `GetMaterialApp`, você pode usar a API manual para anexar um observer Middleware.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // AQUI !!!
      ],
    )
  );
}
```

Criar uma classe MiddleWare

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Você pode escutar junto com as rotas, snackbars, dialogs
    /// e bottomsheets em cada tela.
    /// Se você precisar entrar em algum um desses 3 eventos aqui diretamente,
    /// você precisa especificar que o evento é != do que você está tentando fazer
    if (routing.current == '/segunda' && !routing.isSnackbar) {
      Get.snackbar("Olá", "Você está na segunda rota");
    } else if (routing.current =='/terceira'){
      print('última rota chamada');
    }
  }
}
```

Agora, use Get no seu código:

```dart
class Primeira extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("Oi", "eu sou uma snackbar moderna");
          },
        ),
        title: Text('Primeira rota'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Abrir rota'),
          onPressed: () {
            Get.toNamed("/segunda");
          },
        ),
      ),
    );
  }
}

class Segunda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("Oi", "eu sou uma snackbar moderna");
          },
        ),
        title: Text('Segunda rota'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Abrir rota'),
          onPressed: () {
            Get.toNamed("/terceira");
          },
        ),
      ),
    );
  }
}

class Terceira extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terceira Rota"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Voltar!'),
        ),
      ),
    );
  }
}
```

### Change Theme

Por favor não use nenhum widget acima do `GetMaterialApp` para atualizá-lo. Isso pode ativar keys duplicadas. Muitas pessoas estão acostumadas com a forma pré-história de criar um widget `ThemeProvider` só pra mudar o tema do seu app, e isso definitamente NÃO é necessário com o Get.

Você pode criar seu tema customizado e simplesmente adicionar ele dentro de `Get.changeTheme()` sem nenhum boilerplate para isso:

```dart
Get.changeTheme(ThemeData.light());
```

Se você quer criar algo como um botão que muda o tema com um toque, você pode combinar duas APIs do Get para isso, a API que checa se o tema dark está sendo usado, e a API de mudança de tema. E dentro de um `onPressed` você coloca isso:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Quando o modo escuro está ativado, ele vai alterar para o modo claro, e vice versa.

Se você quer saber a fundo como mudar o tema, você pode seguir esse tutorial no Medium que até te ensina a persistir o tema usando Get e shared_preferences:

- [Dynamic Themes in 3 lines using Get](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).

### Configurações Globais Opcionais

Você pode mudar configurações globais para o Get. Apenas adicione `Get.config` no seu código antes de ir para qualquer rota ou faça diretamente no seu GetMaterialApp

```dart
// essa forma
GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  opaqueRoute: Get.isOpaqueRouteDefault,
  popGesture: Get.isPopGestureEnable,
  transitionDuration: Get.defaultDurationTransition,
  defaultGlobalState: Get.defaultGlobalState,
);

// ou essa
Get.config(
  enableLog = true,
  defaultPopGesture = true,
  defaultTransition = Transitions.cupertino
)
```
### Nested Navigators

Get fez a navegação aninhada no Flutter mais fácil ainda. Você não precisa do `context`, e você encontrará sua `navigation stack` pela ID.

* Nota: Criar navegação paralela em stacks pode ser perigoso. O idela é não usar `NestedNavigators`, ou usar com moderação. Se o seu projeto requer isso, vá em frente, mas fique ciente que manter múltiplas stacks de navegação na memória pode não ser uma boa ideia no quesito consumo de RAM.

Veja como é simples:
```dart
Navigator(
  key: nestedKey(1), // crie uma key com um index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetRouteBase(
        page: Scaffold(
          appBar: AppBar(
            title: Text("Principal"),
          ),
          body: Center(
            child: FlatButton(
              color: Colors.blue,
              child: Text("Ir para a segunda"),
              onPressed: () {
                Get.toNamed('/segunda', id:1); // navega pela sua navegação aninhada usando o index
              },
            )
          ),
        ),
      );
    } else if (settings.name == '/segunda') {
      return GetRouteBase(
        page: Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Principal"),
            ),
            body: Center(
              child:  Text("Segunda")
            ),
          ),
        ),
      );
    }
  }
),
```
