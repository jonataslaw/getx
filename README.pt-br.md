# Get

Uma biblioteca de navegação completa que permite navegar entre telas, abrir caixas de diálogo, bottomSheets e exibir snackbars de qualquer lugar do seu código, sem precisar usar context.
## Ponto de partida

*Idiomas: [Inglês](README.md), [Português](README.pt-br.md).*

A navegação convencional do Flutter possui muito código clichê desnecessário, requer contexto para navegar entre telas, abrir caixas de diálogo e usar snackbars em seu projeto pode ser algo desgastante.
Além disso, quando uma rota é enviada por push, todo o MaterialApp pode ser reconstruído causando congelamentos, bem, isso não acontece com o Get.
Essa biblioteca que mudará a maneira como você trabalha com o Framework e salvará sua vida do código clichê, aumentando sua produtividade e eliminando os erros de reconstrução do seu aplicativo, além de um conjunto de APIs não disponíveis na biblioteca padrão do Flutter.


```dart
// Navegação padrão do Flutter:
Navigator.of(context).push(
        context,
        MaterialPageRoute(
           builder: (BuildContext context) { 
            return HomePage();
          },
        ),
      );

// Como fazer o mesmo com o Get:
Get.to(Home());
```

##### Se você está na branch master/dev/beta do Flutter, use a versão 1.20.0-dev.
* Se você usa Modular, adicione ao seu MaterialApp: navigatorKey: Get.addKey(Modular.navigatorKey)

## Como usar?

Adicione esse pacote ao seu arquivo pubspec.yaml:

```
dependencies:
  get: ^1.17.3 // ^1.20.1-dev on beta/dev/master
```
  
Importe ele se seu IDE não fizer isso de forma automática:
```dart
import 'package:get/get.dart';
```
Adicione GetKey ao seu MaterialApp e aproveite!
```dart
MaterialApp(
    navigatorKey: Get.key,
    home: MyHome(),
  )
```
### Navegando sem rotas nomeadas
Para ir para outra tela:

```dart
Get.to(NextScreen());
```

Para voltar para a tela anterior

```dart
Get.back();
```

Para ir para a próxima tela e tirar a rota atual da stack de navegação (uso comum em SplashScreens, telas de cadastros e qualquer outra tela que você não deseja exibir quando clicar em voltar)

```dart
Get.off(NextScreen());
```

Ir para a próxima tela e tirar todas as telas anteriores da stack de  navegação (geralmente usado em carrinhos de compras, provas, enquetes e etc)

```dart
Get.offAll(NextScreen());
```

Para navegar para uma rota e receber ou atualizar dados assim que voltar dela:
```dart
var data = await Get.to(Payment());
```
Na próxima tela, envie algum dado para a screen anterior ao voltar (pode ser qualquer coisa, Strings, int, Maps, até instâncias de classes, você pode tudo):

```dart
Get.back(result: 'sucess');
```
E você pode usar o dado recebido assim:

ex:
```dart
if(data == 'sucess') madeAnything();
```

Você não quer aprender nossa sintaxe?
Basta alterar o Navigator (maiúsculo) para navigator (minúsculo) e você terá todas as funções da navegação padrão, sem precisar usar o contexto
Exemplo:

```dart

// Navegação padrão
Navigator.of(context).push(
        context,
        MaterialPageRoute(
           builder: (BuildContext context) { 
            return HomePage();
          },
        ),
      );

// Usando Get com a sintaxe do Flutter
navigator.push(
        MaterialPageRoute(
           builder: (_) { 
            return HomePage();
          },
        ),
      );

// Usando a sintaxe do Get (Muito  melhor, mas você pode discordar disso)
Get.to(HomePage());


```

### SnackBars

Para ter uma simples SnackBar com Flutter, você deve obter o contexto do Scaffold ou usar uma GlobalKey anexada ao seu Scaffold,
```dart
final snackBar = SnackBar(
      content: Text('Oi!'),
      action: SnackBarAction(
              label: 'Eu sou uma velha e feia snackbar :(',
              onPressed: (){}
            ),
          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
```

Já com o Get:

```dart
Get.snackbar('Oi', 'Eu sou uma snackbar bonita e moderna');
```

Com o Get, tudo o que você precisa fazer é chamar o Get.snackbar de qualquer lugar no seu código ou personalizá-lo como quiser!

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


  ////////// TODOS RECURSOS //////////
  //     Color colorText,
  //     Duration duration,
  //     SnackPosition snackPosition,
  //     Widget titleText,
  //     Widget messageText,
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
Após a recusa de um aplicativo na AppleStore por usar a snackbar padrão que não combina nada com as Human Guidelines da Apple, resolvi criar a Get.snackbar, mas se você prefere a snackbar padrão, ou não desenvolve para iOS, você pode usar a API de baixo nível `GetBar().show();` que permite por exemplo, excluir a mensagem (Get.snackbar tem título e mensagem obrigatórios).

### Caixas de dialogos

Para abrir uma caixa de diálogo:

```dart
Get.dialog(YourDialogWidget());
```

Para abrir o dialogo padrão do Get:

```dart
 Get.defaultDialog(
                title: "My Title",
                content: Text("Hi, it's my dialog"),
                confirm: FlatButton(
                  child: Text("Ok"),
                  onPressed: () => print("OK pressed"),
                ),
                cancel: FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Get.back(),
                ));
```

### BottomSheets
Get.bottomSheet é como showModalBottomSheet, mas não precisa de context.

```dart
Get.bottomSheet(
      builder: (_){
          return Container(
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
      }
    );
```
### Configurações Globais
Você pode criar configurações globais para o Get. Basta adicionar Get.config ao seu código antes de enviar qualquer rota. (Se não souber onde colocar, coloque dentro da função main())

```dart
Get.config(
      enableLog = true,
      defaultPopGesture = true,
      defaultTransition = Transitions.cupertino}
```

## Gerenciador de instâncias descomplicado
Além de aumentar produtividade, muita gente usa Get para ter um aplicativo menor. Se você tem várias rotas e snackbars em seu aplicativo, ele provavelmente terá um código final maior que seu aplicativo + essa biblioteca
Se você já está usando o Get e deseja tornar seu projeto o mais enxuto possível, agora o Get possui um gerenciador de instancias simples que permite recuperar a mesma classe do seu Bloc ou Controller com apenas 1 linhas de código.

```dart
Controller controller = Get.put(Controller()); // Em vez de Controller controller = Controller();
```
Em vez de instanciar seu controlador dentro da classe que você está usando, use o metodo put para que o Get pegue sua instância e disponibilize por todo o seu aplicativo.
Então você pode usar seu controlador (ou classe Bloc) normalmente.

```dart
controller.fetchApi();// Rather Controller controller = Controller();
```

Agora, imagine que você navegou por inúmeras rotas e precisa de dados que foram deixados para trás em seu controlador; você precisaria de um gerenciador de estado combinado com o Provider ou Get_it, correto? Não com Get. Você só precisa pedir ao Get para "procurar" pelo seu controlador, você não precisa de nenhuma dependência adicional para isso:

```dart
Controller controller = Get.find();
// Sim, parece Magia, o Get irá descobrir qual é seu controller, e irá te entregar. Você pode ter 1 milhão de controllers instanciados, o Get sempre te entregará o controller correto. Apenas se lembre de Tipar seu controller, final controller = Get.find(); por exemplo, não irá funcionar.
```
E então você poderá recuperar os dados do seu controlador obtidos lá:

```dart
Text(controller.textFromApi);
```

Quer liberar recursos? Para remover uma instância do Get, apenas delete ela:

```dart
Controller controller = Get.delete(Controller());
```
Pronto, você consegue fazer mais com menos código, diminuiu o tamanho de código do seu app, e agora tem um gerenciador de instâncias ultra leve, com apenas 1 biblioteca.

## Navegando com rotas nomeadas:
- Se você prefere navegar por rotas nomeadas, o Get também dá suporte a isso. 

Para navegar para uma nova tela
```dart
Get.toNamed("/NextScreen");
```
Para navegar para uma tela sem a opção de voltar para a rota atual.
```dart
Get.offNamed("/NextScreen");
```
Para navegar para uma nova tela e remover todas rotas anteriores da stack
```dart
Get.offAllNamed("/NextScreen");
```

### Enviando dados por rotas nomeadas:

Apenas envie o que você quiser por argumentos. Get aceita qualquer coisa aqui, não importa se é uma String, um Map, uma List, int ou até uma instancia de classe.
```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```
Agora você pode recuperar em sua classe ou em seu controller:

```dart
print(Get.arguments);
//print out: Get is the best
```

## Configurando rotas nomeadas e adicionando suporte completo à urls amigáveis do Flutter Web

### Se você ainda não adicionou " navigatorKey: Get.key," ao seu MaterialApp, faça agora. aproveite para adicionar uma  "initialRoute" e o seu "onGenerateRoute".

```dart
void main() {
  runApp(MaterialApp(
    onGenerateRoute: Router.generateRoute,
    initialRoute: "/",
    navigatorKey: Get.key,
    title: 'Navigation',
  ));
}
```
Crie uma classe para gerenciar suas rotas nomeadas, você pode (e deve) copiar esse exemplo

```dart
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return GetRoute(
          page: First(),
          settings: settings,
        );
      case '/second':
        return GetRoute(
            settings: settings, page: Second(), transition: Transition.fade);
      case '/third':
        return GetRoute(
            settings: settings,
            page: Third(),
            popGesture: true,
            transition: Transition.cupertino);
      default:
        return GetRoute(
            settings: settings,
            transition: Transition.fade,
            page: Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}
```

E agora, tudo que você precisa fazer é usar Get.toNamed() para navegar pelas rotas nomeadas, sem qualquer context (você pode chamar suas rotas diretamente da sua classe BLoC ou Controller) e, quando o aplicativo for compilado na Web, suas rotas aparecerão na URL <3

#### Middleware 
Se você deseja ouvir eventos de navegação para acionar ações, é possível adicionar um GetObserver ao seu materialApp. Isso é extremamente útil para acionar eventos sempre que uma tela específica é exibida na tela. Atualmente no Flutter, você teria que colocar o evento no initState e aguardar uma possível resposta em um navigator.pop (context); para conseguir isso. Mas com o Get, isso é extremamente simples!

##### add GetObserver();
```dart
void main() {
  runApp(MaterialApp(
    onGenerateRoute: Router.generateRoute,
    initialRoute: "/",
    navigatorKey: Get.key,
    navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
    ],
  ));
}
```
Create a MiddleWare class

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Você pode ouvir além das rotas, snackbars, caixas de diálogo e bottomsheets em cada tela.
   /// Se você precisar inserir qualquer um desses 3 eventos diretamente aqui,
   /// você deve especificar que o evento é != Do que você está tentando fazer ou você terá um loop.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```
Agora é só usar o Get em seu código:

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


### APIs Avançadas
A cada dia, o Get fica mais longe do Framework padrão e fornece uma gama mais ampla de recursos que são impensáveis de serem executados usando o Flutter padrão.
Com o Get 1.17.0, foi lançada uma série de novas APIs, que permitem por exemplo, o acesso dos argumentos de uma rota nomeada de qualquer lugar do código, se há alguma snackbar ou caixa de diálogo aberta naquele momento ou qual tela está sendo exibida para o usuário.
Este é um grande passo para desanexar completamente a navegação Flutter de InheritedWidgets. Usar o contexto para acessar o InheritedWidget para usar um recurso simples de navegação é uma das únicas coisas chatas que se pode encontrar nessa estrutura incrível que é o Flutter. Agora, o Get resolveu esse problema, tornou-se onisciente e você terá acesso a basicamente qualquer ferramenta do Flutter que está disponível apenas na árvore de widgets usando o Get.

Todas as APIs disponíveis aqui estão na fase beta; elas são totalmente funcionais, passaram em testes internos, mas como foram recém lançadas, não tem maturidade suficiente para garantir sua estabilidade. Get é totalmente estável (quase sempre issues abertas são solicitações de recursos, quase nunca bugs), mas esse conjunto de APIs foi lançado recentemente, portanto, se você encontrar algum erro aqui, abra um problema ou ofereça um PR.

- Obrigatório: para ter acesso a essa API, você deve obrigatoriamente inserir o GetObserver em seu MaterialApp 

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()], // COLOQUE AQUI !!!!
    );
```

Você também poderá usar seu próprio Middleware no GetObserver, isso não influenciará em nada.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver(MiddleWare.observer)], // AQUI
    );
```

Principais APIs:

```dart
Get.arguments // Te dá os argumentos da rota aberta em qualquer lugar do seu código. 
              // você não precisa mais recebê-los, inicializa-los no seu initState e enviar por parâmetro ao seu controller/Bloc, Get é onisciente, ele sabe exatamente qual rota está aberta e quais argumentos enviados para ela. Você pode usar isso diretamente no seu controller/bloc sem medo.

Get.previousArguments // Te dá os argumentos da rota anterior. 

Get.previousRoute // Te dá o nome da rota anterior

Get.rawRoute // te dá acesso à rota crua, para explorar APIs de baixo nível

Get.routing // te dá acesso à Rounting API do GetObserver

Get.isSnackbarOpen // verifique se a snackbar está sendo exibida na tela

Get.isDialogOpen // verifique se a caixa de diálogo está sendo exibida na tela

Get.isBottomSheetOpen // verifique se a bottomsheet está sendo exibida na tela


```
### Nested Navigators

Get fez a navegação aninhada do Flutter ainda mais fácil.
Você não precisa do contexto e encontrará sua pilha de navegação por um ID exclusivo.

Veja como é simples:

```dart
             Navigator(
                key: nestedKey(1), // crie sua key por um index
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  if (settings.name == '/') {
                    return GetRoute(
                      page: Scaffold(
                        appBar: AppBar(
                          title: Text("Main"),
                        ),
                        body: Center(
                          child: FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                Get.toNamed('/second', 1); // navegue por sua rota aninhada usando o index
                              },
                              child: Text("Go to second")),
                        ),
                      ),
                    );
                  } else if (settings.name == '/second') {
                    return GetRoute(
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
                }),
```


### Outras APIs:
Desde quando essa biblioteca foi criada, reuni meus esforços para adicionar novos recursos e torná-la mais estável possível. Com isso, ainda há algumas APIs disponíveis que ainda não foram documentadas. Meu tempo é escasso, então vou resumir as principais aqui:

```dart
Get.removeRoute() // remove uma rota

Get.until() // volta repetidamente até o predicado ser verdadeiro

Get.offUntil() // vá para a próxima rota e remova todas as rotas anteriores até que o predicado retornar verdadeiro.

Get.offNamedUntil() // vá para a próxima rota nomeada e remova todas as rotas anteriores até que o predicado retorne verdadeiro (namedRoutes)

GetPlatform.isAndroid/isIOS/isWeb... //(Este método é totalmente compatível com o FlutterWeb, diferente do padrão "Platform.isAndroid" que usa dart:io)

Get.height / Get.width // Equivalente ao método: MediaQuery.of(context).size.height //width

Get.context // Fornece o contexto da tela em primeiro plano em qualquer lugar do seu código.

Get.overlayContext // Fornece o contexto do dialogo/snackbar/bottomsheet em primeiro plano em qualquer lugar do seu código.


```

Essa biblioteca será sempre atualizada e implementando novos recursos. Sinta-se livre para oferecer PRs e contribuir com ela.
