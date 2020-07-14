![](get.png)

*Idiomas: [Inglês](README.md), Português Brasileiro (este arquivo), [Espanhol](README-es.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](getx.png)

<h2> Pedimos desculpas por qualquer parte não traduzida aqui. O GetX é atualizado com muita frequência e as traduções podem não vir ao mesmo tempo. Então, para manter essa documentação pelo menos com tudo que a versão em inglês tem, eu vou deixar todos os textos não-traduzidos aqui (eu considero que é melhor ele estar lá em inglês do que não estar), então se alguém quiser traduzir, seria muito útil 😁</h2>

- [Canais para comunicação e suporte:](#canais-para-comunicação-e-suporte-)
- [Sobre Get](#sobre-get)
- [Instalando](#instalando)
- [App Counter usando GetX](#app-counter-usando-getx)
- [Os três pilares](#os-tr-s-pilares)
  * [Gerenciamento de estado](#gerenciamento-de-estado)
    + [Reactive state manager](#reactive-state-manager)
    + [Mais detalhes sobre gerenciamento de estado](#mais-detalhes-sobre-gerenciamento-de-estado)
    + [Explicação em video do gerenciamento de estado](#explicação-em-video-do-gerenciamento-de-estado)
  * [Gerenciamento de rotas](#gerenciamento-de-rotas)
    + [Mais detalhes sobre gerenciamento de rotas](#mais-detalhes-sobre-gerenciamento-de-rotas)
    + [Explicação em video do gerenciamento de rotas](#explicação-em-video-do-gerenciamento-de-rotas)
  * [Gerenciamento de Dependência](#gerenciamento-de-dependência)
    + [Mais detalhes sobre gerenciamento de dependências](#mais-detalhes-sobre-gerenciamento-de-depend-ncias)
- [Como contribuir](#como-contribuir)
- [Utilidades](#utilidades)
  * [Mudar tema (changeTheme)](#mudar-tema--changetheme-)
  * [Outras APIs avançadas](#outras-apis-avan-adas)
    + [Configurações Globais opcionais e configurações manuais](#configura--es-globais-opcionais-e-configura--es-manuais)
- [Breaking Changes da versão 2 para 3](#breaking-changes-da-versão-2-para-3)
  * [Tipagem Rx](#tipagem-rx)
  * [RxController e GetBuilder se uniram](#rxcontroller-e-getbuilder-se-uniram)
  * [Rotas nomeadas](#rotas-nomeadas)
    + [Porque essa mudança](#porque-essa-mudança)
- [Por que GetX?](#por-que-getx-)

# Canais para comunicação e suporte:

[**Slack (Inglês)**](https://communityinviter.com/apps/getxworkspace/getx)

[**Discord (Inglês e Português)**](https://discord.com/invite/9Y3wK9)

[**Telegram (Português)**](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)

# Sobre Get

- Get é uma biblioteca poderosa e extra-leve para Flutter. Ela combina um gerenciador de estado de alta performance, injeção de dependência inteligente e gerenciamento de rotas de uma forma rápida e prática.
- Get não é para todos, seu foco é:
  - **Performance**: Já que gasta o mínimo de recursos
  - **Produtividade**: Usando uma sintaxe fácil e agradável
  - **Organização**: Que permite o total desacoplamento da View e da lógica de negócio.
- Get vai economizar horas de desenvolvimento, e vai extrair a performance máxima que sua aplicação pode entregar, enquanto é fácil para iniciantes e preciso para experts.
- Navegue por rotas sem `context`, abra `Dialog`s, `Snackbar`s ou `BottomSheet`s de qualquer lugar no código, gerencie estados e injete dependências de uma forma simples e prática.
- Get é seguro, estável, atualizado e oferece uma enorme gama de APIs que não estão presentes no framework padrão.
- GetX é desacoplado. Ele tem uma variedade de recursos que te permite começar a programar sem se preocupar com nada, mas cada um desses recursos estão em um container separado, ou seja, nenhuma depende da outra para funcionar. Elas só são inicializadas após o uso. Se você usa apenas o gerenciador de estado, apenas ele será compilado. Teste você mesmo, vá no repositório de benchmark do getX e perceberá: usando somente o gerenciador de estado do Get, a aplicação ficou mais leve do que outros projetos que também estão usando só o gerenciador de estado, porque nada que não seja usado será compilado no seu código, e cada recuro do GetX foi feito para ser muito leve. O mérito vem também do AOT do próprio Flutter que é incrível, e consegue eliminar recursos não utilizados de uma forma que nenhum outro framework consegue.

**GetX faz seu desenvolvimento mais produtivo, mas quer deixá-lo mais produtivo ainda? Adicione a extensão [GetX extension](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) no seu VSCode**. Não disponível para outras IDEs por enquanto.

# Instalando

Adicione Get ao seu arquivo pubspec.yaml

```yaml
dependencies:
  get:
```

Importe o get nos arquivos que ele for usado:

```dart
import 'package:get/get.dart';
```

# App Counter usando GetX

O app 'Counter' criado por padrão no flutter com o comando `flutter create` tem mais de 100 linhas(incluindo os comentários). Para demonstrar o poder do Get, irei demonstrar como fazer o mesmo 'Counter' mudando o estado em cada toque trocando entre páginas e compartilhando o estado entre telas. Tudo de forma organizada, separando a lógica de negócio da View, COM SOMENTE 26 LINHAS INCLUINDO COMENTÁRIOS

- Passo 1:
Troque `MaterialApp` para `GetMaterialApp`

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- **Obs:** Isso não modifica o `MaterialApp` do Flutter, GetMaterialApp não é uma versão modificada do MaterialApp, é só um Widget pré-configurado, que tem como child o MaterialApp padrão. Você pode configurar isso manualmente, mas definitivamente não é necessário. GetMaterialApp vai criar rotas, injetá-las, injetar traduções, injetar tudo que você precisa para navegação por rotas (gerenciamento de rotas). Se você quer somente usar o gerenciadro de estado ou somente o gerenciador de dependências, não é necessário usar o GetMaterialApp. Ele somente é necessário para:
  - Rotas
  - Snackbars/bottomsheets/dialogs
  - apis relacionadas a rotas e a ausência de `context`
  - Internacionalização
- **Obs²:** Esse passo só é necessário se você for usar o gerenciamento de rotas (`Get,to()`, `Get.back()` e assim por diante), Se você não vai usar isso então não é necessário seguir o passo 1

- Passo 2:
Cria a sua classe de regra de negócio e coloque todas as variáveis, métodos e controllers dentro dela.
Você pode fazer qualquer variável observável usando um simples `.obs`

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count.value++;
}
```

- Passo 3:
Crie sua View usando StatelessWidget, já que, usando Get, você não precisa mais usar StatefulWidgets.

```dart
class Home extends StatelessWidget {
  // Instancie sua classe usando Get.put() para torná-la disponível para todas as rotas subsequentes
  final Controller c = Get.put(Controller());
  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(title: Obx(
      () => Text("Total of clicks: " + c.count.string))),
      // Troque o Navigator.push de 8 linhas por um simples Get.to(). Você não precisa do 'context'
    body: Center(child: RaisedButton(
      child: Text("Ir pra Outra tela"), onPressed: () => Get.to(Outra()))),
    floatingActionButton: FloatingActionButton(child:
     Icon(Icons.add), onPressed: c.increment));
}

class Outra extends StatelessWidget {
  // Você pode pedir o Get para encontrar o controller que foi usado em outra página e redirecionar você pra ele.
  final Controller c = Get.find();
  @override
  Widget build(context) => Scaffold(body: Center(child: Text(c.count.string)));
}

```

Esse é um projeto simples mas já deixa claro o quão poderoso o Get é. Enquanto seu projeto cresce, essa diferença se torna bem mais significante.

Get foi feito para funcionar com times, mas torna o trabalho de um desenvolvedor individual simples.

Melhore seus prazos, entregue tudo a tempo sem perder performance. Get não é para todos, mas se você identificar com o que foi dito acima, Get é para você!


# Os três pilares

## Gerenciamento de estado

Há atualmente vários gerenciadores de estados para o Flutter. Porém, a maioria deles envolve usar `ChangeNotifier` para atualizar os widgets e isso é uma abordagem muito ruim no quesito performance em aplicações de médio ou grande porte. Você pode checar na documentação oficial do Flutter que o [`ChangeNotifier` deveria ser usado com um ou no máximo dois listeners](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), fazendo-o praticamente inutilizável em qualquer aplicação média ou grande.

Get não é melhor ou pior que nenhum gerenciador de estado, mas você deveria analisar esses pontos tanto quanto os argumentos abaixo para escolher entre usar Get na sua forma pura, ou usando-o em conjunto com outro gerenciador de estado.

Definitivamente, Get não é o inimigo de nenhum gerenciador, porque Get é um microframework, não apenas um gerenciador, e pode ser usado tanto sozinho quanto em conjunto com eles.

### Reactive state manager

Programação reativa pode alienar muitas pessoas porque é dito que é complicado. GetX transforma a programação reativa em algo bem simples:

* Você não precisa de criar StreamControllers
* Você não precisa criar um StreamBuilder para cada variável
* Você não precisa criar uma classe para cada estado
* Você não precisa criar um get para o valor inicial

Programação reativa com o Get é tão fácil quanto usar setState.

Vamos imaginar que você tenha uma variável e quer que toda vez que ela alterar, todos os widgets que a usam são automaticamente alterados.

Essa é sua variável:

```dart
var name = 'Jonatas Borges';
```

Para fazer dela uma variável observável, você só precisa adicionar `.obs` no final:

```dart
var name = 'Jonatas Borges'.obs;
```

E Na UI, quando quiser mostrar a variável e escutar as mudanças dela, simplesmente faça isso:


```dart
Obx (() => Text (controller.name));
```

Só isso. É *simples assim*;

### Mais detalhes sobre gerenciamento de estado

**Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/state_management.md). Lá terá mais exemplos e também a diferença do simple state manager do reactive state manager**

### Explicação em video do gerenciamento de estado

Amateur Coder fez um vídeo ótimo sobre o gerenciamento de estado! (em inglês). Link: [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw)

Você vai ter uma boa idea do poder do GetX

## Gerenciamento de rotas

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

Notou que você não precisou usar `context` para fazer nenhuma dessas coisas? Essa é uma das maiores vantagens de usar o gerenciamento de rotas do GetX. Com isso, você pode executar todos esse métodos de dentro da classe Controller, sem preocupações.

### Mais detalhes sobre gerenciamento de rotas

**GetX funciona com rotas nomeadas também! Veja uma explicação mais completa do gerenciamento de rotas [aqui](./docs/pt_BR/route_management.md)**

### Explicação em video do gerenciamento de rotas

Amateur Coder fez um outro vídeo excelente sobre gerenciamento de rotas! Link: [Complete Getx Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI)

O Próprio criador desse package, jonatas, fez um vídeo sobre o get. Esse é o vídeo de como ele fez o app do example, um app que usa a api do coronavírus pra mostrar dados

É muito interessante porque tem várias coisas do get lá pra se aprender. Link: [Gestão de estados DESCOMPLICADA com GetX aplicado a comunicação API Rest](https://www.youtube.com/watch?v=3qjebK6kwSM)

## Gerenciamento de Dependência

- Nota: Se você está usando o gerenciador de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api `Bindings`, que vai fazer tudo isso automaticamente para você.

Já está usando o Get e quer fazer seu projeto o melhor possível? Get tem um gerenciador de dependência simples e poderoso que permite você pegar a mesma classe que seu Bloc ou Controller com apenas uma linha de código, sem Provider context, sem inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Em vez de Controller controller = Controller();
```

Em vez de instanciar sua classe dentro da classe que você está usando, você está instanciando ele dentro da instância do Get, que vai fazer ele ficar disponível por todo o App

Para que então você possa usar seu controller (ou uma classe Bloc) normalmente

```dart
controller.fetchApi();
```

Agora, imagine que você navegou por inúmeras rotas e precisa de dados que foram deixados para trás em seu controlador. Você precisaria de um gerenciador de estado combinado com o Provider ou Get_it, correto? Não com Get. Você só precisa pedir ao Get para "procurar" pelo seu controlador, você não precisa de nenhuma dependência adicional para isso:

```dart
Controller controller = Get.find();
// Sim, parece Magia, o Get irá descobrir qual é seu controller, e irá te entregar.
// Você pode ter 1 milhão de controllers instanciados, o Get sempre te entregará o controller correto.
// Apenas se lembre de Tipar seu controller, final controller = Get.find(); por exemplo, não irá funcionar.
```

E então você será capaz de recuperar os dados do seu controller que foram obtidos anteriormente:

```dart
Text(controller.textFromApi);
```

Procurando por `lazyLoading`?(carregar somente quando for usar) Você pode declarar todos os seus controllers, e eles só vão ser inicializados e chamados quando alguém precisar. Você pode fazer isso

```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock só será chamado quando alguém usar o Get.find<Service> pela primeira vez
```

### Mais detalhes sobre gerenciamento de dependências

**Veja uma explicação mais completa do gerenciamento de dependência [aqui](./docs/pt_BR/dependency_management.md)**

# Como contribuir 

Quer contribuir no projeto? Nós ficaremos orgulhosos de ressaltar você como um dos colaboradores. Aqui vai algumas formas em que você pode contribuir e fazer Get (e Flutter) ainda melhores

- Ajudando a traduzir o README para outras linguagens.
- Adicionando mais documentação ao README (até o momento, várias das funcionalidades do Get não foram documentadas).
- Fazendo artigos/vídeos ensinando a usar o Get (eles serão inseridos no README, e no futuro na nossa Wiki).
- Fazendo PR's (Pull-Requests) para código/testes.
- Incluindo novas funcionalidades.

Qualquer contribuição é bem-vinda!

# Utilidades

## Mudar tema (changeTheme)

Por favor não use widget acima do GetMaterialApp para atualizar o tome. Isso pode causar keys duplicadas. Várias pessoas estão acostumadas com o jeito normal de criar um Widget `ThemeProvider` só pra alterar o thema do app, mas isso definitivamente NÃO é necessário no Get.

Você pode criar seu tema customizado e simplesmente adicionar dentro do `Get.changeTheme` sem nenhum boilerplate para isso:

```dart
Get.changeTheme(ThemeData.light())
```

Se você quer criar algo como um botão que muda o tema com o toque, você pode combinar duas APIs Get pra isso: a API que checa se o tema dark está sendo aplicado, e a API de mudar o tema, e colocar isso no `onPressed:`

```dart
Get.changeTheme(
  Get.isDarkMode
  ? ThemeData.light()
  : ThemeData.dark()
)
```

Quando o modo Dark está ativado, ele vai trocar pro modo light, e vice versa.

Se você quiser saber mais como trocar o tema, você pode seguir esse tutorial no Medium que até ensina persistência do tema usando Get (e SharedPreferences):

- [Dynamic Themes in 3 lines using Get](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).

## Outras APIs avançadas

```dart
// fornece os arguments da tela atual
Get.arguments

// fornece os arguments da rota anterior
Get.previousArguments

// fornece o nome da rota anterior
Get.previousRoute

// fornece a rota bruta para acessar por exemplo, rawRoute.isFirst()
Get.rawRoute

// fornece acesso a API de rotas de dentro do GetObserver
Get.routing

// checa se o snackbar está aberto
Get.isSnackbarOpen

// checa se o dialog está aberto
Get.isDialogOpen

// checa se o bottomsheet está aberto
Get.isBottomSheetOpen

// remove uma rota.
Get.removeRoute()

// volta repetidamente até o predicate retorne true.
Get.until()

// vá para a próxima rota e remove todas as rotas
//anteriores até que o predicate retorne true.
Get.offUntil()

// vá para a próxima rota nomeada e remove todas as
//rotas anteriores até que o predicate retorne true.
Get.offNamedUntil()

// retorna qual é a plataforma
//(Esse método é completamente compatível com o FlutterWeb,
//diferente do método do framework "Platform.isAndroid")
GetPlatform.isAndroid/isIOS/isWeb...

// Equivalente ao método: MediaQuery.of(context).size.width ou height, mas é imutável. Significa que não irá atualizar mesmo que o tamanho da tela mude (como em navegadores ou app desktop)
Get.height
Get.width

// Se você precisa de um width/height adaptável (como em navegadores em que a janela pode ser redimensionada) você precisa usar 'context'
Get.context.width
Get.context.height

// forncece o context da tela em qualquer lugar do seu código.
Get.context

// fornece o context de snackbar/dialog/bottomsheet em qualquer lugar do seu código.
Get.contextOverlay

/// similar to MediaQuery.of(this).padding
Get.mediaQueryPadding()

/// similar to MediaQuery.of(this).viewPadding
Get.mediaQueryViewPadding()

/// similar to MediaQuery.of(this).viewInsets;
Get.mediaQueryViewInsets()

/// similar to MediaQuery.of(this).orientation;
Get.orientation()

/// check if device is on landscape mode
Get.isLandscape()

/// check if device is on portrait mode
Get.isPortrait()

/// similar to MediaQuery.of(this).devicePixelRatio;
Get.devicePixelRatio()

/// similar to MediaQuery.of(this).textScaleFactor;
Get.textScaleFactor()

/// get the shortestSide from screen
Get.mediaQueryShortestSide()

/// True if width be larger than 800
Get.showNavbar()

/// True if the shortestSide is smaller than 600p
Get.isPhone()

/// True if the shortestSide is largest than 600p
Get.isSmallTablet()

/// True if the shortestSide is largest than 720p
Get.isLargeTablet()

/// True if the current device is Tablet
Get.isTablet()
```

### Configurações Globais opcionais e configurações manuais

GetMaterialApp configura tudo para você, mas se quiser configurar Get manualmente, você pode.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

Você também será capaz de usar seu próprio Middleware dentro do GetObserver, isso não irá influenciar em nada.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Aqui
  ],
);
```

Você pode criar Configurações Globais para o Get. Apenas adicione `Get.config` ao seu código antes de usar qualquer rota ou faça diretamente no seu GetMaterialApp

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

# Breaking Changes da versão 2 para 3

## Tipagem Rx

| Antes    | Depois     |
| -------- | ---------- |
| StringX  | `RxString` |
| IntX     | `RxInt`    |
| MapX     | `RxMax`    |
| ListX    | `RxList`   |
| NumX     | `RxNum`    |
| RxDouble | `RxDouble` |

## RxController e GetBuilder se uniram

RxController e GetBuilder agora viraram um só, você não precisa mais memorizar qual controller quer usar, apenas coloque `GetxController`, vai funcionar para os dois gerenciamento de estados

```dart
//Gerenciador de estado simples
class Controller extends GetXController {
  String nome = '';

  void atualizarNome(String novoNome) {
    nome = novoNome;
    update()
  }
}
```

```dart
class Controller extends GetXController {
  final nome = ''.obs;

  // não precisa de um método direto pra atualizar o nome
  // só usar o nome.value
}
```

## Rotas nomeadas

Antes:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Agora:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page:()=> Home()),
  ]
)
```

### Porque essa mudança

Frequentemente, pode ser necessário decidir qual pagina vai ser mostrada ao usuário a partir de um parâmetro, como um token de login. A forma abordada anteriormente não era flexível, já que não permitia isso.

Inserir a página numa função reduziu significativamente o consumo de RAM, já que as rotas não são alocadas na memória desde o app inicia, e também permite fazer esse tipo de abordagem:

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

# Por que GetX?

1- Muitas vezes após uma atualização do Flutter, muitos dos seus packages irão quebrar. As vezes acontecem erros de compilação, muitas vezes aparecem erros que ainda não existem respostas sobre, e o desenvolvedor necessita saber de onde o erro veio, rastrear o erro, para só então tentar abrir uma issue no repositório correspondente, e ver seu problema resolvido. Get centraliza os principais recursos para o desenvolvimento (Gerencia de estado, de dependencias e de rotas), permitindo você adicionar um único package em seu pubspec, e começar a trabalhar. Após uma atualização do Flutter, a única coisa que você precisa fazer é atualizar a dependencia do Get, e começar a trabalhar. Get também resolve problemas de compatibilidade. Quantas vezes uma versão de um package não é compatível com a versão de outro, porque um utiliza uma dependencia em uma versão, e o outro em outra versão? Essa também não é uma preocupação usando Get, já que tudo está no mesmo package e é totalmente compatível.

2- Flutter é fácil, Flutter é incrível, mas Flutter ainda tem algum boilerplate que pode ser indesejado para maioria dos desenvolvedores, como o Navigator.of(context).push(context, builder[...]. Get simplifica o desenvolvimento. Em vez de escrever 8 linhas de código para apenas chamar uma rota, você pode simplesmente fazer: Get.to(Home()) e pronto, você irá para a próxima página. Urls dinamicas da web é algo realmente doloroso de fazer com o Flutter atualmente, e isso com o GetX é estupidamente simples. Gerenciar estados no Flutter, e gerenciar dependencias também é algo que gera muita discussão, por haver centenas de padrões na pub. Mas não há nada que seja tão fácil quanto adicionar um ".obs" no final de sua variável, e colocar o seu widget dentro de um Obx, e pronto, todas atualizações daquela variável será automaticamente atualizado na tela.

3- Facilidade sem se preocupar com desempenho. O desempenho do Flutter já é incrível, mas imagine que você use um gerenciador de estados, e um locator para distribuir suas classes blocs/stores/controllers/ etc. Você deverá chamar manualmente a exclusão daquela dependencia quando não precisar dela. Mas já pensou em simplesmente usar seu controlador, e quando ele não tivesse mais sendo usado por ninguém, ele simplesmente fosse excluído da memória? É isso que GetX faz. Com o SmartManagement, tudo que não está sendo usado é excluído da memória, e você não deve se preocupar em nada além de programar. Você terá garantia que está consumindo o mínimo de recursos necessários, sem ao menos ter criado uma lógica para isso.

4- Desacoplamento real. Você já deve ter ouvido o conceito "separar a view da lógica de negócios". Isso não é uma peculiaridade do BLoC, MVC, MVVM, e qualquer outro padrão existente no mercado tem esse conceito. No entanto, muitas vezes esse conceito pode ser mitigado no Flutter por conta do uso do context.
Se você precisa de context para localizar um InheritedWidget, você precisa disso na view, ou passar o context por parametro. Eu particularmente acho essa solução muito feia, e para trabalhar em equipes teremos sempre uma dependencia da lógica de negócios da View. Getx é pouco ortodoxo com a abordagem padrão, e apesar de não proibir totalmente o uso de StatefulWidgets, InitState, e etc, ele tem sempre uma abordagem similar que pode ser mais limpa. Os controllers tem ciclos de vida, e quando você precisa fazer uma solicitação APIREST por exemplo, você não depende de nada da view. Você pode usar onInit para iniciar a chamada http, e quando os dados chegarem, as variáveis serão preenchidas. Como GetX é totalmente reativo (de verdade, e trabalha sob streams), assim que os itens forem preenchidos, automaticamente será atualizado na view todos os widgets que usam aquela variável. Isso permite que as pessoas especialistas em UI trabalhem apenas com widgets, e não precisem enviar nada para a lógica de negócio além de eventos do usuário (como clicar em um botão), enquanto as pessoas que trabalham com a lógica de negócios ficarão livres para criar e testar a lógica de negócios separadamente.  
