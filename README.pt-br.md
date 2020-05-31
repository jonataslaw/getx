![](get.png)

*Languages: [English](README.md), [Brazilian Portuguese](README.pt-br.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/Test,%20build%20and%20deploy/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

Get é uma biblioteca poderosa e extra-leve para Flutter que vai te dar superpoderes e aumentar sua produtividade. Navegue sem precisar do `context`, abra `Dialog`s, `Snackbar`s ou `BottomSheet`s de qualquer lugar no código, gerencie estados e injete dependências de uma forma simples e prática! Get é seguro, estável, atualizado e oferece uma enorme gama de APIs que não estão presentes no framework padrão.

```dart
// Navigator padrão do Flutter
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return Home();
    },
  ),
);

// Sintaxe do Get
Get.to(Home());
```

## Começando

A navegação convencional do Flutter tem uma grande quantidade de boilerplate (código que se repete demais), requer o `context` para navegar entre telas/rotas, abrir dialogs e usar snackbars no framework, e é entediante.
Somando a isso, quando uma rota é enviada (uma tela carregada), o `MaterialApp` inteiro pode ser reconstruído podendo causando travamentos. Isso não acontece com o Get.
Essa biblioteca vai mudar a forma que você trabalha com o Framework e salvar seu código dos boilerplates, aumentando sua produtividade, e eliminando os bugs de reconstrução da sua aplicação.

- [Começando](#começando)
    - [Você pode contribuir no projeto de várias formas:](#você-pode-contribuir-no-projeto-de-várias-formas)
- [Como usar?](#como-usar)
- [Navegação sem rotas nomeadas](#navegação-sem-rotas-nomeadas)
  - [SnackBars](#snackbars)
  - [Dialogs](#dialogs)
  - [BottomSheets](#bottomsheets)
- [Gerenciador de estado simples](#gerenciador-de-estado-simples)
  - [Uso do gerenciador de estado simples](#uso-do-gerenciador-de-estado-simples)
    - [Sem StatefulWidget;](#sem-statefulwidget)
      - [Formas de uso:](#formas-de-uso)
- [Reactive State Manager - GetX](#reactive-state-manager---getx)
- [Simple Instance Manager](#simple-instance-manager)
- [Navigate with named routes:](#navigate-with-named-routes)
  - [Send data to named Routes:](#send-data-to-named-routes)
    - [Dynamic urls links](#dynamic-urls-links)
    - [Middleware](#middleware)
  - [Change Theme](#change-theme)
  - [Optional Global Settings](#optional-global-settings)
  - [Other Advanced APIs and Manual configurations](#other-advanced-apis-and-manual-configurations)
  - [Nested Navigators](#nested-navigators)




#### Você pode contribuir no projeto de várias formas:
- Ajudando a traduzir o README para outras linguagens.
- Adicionando mais documentação ao README (até o momento, nem metade das funcionalidades do Get foram documentadas).
- Fazendo artigos/vídeos sobre o Get (eles serão inseridos no README, e no futuro na nossa Wiki).
- Fazendo PR's (Pull-Requests) para código/testes.
- Incluindo novas funcionalidades.

Qualquer contribuição é bem-vinda!

## Como usar?

<!-- - Flutter Master/Dev/Beta: version 2.0.x-dev 
- Flutter Stable branch: version 2.0.x
(procure pela versão mais recente em pub.dev) -->

Adicione Get ao seu arquivo pubspec.yaml
<!-- de acordo com a versão do flutter que você estiver usando -->

Troque seu `MaterialApp()` por `GetMaterialApp()` e aproveite!
```dart
import 'package:get/get.dart';

GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Navegação sem rotas nomeadas

Para navegar para uma próxima tela:
```dart
Get.to(ProximaTela());
```

Para retornar para a tela anterior:
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

Para ter um `SnackBar` simples no Flutter, você precisa pegar o `context` do Scaffold, ou você precisa de uma `GlobalKey` atrelada ao seu Scaffold.
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
  "É inacreditável! Eu estou usando uma SnackBar sem context, sem " +
  "boilerplate, sem Scaffold, é algo realmente maravilhoso!", // mensagem
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
Se você prefere a SnackBar tradicional, ou quer customizar por completo, como por exemplo fazer ele ter só uma linha (`Get.snackbar` tem os parâmetros `title` e `message` obrigatórios), você pode usar `Get.rawSnackbar();` que fornece a RAW API na qual `Get.snackbar` foi contruído.

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

Para todos os outros Widgets dialog do Flutter, incluindo os do Cupertino, você pode usar `Get.overlayContext` em vez do `context`, e abrir em qualquer lugar do seu código.

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

## Gerenciador de estado simples
Há atualmente vários gerenciadores de estados para o Flutter. Porém, a maioria deles envolve usar `ChangeNotifier` para atualizar os widgets e isso é uma abordagem muito ruim no quesito performance de aplicações de médio ou grande porte. Você pode checar na documentação oficial do Flutter que o [`ChangeNotifier` deveria ser usado com um ou no máximo dois listeners](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), fazendo-o praticamente inutilizável em qualquer aplicação média ou grande. Outros gerenciadores de estado são bons, mas tem suas nuances. BLoC é bem seguro e eficiente, mas é muito complexo (especialmente para iniciantes), o que impediu pessoas de desenvolverem com Flutter. MobX é mais fácil que o BLoc e é reativo, quase perfeito eu diria, mas você precisa usar um code generator que, para aplicações de grande porte, reduz a produtividade (você terá que beber vários cafés até que seu código esteja pronto denovo depois de um `flutter clean`, o que não é culpa do MobX, o code generatoe que é muito lento!). Provider usa o `InheritedWidget` para entregar o mesmo listener, como uma forma de solucionar o problema reportado acima com o ChangeNotifier, o que indica que qualquer acesso ao ChangeNotifier dele tem que ser dentro da árvore de widgets por causa do `context` necessário para acessar o Inherited.

Get não é melhor ou pior que nenhum gerenciador de estado, mas você deveria analisar esses pontos tanto quanto os argumentos abaixo para escolher entre usar Get na sua forma pura (Vanilla), ou usando-o em conjunto com outro gerenciador de estado. Definitivamente, Get não é o inimigo nenhum gerenciador, porque Get é um microframework, não apenas um gerenciador, e pode ser usado tanto sozinho quanto em conjunto com eles.

Get tem um gerenciador de estado que é extremamente leve e fácil (escrito em apensar 95 linha de código), que não usa ChangeNotifier, vai atender a necessidade especialmente daqueles novos no Flutter, e não vai causar problemas em aplicações de grande porte.

Que melhoras na performance o Get traz?

1. Atualiza somente o widget necessário.

2. Não usa o `ChangeNotifier`, é o gerenciador de estado que utiliza menos memória (próximo de 0mb até agora).

3. Esqueça StatefulWidget's! Com Get voce nunca mais vai precisar. Com outros gerenciadores de estado, você provavelmente precisa usar um StatefulWidget para pegar a instância do seu Provider, BLoc, MobX controller, etc. Mas já parou para pensar que seu AppBar, seu Scaffold e a maioria dos widgets que estão na sua classe são stateless? Então porque salvar o estado de uma classe inteira, se você pode salvar somente o estado de um widget stateful? Get resolve isso também. Crie uma classe Stateless, faça tudo stateless. Se vocÊ precisar atualizar um único componente, envolvar ele com o GetBuilder, e seu estado será mantido.

4. Organize seu projeto de verdade! Controllers não devem ficar na sua UI, coloque seus `TextEditController`, ou qualquer controller que você usa dentro da classe Controller.

5. Você precisa acionar um evento para atualizar um widget assim que ele é renderizado? GetBuilder tem a propriedade `initState` assim como um StatefulWidget, e você pode acionar eventos a partir do seu controller, diretamente de lá. Sem mais de eventos serem colocados no initState.

6. Você precisa acionar uma ação como fechar `Stream`s, timers, etc? GetBuilder também tem a propriedade `dispose`, onde você pode acionar eventos assim que o widget é destruído.

7. Use `Stream`s somente se necessário. Você pode usar seus StreamControllers dentro do seu controller normalmente, e usar `StreamBuilder` normalmente também, mas lembre-se, um Stream consume uma memória razoável, programação reativa é linda, mas você não abuse. 30 Streams abertos simultaneamente podem ser ainda piores que o `ChangeNotifier` (e olha que o ChangeNotifier é bem ruim)
8. Atualizar widgets sem gastar memória com isso. Get guarda somente a ID do criador GetBuilder, e atualiza esse GetBuilder quando necessário. O consumo de memória do ID do Get é muito baixo mesmo para milhares de GetBuilders. Quando você cria um novo GetBuilder, na verdade você está compartilhando o estado do GetBuilder quem tem um ID do creator. Um novo estado não é criado para cada GetBuilder, o que reduz MUITO o consumo de memória RAM em aplicações grandes. Basicamente sua aplicação vai ser toda stateless, e os poucos widgets que serão Stateful (dentro do GetBuilder) vão ter um estado único, e assim atualizar um deles vai atualizar todos eles. O estado é só um.

9. Get é onisciente e na maioria dos casos sabe o momento exato de tirar um controller da memória. Você não precisa se preocupar com quando descartar o controller, Get sabe o melhor momento para fazer isso. Exemplo: 

`Class A => Class B (tem o controller X) => Class C (tem o controller X)`

Na classe A o controller não está ainda na memória, porque você ainda não o usou (Get carrega só quando precisa). Na classe B você usou o controller, e ele entrou na memória. Na classe C você usou o mesmo controller da classe B, Get vai compartilhar o estado do controller B com o controller C, e o mesmo controller ainda esta na memória. Se você fechar a classe C e classe B, Get vai tirar o controller X da memória automaticamente e liberar recursos, porque a classe A não está usando o controller. Se você navegar para a Classe B denovo, o controller X vai entrar na memória denovo. Se em vez de ir para a classe C você voltar para a classe A, Get vai tirar o controller da memória do mesmo jeito. Se a classe C não usar o controller, e você tirar a classe B da memória, nenhuma classe estaria usando o controller X, e novamente o controller seria descartado. A única exceção que pode atrapalhar o Get, é se
Você remover classe N da rota de forma inesperada, e tentasse usar o controller na classe C. Nesse caso, o ID do creator do controller que estava em B seria deletado, e o Get foi programado para remover da memória todo controller que não tem nenhum ID de creator. Se é sua intenção fazer isso, adicione a config `autoRemove: false` no GetBuilder da classe B, e use `adoptID = true;` no GetBuilder da classe C. 

### Uso do gerenciador de estado simples

```dart
// Crie a classe Controller e entenda ela do GetController 
class Controller extends GetController {
  int counter = 0;
  void increment() {
    counter++;
    update(this); // use update(this) para atualizar a variável counter na UI quando increment for chamado
  }
}
// Na sua classe Stateless/Stateful, use o GetBuilder para atualizar o texto quando a função increment for chamada
GetBuilder<Controller>(
  init: Controller(), // INICIE O CONTROLLER SOMENTE NA PRIMEIRA VEZ
  builder: (controller) => Text(
    '${controller.counter}',
  ),
),
// Inicialize seu controller somente uma vez. Na segunda vez que você for usar  GetBuilder para o mesmo controller, não Inicialize denovo. Seu controller será automaticamente removido da memória. Você não precisa se preocupar com isso, Get vai fazer isso automaticamente, apenas tenha certeza que você não vai inicializar o mesmo controller duas vezes. 
```
**Feito!**

* Você já aprendeu como gerenciar estados com o Get.
* Nota: Você talvez queira uma maior organização, e não querer usar a propriedade `init`. Para isso, você pode criar uma classe e extendê-la da classe `Bindings`, e nela mencionar os controllers que serão criados dentro daquela rota. Controllers não serão criados naquele momento exato, muito pelo contrário, isso é apenas uma declaração, para que na primeira vez que vc use um Controller, Get vai saber onde procurar. Get vai continuar no formato "lazyLoad" (carrega somente quando necessário) e vai continuar descartando os Controllers quando eles não forem mais necessários. Veja pub.dev example para ver como funciona.


Se você navegar por várias rotas e precisa de algum daat que estava em um outro controller previamente utilizado, você só precisa utilizar o GetBuilder novamente (sem o init):

```dart
class OutraClasse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<Controller>(
          builder: (s) => Text('${s.counter}'),
        ),
      ),
    );
  }
```

Se você precisa utilizar seu controller em vários outros lugares, e fora do GetBuilder, apenas crie um getter no seu controller and consiga seu controller facilmente (ou use `Get.find<Controller>()`)

```dart
class Controller extends GetController {

  /// Você não precisa disso. Eu recomendo usar isso apenas 
  /// porque a sintaxe é mais fácil.
  /// com o método estático: Controller.to.counter();
  /// sem o método estático: Get.find<Contreoller>();
  /// Não há diferença em performance, nem efeito colateral por usar esse sintaxe. Só uma não precisa da tipage, e a outra forma a IDE vai autocompletar.
  static Controller get to => Get.find(); // adicione esta linha

  int counter = 0;
  void increment() {
    counter++;
    update(this); 
  }
}
```
E então você pode acessar seu controller diretamente, desse jeito:
```dart
FloatingActionButton(
  onPressed:(){
    Controller.to.increment(), 
  } // Isso é incrivelmente simples!
  child: Text("${Controller.to.counter}"),
),
```
Quando você pressionar o FloatingActionButton, todos os widgets que estão escutando a variável `counter` serão atualizados automaticamente.

#### Sem StatefulWidget;
Usar StatefulWidgets significa guardar o estado de telas inteiras desnecessariamente, mesmo porque se você precisa recarregar minimamente algum widget, você vai incorporá-lo num Consumer/Observer/BlocProvider/GetBuilder, que vai ser outro StatefulWidget.
A classe StatefulWidget é maior que a classe StatelessWidget, o que vai alocar mais memória, e isso pode não fazer uma diferença significativa com uma ou duas classes, mas com certeza vai quando você tiver 100 delas!
A não ser que você precise usar um mixin, como o `TickerProviderStateMixin`, será totalmente desnecessário usar um StatefulWidget com o Get.

Você pode chamar todos os métodos de um StatefulWidget diretamente de um GetBuilder.
Se você precisa chamar o método `initState()` ou `dispose()` por exemplo, é possível chamá-los diretamente:

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```
Uma abordagem muito melhor que isso é usar os métodos `onInit()` e `onClose()` diretamente do seu controller.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```
* Nota: Se você quiser rodar um método no momento que o controller é chamado pela primeira vez, você NÃO PRECISA usar construtores para isso, na verdade, usando um package que é focado em performance como o Get, isso chega no limite de má prática, porque se desvia da lógica que os controllers são criados ou alocados (Se você criar uma instância desse controller, o construtor vai ser chamado imediatamente, e ele será populado antes de ser usado, ou seja, você está alocando memória e não está utilizando, o que fere os princípios desse package). Os métodos `onInit()` e `onClose()` foram criados para isso, eles serão chamados quando o controller é criado, ou usados pela primeira vez, dependendo de como você está utilizando o Get (lazyPut ou não). Se quiser, por exemplo, fazer uma chamada para sua API para popular dados, você pode esquecer do estilo antigo de usar `initState()/dispose()`, apenas comece sua chamada para a api no `onInit`, e apenas se você precisar executar algum comando como fechar stream, use o `onClose()`.

O propósito desse package é precisamente te dar uma solução completa para navegação de rotas, gerenciamente de dependências e estados, usando o mínimo possível de dependências, com um alto grau de decoupling. Get envolve em todos as API de baixo e alto nível dentro de si mesmo, para ter certeza que você irá trabalhar com o mínimo possível de coupling. Nós centralizamos tudo em um único package. Dessa forma, você pode colocar somente widgets na sua view, e deixar a parte do seu time que trabalhar com a lógica de negócio livre, para que possam trabalhar sem depender de nenhum elemento da View. Isso fornece um ambiente de trabalho muito mais limpo, para que parte do seu time possa trabalhar apenas com os widgets, sem se preocupar sobre enviar dados para o controller, e outra parte do seu time trabalhe apensar com lógica de negócio, sem depender de nenhum elemento da view.

Então, para simplificar isso:

Você não precisa chamar métodos no `initState()` e enviá-los para seu controller via parâmetros, nem precisa do construtor do controller pra isso, você possui o método `onInit()` que é chamado no momento certo para você inicializar seus services.

Você não precisa chamar o método `dispose()`, você tem o método `onClose()` que vai ser chamado no momento exato quando seu controller não for mais necessário e será removido da memória. Dessa forma, você pode deixar views somente para os widgets, e o controller só para as regras de negócio.

Não chame o método `dispose()` dentro do GetController, não vai fazer nada, lembre-se que o controller não é um widget, você não deveria usar o dispose lá, e esse método será automatacimente e inteligentemente removido da memória pelo Get. Se você usou algum stream no controller e quer fechá-lo, apensar insira o método para fechar os stream dentro do método `onClose()`.

Exemplo:
```dart
class Controller extends GetController {
  var user = StreamController<User>();
  var name = StreamController<String>();

  /// close stream = onClose method, not dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```
Ciclo de vida do controller:
* `onInit()`: Onde ele é criado.
* `onClose()`: Onde ele é fechado para fazer mudanças em preparação para o método delete()
* deleted: Você não tem mais acesso a essa API porque ela está literalmente removendo o controller da memória. Está literalmente deletado, sem deixar rastros.

##### Formas de uso:

* Uso recomendado;

Você pode usar uma instância do Controller diretamente no `value` do GetBuilder

```dart
GetBuilder<Controller>(  
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //aqui
  )
),
```
Você talvez também precise de uma instância do seu controller fora do GetBuilder, e você pode usar essas abordagens para conseguir isso:

essa:
```dart
class Controller extends GetController {
  static Controller get to => Get.find(); // criando um getter estático
  [...]
}
// Numa classe stateful/stateless
GetBuilder<Controller>(
  init: Controller(), // use somente uma vez por controller, não se esqueça
  builder: (_) => Text(
    '${Controller.to.counter}', //aqui
  )
),
```

ou essa:
```dart
class Controller extends GetController {
 // sem nenhum método estático
[...]
}
// Numa classe stateful/stateless
GetBuilder<Controller>(
  init: Controller(), // use somente uma vez por controller, não se esqueça
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //aqui
  )
),
```

* Você pode usar outras abordagens "menos regulares". Se você está utilizando outro gerenciador de dependências, como o get_it, modular, etc., e só quer entregar a instância do controller, pode fazer isso:

```dart
Controller controller = Controller();
[...]
GetBuilder( // não precisa digitar desse jeito
  init: controller, //aqui
  builder: (_) => Text(
    '${controller.counter}', // aqui
  )
),

```

Essa abordagem não é recomendade, uma vez que você vai precisar descartar os controllers manualmente, fechar seus stream manualmente, e literalmente abandonar um dos grandes benefícios desse package, que é controle de memória inteligente. Mas se você confia no seu potencial, vai em frente!

Se você quiser refinar o controle de atualização de widgets do GetBuilder, você pode assinalar a ele IDs únicas
```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use somente uma vez por controller, não se esqueça
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //aqui
  )
),
```
E atualizá-los dessa forma:
```dart
update(this,['text']);
```

Você também pode impor condições para o update acontecer:
```dart
update(this,['text'], counter < 10);
```

GetX faz isso automaticamente e somente reconstrói o widget que usa a exata variável que foi alterada. Se você alterar o valor davariável para o mesmo valor que ela já era e isso não sugira uma mudança de estado, GetX não vai reconstruir esse widget, economizando memória e ciclos de CPU (Ex: 3 está sendo mostrado na tela, e você muda a variável para ter o valor 3 denovo. Na maioria dos gerenciadores de estado, isso vai causar uma reconstrução do widget, mas com o GetX o widget só vai reconstruir se de fato o estado mudou).

GetBuilder é focado precisamente em múltiplos controles de estados. Imagine que você adicionou 30 produtos ao carrinho, você clica pra deletar um deles, e ao mesmo tempos a lista é atualizada, o preço é atualizado e o pequeno círculo mostrando a quantidade de produtos é atualizado. Esse tipo de abordagem faz o GetBuilder excelente, porque ele agupa estados e muda todos eles de uma vez sem nenhuma "lógica computacional" pra isso. GetBuilder foi criado com esse tipo de situação em mente, já que pra mudanças de estados simples, você pode simplesmente usar o `setState()`, e você não vai precisar de um gerenciador de estado para isso. Porém, há situações onde você quer somente que o widget onde uma certa variável mudou seja reconstruído, e isso é o que o GetX faz com uma maestria nunca vista antes.

Dessa forma, se você quiser controlar individualmente, você pode assinalar ID's para isso, ou usar GetX. Isso é com você, apenas lembre-se que quando mais "widgets individuais" você tiver, mais a performance do GetX vai se sobressair. Mas o GetBuilder vai ser superior quando há multiplas mudanças de estado.

Você pode usar os dois em qualquer situação, mas se quiser refinar a aplicação para a melhor performance possível, eu diria isso: se as suas variáveis são alteradas em momentos diferentes, use GetX, porque não tem competição para isso quando o widget é pra reconstruir somente o que é necessário. Se você não precisa de IDs únicas, porque todas as suas variáveis serão alteradas quando você fazer uma ação, use GetBuilder, porque é um atualizador de estado em blocos simples, feito com apenas algumas linhas de código, para fazer justamente o que ele promete fazer: atualizar estado em blocos. Não há forma de comparar RAM, CPU, etc de um gerenciador de estado gigante com um simples StatefulWidget (como GetBuilder) que é atualizado quando você chama `update(this)`. Foi feito de uma forma simples, para ter o mínimo de lógica computacional, somente para cumprir um único papel e gastar o mínimo de recursos possível.
Se você quer um gerenciador de estados poderoso, você pode ir sem medo para o GetX. Ele não funciona com variáveis, mas sim fluxos. Tudo está em seus streams por baixo dos panos. Você pode usar `rxDart` em conjunto com ele, porque tudo é um stream, você pode ouvir o evento de cada "variável", porque tudo é um stream, é literalmente BLoc, só que mais fácil que MobX e sem code generators ou decorations.

## Reactive State Manager - GetX

If you want power, Get gives you the most advanced state manager you could ever have.
GetX was built 100% based on Streams, and give you all the firepower that BLoC gave you, with an easier facility than using MobX.
Without decorations, you can turn anything into Observable with just a ".obs".

Maximum performance: In addition to having a smart algorithm for minimal reconstruction, Get uses comparators to make sure the state has changed. If you experience any errors in your application, and send a duplicate change of state, Get will ensure that your application does not collapse.
The state only changes if the values ​​change. That's the main difference between Get, and using Computed from MobX. When joining two observables, when one is changed, the hearing of that observable will change. With Get, if you join two variables (which is unnecessary computed for that), GetX (similar to Observer) will only change if it implies a real change of state. Example:

```dart
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
 GetX<Controller>(
              builder: (_) {
                print("count 1 rebuild");
                return Text('${_.count1.value}');
              },
            ),
            GetX<Controller>(
              builder: (_) {
                print("count 2 rebuild");
                return Text('${_.count2.value}');
              },
            ),
            GetX<Controller>(
              builder: (_) {
                print("count 3 rebuild");
                return Text('${_.sum}');
              },
            ),
```

If we increment the number of count 1, only count 1 and count 3 are reconstructed, because count 1 now has a value of 1, and 1 + 0 = 1, changing the sum value.

If we change count 2, only count2 and 3 are reconstructed, because the value of 2 has changed, and the result of the sum is now 2.

If we add the number 1 to count 1, which already contains 1, no widget is reconstructed. If we add a value of 1 for count 1 and a value of 2 for count 2, only 2 and 3 will be reconstructed, simply because GetX not only changes what is necessary, it avoids duplicating events.

In addition, Get provides refined state control. You can condition an event (such as adding an object to a list), on a certain condition.

```dart
list.addIf(item<limit, item);
```

Without decorations, without a code generator, without complications, GetX will change the way you manage your states in Flutter, and that is not a promise, it is a certainty!

Do you know Flutter's counter app? Your Controller class might look like this:

```dart
class CountCtl extends RxController {
  final count = 0.obs;
}
```
With a simple:
```dart
ctl.count.value++
```

You could update the counter variable in your UI, regardless of where it is stored.

You can transform anything on obs:

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}

class User {
  User({String name, int age});
  final rx = RxUser();

  String get name => rx.name.value;
  set name(String value) => rx.name.value = value;

  int get age => rx.age.value;
  set age(int value) => rx.age.value = value;
}
```

```dart

void main() {
  final user = User();
  print(user.name);
  user.age = 23;
  user.rx.age.listen((int age) => print(age));
  user.age = 24;
  user.age = 25;
}
___________
out:
Camila
23
24
25

```

Before you immerse yourself in this world, I will give you a tip, always access the "value" of your flow when reading it, especially if you are working with lists where this is apparently optional.
You can access list.length, or list.value.length. Most of the time, both ways will work, since the GetX list inherits directly from the dart List. But there is a difference between you accessing the object, and accessing the flow. I strongly recommend you to access the value:
```dart
final list = List<User>().obs;
```
```dart
ListView.builder (
itemCount: list.value.lenght
```
or else create a "get" method for it and abandon "value" for life. example:

```dart
final _list = List<User>().obs;
List get list => _list.value;
```
```dart
ListView.builder (
itemCount: list.lenght
```
You could add an existing list of another type to the observable list using a list.assign (oldList); or the assignAll method, which differs from add, and addAll, which must be of the same type. All existing methods in a list are also available on GetX.

We could remove the obligation to use value with a simple decoration and code generator, but the purpose of this lib is precisely not to need any external dependency. It is to offer an environment ready for programming, involving the essentials (management of routes, dependencies and states), in a simple, light and performance way without needing any external package. You can literally add 3 letters to your pubspec (get) and start programming. All solutions included by default, from route management to state management, aim at ease, productivity and performance. The total weight of this library is less than that of a single state manager, even though it is a complete solution, and that is what you must understand. If you are bothered by value, and like a code generator, MobX is a great alternative, and you can use it in conjunction with Get. For those who want to add a single dependency in pubspec and start programming without worrying about the version of a package being incompatible with another, or if the error of a state update is coming from the state manager or dependency, or still, do not want to worrying about the availability of controllers, whether literally "just programming", get is just perfect.
If you have no problem with the MobX code generator, or have no problem with the BLoC boilerplate, you can simply use Get for routes, and forget that it has state manager. Get SEM and RSM were born out of necessity, my company had a project with more than 90 controllers, and the code generator simply took more than 30 minutes to complete its tasks after a Flutter Clean on a reasonably good machine, if your project it has 5, 10, 15 controllers, any state manager will supply you well. If you have an absurdly large project, and code generator is a problem for you, you have been awarded this solution.

Obviously, if someone wants to contribute to the project and create a code generator, or something similar, I will link in this readme as an alternative, my need is not the need for all devs, but for now I say, there are good solutions that already do that, like MobX.

## Simple Instance Manager
Are you already using Get and want to make your project as lean as possible? Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

```dart
controller.fetchApi();// Rather Controller controller = Controller();
```

Imagine that you have navigated through numerous routes, and you need a data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "find" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```
And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

Looking for lazy loading? You can declare all your controllers, and it will be called only when someone needs it. You can do this with:
```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock will only be called when someone uses Get.find<Service> for the first time
```

To remove a instance of Get:
```dart
Get.delete<Controller>();
```


## Navigate with named routes:
- If you prefer to navigate by namedRoutes, Get also supports this.

To navigate to nextScreen
```dart
Get.toNamed("/NextScreen");
```
To navigate and remove the previous screen from the tree.
```dart
Get.offNamed("/NextScreen");
```
To navigate and remove all previous screens from the tree.
```dart
Get.offAllNamed("/NextScreen");
```

To define routes, use GetMaterialApp:

```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    namedRoutes: {
      '/': GetRoute(page: MyHomePage()),
      '/second': GetRoute(page: Second()),
      '/third': GetRoute(page: Third(),transition: Transition.cupertino);
    },
  ));
}
```

### Send data to named Routes:

Just send what you want for arguments. Get accepts anything here, whether it is a String, a Map, a List, or even a class instance.
```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```
on your class or controller:

```dart
print(Get.arguments);
//print out: Get is the best
```

#### Dynamic urls links
Get offer advanced dynamic urls just like on the Web. Web developers have probably already wanted this feature on Flutter, and most likely have seen a package promise this feature and deliver a totally different syntax than a URL would have on web, but Get also solves that.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```
on your controller/bloc/stateful/stateless class:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

You can also receive NamedParameters with Get easily:

```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    namedRoutes: {
      '/': GetRoute(page: MyHomePage()),
      /// Important!  :user is not a new route, it is just a parameter
      /// specification. Do not use '/second/:user' and '/second'
      /// if you need new route to user, use '/second/user/:user' 
      /// if '/second' is a route.
      '/second/:user': GetRoute(page: Second()), // receive ID
      '/third': GetRoute(page: Third(),transition: Transition.cupertino);
    },
  ));
}
```
Send data on route name
```dart
Get.toNamed("/second/34954");
```

On second screen take the data by parameter

```dart
print(Get.parameters['user']);
// out: 34954
```

And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (you can call your routes directly from your BLoC or Controller class), and when your app is compiled to the web, your routes will appear in the url <3


#### Middleware 
If you want listen Get events to trigger actions, you can to use routingCallback to it
```dart
GetMaterialApp(
  routingCallback: (route){
    if(routing.current == '/second'){
      openAds();
    }
  }
  ```
If you are not using GetMaterialApp, you can use the manual API to attach Middleware observer.


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
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen. 
    ///If you need to enter any of these 3 events directly here, 
    ///you must specify that the event is != Than you are trying to do.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

Now, use Get on your code:

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

### Change Theme
Please do not use any higher level widget than GetMaterialApp in order to update it. This can trigger duplicate keys. A lot of people are used to the prehistoric approach of creating a "ThemeProvider" widget just to change the theme of your app, and this is definitely NOT necessary with Get.

You can create your custom theme and simply add it within Get.changeTheme without any boilerplate for that:


```dart
Get.changeTheme(ThemeData.light());
```

If you want to create something like a button that changes the theme with onTap, you can combine two Get APIs for that, the api that checks if the dark theme is being used, and the theme change API, you can just put this within an onPressed:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

When darkmode is activated, it will switch to the light theme, and when the light theme is activated, it will change to dark.


If you want to know in depth how to change the theme, you can follow this tutorial on Medium that even teaches the persistence of the theme using Get:

- [Dynamic Themes in 3 lines using Get](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).


### Optional Global Settings
You can create Global settings for Get. Just add Get.config to your code before pushing any route or do it directly in your GetMaterialApp

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
      defaultTransition = Transitions.cupertino}
```


### Other Advanced APIs and Manual configurations
GetMaterialApp configures everything for you, but if you want to configure Get Manually using advanced APIs.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
    );
```

You will also be able to use your own Middleware within GetObserver, this will not influence anything.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver(MiddleWare.observer)], // Here
    );
```

```dart
Get.arguments // give the current args from currentScreen

Get.previousArguments // give arguments of previous route

Get.previousRoute // give name of previous route

Get.rawRoute // give the raw route to access for example, rawRoute.isFirst()

Get.routing // give access to Rounting API from GetObserver

Get.isSnackbarOpen // check if snackbar is open

Get.isDialogOpen // check if dialog is open

Get.isBottomSheetOpen // check if bottomsheet is open

Get.removeRoute() // remove one route.

Get.until() // back repeatedly until the predicate returns true.

Get.offUntil() // go to next route and remove all the previous routes until the predicate returns true.

Get.offNamedUntil() // go to next named route and remove all the previous routes until the predicate returns true.

GetPlatform.isAndroid/isIOS/isWeb... //(This method is completely compatible with FlutterWeb, unlike the framework. "Platform.isAndroid")

Get.height / Get.width // Equivalent to the method: MediaQuery.of(context).size.height

Get.context // Gives the context of the screen in the foreground anywhere in your code.

Get.contextOverlay // Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.

```

### Nested Navigators

Get made Flutter's nested navigation even easier.
You don't need the context, and you will find your navigation stack by Id.

- NOTE: Creating parallel navigation stacks can be dangerous. The ideal is not to use NestedNavigators, or to use sparingly. If your project requires it, go ahead, but keep in mind that keeping multiple navigation stacks in memory may not be a good idea for RAM consumption.

See how simple it is:
```dart
             Navigator(
                key: nestedKey(1), // create a key by index
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  if (settings.name == '/') {
                    return GetRouteBase(
                      page: Scaffold(
                        appBar: AppBar(
                          title: Text("Main"),
                        ),
                        body: Center(
                          child: FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                Get.toNamed('/second', id:1); // navigate by your nested route by index
                              },
                              child: Text("Go to second")),
                        ),
                      ),
                    );
                  } else if (settings.name == '/second') {
                    return GetRouteBase(
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


This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.
