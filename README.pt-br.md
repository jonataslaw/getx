![](get.png)

*Idiomas: [English](README.md), [Brazilian Portuguese](README.pt-br.md).*

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

**Exemplo completo do app Flutter counter em somente 11 linhas de código**
```dart
void main() => runApp(GetMaterialApp(home: Home()));
class Home extends StatelessWidget {
  final count = 0.obs;
  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(title: Text("Get muda sua vida")),
    floatingActionButton: FloatingActionButton(onPressed: () => count.value++),
    body: Center(child: Obx(() => Text(count.string))),
  );
}
```

## Começando

A navegação convencional do Flutter tem uma grande quantidade de boilerplate (código que se repete demais), requer o `context` para navegar entre telas/rotas, abrir dialogs e usar snackbars no framework, e é entediante.

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
- [Gerenciamento de dependências simples](#gerenciamento-de-dependências-simples)
- [Bindings](#bindings)
  - [Como utilizar:](#como-utilizar)
- [Workers](#workers)
- [Navegar com rotas nomeadas](#navegar-com-rotas-nomeadas)
  - [Enviar dados para rotas nomeadas](#enviar-dados-para-rotas-nomeadas)
    - [Links de Url dinâmicos](#links-de-url-dinâmicos)
    - [Middleware](#middleware)
  - [Change Theme](#change-theme)
  - [Configurações Globais Opcionais](#configurações-globais-opcionais)
  - [Outras APIs avançadas e Configurações Manuais](#outras-apis-avançadas-e-configurações-manuais)
  - [Nested Navigators](#nested-navigators)




#### Você pode contribuir no projeto de várias formas:
- Ajudando a traduzir o README para outras linguagens.
- Adicionando mais documentação ao README (até o momento, nem metade das funcionalidades do Get foram documentadas).
- Fazendo artigos/vídeos ensinando a usar o Get (eles serão inseridos no README, e no futuro na nossa Wiki).
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

## Gerenciador de estado simples
Há atualmente vários gerenciadores de estados para o Flutter. Porém, a maioria deles envolve usar `ChangeNotifier` para atualizar os widgets e isso é uma abordagem muito ruim no quesito performance em aplicações de médio ou grande porte. Você pode checar na documentação oficial do Flutter que o [`ChangeNotifier` deveria ser usado com um ou no máximo dois listeners](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), fazendo-o praticamente inutilizável em qualquer aplicação média ou grande. Outros gerenciadores de estado são bons, mas tem suas nuances. BLoC é bem seguro e eficiente, mas é muito complexo (especialmente para iniciantes), o que impediu pessoas de desenvolverem com Flutter. MobX é mais fácil que o BLoc e é reativo, quase perfeito eu diria, mas você precisa usar um code generator que, para aplicações de grande porte, reduz a produtividade (você terá que beber vários cafés até que seu código esteja pronto denovo depois de um `flutter clean`, o que não é culpa do MobX, na verdade o code generator que é muito lento!). Provider usa o `InheritedWidget` para entregar o mesmo listener, como uma forma de solucionar o problema reportado acima com o ChangeNotifier, o que indica que qualquer acesso ao ChangeNotifier dele tem que ser dentro da árvore de widgets por causa do `context` necessário para acessar o Inherited.

Get não é melhor ou pior que nenhum gerenciador de estado, mas você deveria analisar esses pontos tanto quanto os argumentos abaixo para escolher entre usar Get na sua forma pura, ou usando-o em conjunto com outro gerenciador de estado. Definitivamente, Get não é o inimigo de nenhum gerenciador, porque Get é um microframework, não apenas um gerenciador, e pode ser usado tanto sozinho quanto em conjunto com eles.

Get tem um gerenciador de estado que é extremamente leve e fácil (escrito em apenas 95 linha de código), que não usa ChangeNotifier, vai atender a necessidade especialmente daqueles novos no Flutter, e não vai causar problemas em aplicações de grande porte.

**Que melhoras na performance o Get traz?**

1. Atualiza somente o widget necessário.

2. Não usa o `ChangeNotifier`, é o gerenciador de estado que utiliza menos memória (próximo de 0mb até agora).

3. Esqueça StatefulWidget's! Com Get você nunca mais vai precisar deles. Com outros gerenciadores de estado, você provavelmente precisa usar um StatefulWidget para pegar a instância do seu Provider, BLoc, MobX controller, etc. Mas já parou para pensar que seu AppBar, seu Scaffold e a maioria dos widgets que estão na sua classe são stateless? Então porque salvar o estado de uma classe inteira, se você pode salvar somente o estado de um widget stateful? Get resolve isso também. Crie uma classe Stateless, faça tudo stateless. Se você precisar atualizar um único componente, envolva ele com o `GetBuilder`, e seu estado será mantido.

4. Organize seu projeto de verdade! Controllers não devem ficar na sua UI, coloque seus `TextEditController`, ou qualquer controller que você usa dentro da classe Controller.

5. Você precisa acionar um evento para atualizar um widget assim que ele é renderizado? GetBuilder tem a propriedade `initState()` assim como um StatefulWidget, e você pode acionar eventos a partir do seu controller, diretamente de lá. Sem mais de eventos serem colocados no initState.

6. Você precisa acionar uma ação como fechar Streams, timers, etc? GetBuilder também tem a propriedade `dispose()`, onde você pode acionar eventos assim que o widget é destruído.

7. Use `Stream`s somente se necessário. Você pode usar seus StreamControllers dentro do seu controller normalmente, e usar `StreamBuilder` normalmente também, mas lembre-se, um Stream consume uma memória razoável, programação reativa é linda, mas você não abuse. 30 Streams abertos simultaneamente podem ser ainda piores que o `ChangeNotifier` (e olha que o ChangeNotifier é bem ruim)

8. Atualizar widgets sem gastar memória com isso. Get guarda somente a "ID do criador" do GetBuilder, e atualiza esse GetBuilder quando necessário. O consumo de memória do ID do GetBuilder é muito baixo mesmo para milhares de GetBuilders. Quando você cria um novo GetBuilder, na verdade você está compartilhando o estado do GetBuilder quem tem um ID do creator. Um novo estado não é criado para cada GetBuilder, o que reduz MUITO o consumo de memória RAM em aplicações grandes. Basicamente sua aplicação vai ser toda stateless, e os poucos widgets que serão Stateful (dentro do GetBuilder) vão ter um estado único, e assim atualizar um deles vai atualizar todos eles. O estado é um só.

9.  Get é onisciente e na maioria dos casos sabe o momento exato de tirar um controller da memória. Você não precisa se preocupar com quando descartar o controller, Get sabe o melhor momento para fazer isso. 

Vamos analisar o seguite exemplo: 

`Class A => Class B (ControllerX) => Class C (ControllerX)`

* Na classe A o controller não está ainda na memória, porque você ainda não o usou (Get carrega só quando precisa). 

* Na classe B você usou o controller, e ele entrou na memória. 

* Na classe C você usou o mesmo controller da classe B, então o Get vai compartilhar o estado do controller B com o controller C, e o mesmo controller ainda estará na memória.

* Se você fechar a classe C e classe B, Get vai tirar o controller X da memória automaticamente e liberar recursos, porque a classe A não está usando o controller.

* Se você navegar para a Classe B denovo, o controller X vai entrar na memória denovo.

* Se em vez de ir para a classe C você voltar para a classe A, Get vai tirar o controller da memória do mesmo jeito.

* Se a classe C não usar o controller, e você tirar a classe B da memória, nenhuma classe estaria usando o controller X, e novamente o controller seria descartado.

**Nota**: A única exceção que pode atrapalhar o Get, é se
Você remover classe B da rota de forma inesperada, e tentasse usar o controller na classe C. Nesse caso, o ID do creator do controller que estava em B seria deletado, e o Get foi programado para remover da memória todo controller que não tem nenhum ID de creator. Se é sua intenção fazer isso, adicione a config `autoRemove: false` no GetBuilder da classe B, e use `adoptID = true;` no GetBuilder da classe C. 

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

Você já aprendeu como gerenciar estados com o Get.

Nota: Você talvez queira uma maior organização, e não querer usar a propriedade `init`. Para isso, você pode criar uma classe e extendê-la da classe `Bindings`, e nela mencionar os controllers que serão criados dentro daquela rota. Controllers não serão criados naquele momento exato, muito pelo contrário, isso é apenas uma declaração, para que na primeira vez que vc use um Controller, Get vai saber onde procurar. Get vai continuar no formato "lazyLoad" (carrega somente quando necessário) e vai continuar descartando os Controllers quando eles não forem mais necessários. Veja pub.dev example para ver como funciona.

Se você navegar por várias rotas e precisa de algum dado que estava em um outro controller previamente utilizado, você só precisa utilizar o GetBuilder novamente (sem o init):

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
}
```

Se você precisa utilizar seu controller em vários outros lugares, e fora do GetBuilder, apenas crie um getter no seu controller que você consegue ele facilmente (ou use `Get.find<Controller>()` )

```dart
class Controller extends GetController {

  /// Você não precisa disso. Eu recomendo usar isso apenas 
  /// porque a sintaxe é mais fácil.
  /// com o método estático: Controller.to.counter();
  /// sem o método estático: Get.find<Controller>();
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
Usar StatefulWidget's significa guardar o estado de telas inteiras desnecessariamente, mesmo porque se você precisa recarregar minimamente algum widget, você vai incorporá-lo num Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, que vai ser outro StatefulWidget.
A classe StatefulWidget é maior que a classe StatelessWidget, o que vai alocar mais memória, e isso pode não fazer uma diferença significativa com uma ou duas classes, mas com certeza fará quando você tiver 100 delas!

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
* Nota: Se você quiser executar um método no momento que o controller é chamado pela primeira vez, você NÃO precisa usar construtores para isso, na verdade, usando um package que é focado em performance como o Get, isso chega no limite de má prática, porque se desvia da lógica de que os controllers são criados ou alocados (Se você criar uma instância desse controller, o construtor vai ser chamado imediatamente, e ele será populado antes de ser usado, ou seja, você está alocando memória e não está utilizando, o que fere os princípios desse package). Os métodos `onInit()` e `onClose()` foram criados para isso, eles serão chamados quando o controller é criado, ou usados pela primeira vez, dependendo de como você está utilizando o Get (lazyPut ou não). Se quiser, por exemplo, fazer uma chamada para sua API para popular dados, você pode esquecer do estilo antigo de usar `initState()/dispose()`, apenas comece sua chamada para a api no `onInit`, e apenas se você precisar executar algum comando como fechar stream, use o `onClose()`.

O propósito desse package é precisamente te dar uma solução completa para navegação de rotas, gerenciamente de dependências e estados, usando o mínimo possível de dependências, com um alto grau de desacoplamento. Get envolve em todas as APIs de baixo e alto nível dentro de si mesmo, para ter certeza que você irá trabalhar com o mínimo possível de acoplamento.

Nós centralizamos tudo em um único package. Dessa forma, você pode colocar somente widgets na sua view, e o controller pode ter só lógica de negócio, sem depender de nenhum elemento da View. Isso fornece um ambiente de trabalho muito mais limpo, para que parte do seu time possa trabalhar apenas com os widgets, sem se preocupar sobre enviar dados para o controller, e outra parte se preocupe apenas com a lógica de negócio, sem depender de nenhum elemento da view.

Então, para simplificar isso:

Você não precisa chamar métodos no `initState()` e enviá-los para seu controller via parâmetros, nem precisa do construtor do controller pra isso, você possui o método `onInit()` que é chamado no momento certo para você inicializar seus services.

Você não precisa chamar o método `dispose()`, você tem o método `onClose()` que vai ser chamado no momento exato quando seu controller não for mais necessário e será removido da memória. Dessa forma, você pode deixar a view somente para os widgets, e o controller só para as regras de negócio.

Não chame o método `dispose()` dentro do GetController, não vai fazer nada. Lembre-se que o controller não é um widget, você não deveria usar o dispose lá, e esse método será automaticamente e inteligentemente removido da memória pelo Get. Se você usou algum stream no controller e quer fechá-lo, apenas insira o método para fechar os stream dentro do método `onClose()`.

Exemplo:
```dart
class Controller extends GetController {
  var user = StreamController<User>();
  var name = StreamController<String>();

  /// fechar stream = método onClose(), não dispose().
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
* deleted: Você não tem acesso a essa API porque ela está literalmente removendo o controller da memória. Está literalmente deletado, sem deixar rastros.

##### Formas de uso:

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
// Na sua view/tela
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
GetBuilder<Controller>(
  init: controller, //aqui
  builder: (_) => Text(
    '${controller.counter}', // aqui
  )
),

```

Essa abordagem não é recomendada, uma vez que você vai precisar descartar os controllers manualmente, fechar seus stream manualmente, e literalmente abandonar um dos grandes benefícios desse package, que é controle de memória inteligente. Mas se você confia no seu potencial, vai em frente!

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

GetX faz isso automaticamente e somente reconstrói o widget que usa a exata variável que foi alterada. Se você alterar o valor da variável para o mesmo valor que ela era anteriormente e isso não sugira uma mudança de estado, GetX não vai reconstruir esse widget, economizando memória e ciclos de CPU (Ex: 3 está sendo mostrado na tela, e você muda a variável para ter o valor 3 denovo. Na maioria dos gerenciadores de estado, isso vai causar uma reconstrução do widget, mas com o GetX o widget só vai reconstruir se de fato o estado mudou).

GetBuilder é focado precisamente em múltiplos controles de estados. Imagine que você adicionou 30 produtos ao carrinho, você clica pra deletar um deles, e ao mesmo tempos a lista é atualizada, o preço é atualizado e o pequeno círculo mostrando a quantidade de produtos é atualizado. Esse tipo de abordagem faz o GetBuilder excelente, porque ele agupa estados e muda todos eles de uma vez sem nenhuma "lógica computacional" pra isso. GetBuilder foi criado com esse tipo de situação em mente, já que pra mudanças de estados simples, você pode simplesmente usar o `setState()`, e você não vai precisar de um gerenciador de estado para isso. Porém, há situações onde você quer somente que o widget onde uma certa variável mudou seja reconstruído, e isso é o que o GetX faz com uma maestria nunca vista antes.

Dessa forma, se você quiser controlar individualmente, você pode assinalar ID's para isso, ou usar GetX. Isso é com você, apenas lembre-se que quando mais "widgets individuais" você tiver, mais a performance do GetX vai se sobressair. Mas o GetBuilder vai ser superior quando há multiplas mudanças de estado.

Você pode usar os dois em qualquer situação, mas se quiser refinar a aplicação para a melhor performance possível, eu diria isso: se as suas variáveis são alteradas em momentos diferentes, use GetX, porque não tem competição para isso quando o widget é para reconstruir somente o que é necessário. Se você não precisa de IDs únicas, porque todas as suas variáveis serão alteradas quando você fazer uma ação, use GetBuilder, porque é um atualizador de estado em blocos simples, feito com apenas algumas linhas de código, para fazer justamente o que ele promete fazer: atualizar estado em blocos. Não há forma de comparar RAM, CPU, etc de um gerenciador de estado gigante com um simples StatefulWidget (como GetBuilder) que é atualizado quando você chama `update(this)`. Foi feito de uma forma simples, para ter o mínimo de lógica computacional, somente para cumprir um único papel e gastar o mínimo de recursos possível.
Se você quer um gerenciador de estados poderoso, você pode ir sem medo para o GetX. Ele não funciona com variáveis, mas sim fluxos. Tudo está em seus streams por baixo dos panos. Você pode usar `rxDart` em conjunto com ele, porque tudo é um stream, você pode ouvir o evento de cada "variável", porque tudo é um stream, é literalmente BLoc, só que mais fácil que MobX e sem code generators ou decorations.

## Reactive State Manager - GetX

Se você quer poder, Get té dá o mais avançado gerenciador de estado que você pode ter.
GetX foi construído 100% baseado em Stream, e te dá todo o poder de fogo que o BLoc te dá, com uma sintaxe mais fácil que a do MobX.
Sem decorations, você poder tornar qualquer coisa em um `Observable` com somete um `.obs`

Performance máxima: Somando ao fato de ter um algoritmo inteligente para reconstrução mínima, Get usa comparadores para ter certeza que o estado mudou. Se você encontrar erros na sua aplicação, e enviar uma mudança de estado duplicada, Get vai ter certeza que sua aplicação não entre em colapso.

O estado só muda se o valor mudar. Essa é a principal diferença entre Get, e usar o `Computed` do MobX. Quando juntar dois observables, se um deles é alterado, a escuta daquele observable vai mudar. Com Get, se você juntar duas variáveis (que na verdade é desnecessário), GetX(similar ao Observer) vai somente mudar se implicar numa mudança real de estado. Exemplo:

```dart
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
GetX<Controller>(
  builder: (_) {
    print("count 1 foi reconstruído");
    return Text('${_.count1.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("count 2 foi reconstruído");
    return Text('${_.count2.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("sum foi reconstruído");
    return Text('${_.sum}');
  },
),
```
Se nós incrementarmos o número do `count1`, somente `count1` e `sum` serão reconstruídos, porque `count1` agora tem um valor de 1, e 1 + 0 = 1, alterando o valor do `sum`.

Se nós mudarmos `count2`, somente `count2` e `sum` serão reconstruídos, porque o valor do 2 mudou, e o resultado da variável `sum` é agora 2.

Se definirmos o valor de `count1` para 1, nenhum widget será reconstruído, porque o valor já era 1.

Se definirmos o valor de `count1` para 1 denovo, e definirmos o valor de `count2` para 2, então somente o `count2`e o `sum` vão ser reconstruídos, simplesmente porque o GetX não somente altera o que for necessário, ele também evita eventos duplicados.

Somando a isso, Get provê um controle de estado refinado. Você pode adicionar uma condição a um evento (como adicionar um objeto a uma lista).

```dart
list.addIf(item < limit, item);
```

Sem decorations, sem code generator, sem complicações, GetX vai mudar a forma que você controla seus estados no Flutter, e isso não é uma promessa, isso é uma certeza!

Sabe o app de contador do Flutter? Sua classe Controller pode ficar assim:
```dart
class CountController extends RxController {
  final count = 0.obs;
}
```
E com um simples:
```dart
controller.count.value++
```

Você pode atualizar a variável counter na sua UI, independente de onde esteja sendo armazenada.

Você pode transformar qualquer coisa em obs:
```dart
class RxUsuario {
  final nome = "Camila".obs;
  final idade = 18.obs;
}

class Usuario {
  Usuario({String nome, int idade});
  final rx = RxUsuario();

  String get nome => rx.nome.value;
  set nome(String value) => rx.nome.value = value;

  int get idade => rx.idade.value;
  set idade(int value) => rx.idade.value = value;
}
```

```dart

void main() {
  final usuario = Usuario();
  print(usuario.nome);
  usuario.idade = 23;
  usuario.rx.idade.listen((int idade) => print(idade));
  usuario.idade = 24;
  usuario.idade = 25;
}
___________
saída:
Camila
23
24
25
```

Trabalhar com `Lists` usando Get é algo muito agradável. Elas são completamente observáveis assim como os objetos dentro dela. Dessa forma, se você adicionar uma valor a lista, ela vai automaticamente reconstruir os widgets que a usam.

Você também não precisa usar `.value` com listas, a api dart nos permitiu remover isso. Infelizmente tipos primitivos como String e int não podem ser extendidos, fazend o uso de `.value` obrigatório, mas isso não será um problema se você usar getters e setters para esses.
```dart
final list = List<Usuario>().obs;

ListView.builder (
itemCount: list.lenght
)
```

Você não precisa trabalhar com sets se não quiser. Você pode usar as APIs `assign` e `assignAll`

A api `assign` vai limpar sua lista e adicionar um único objeto que você quer.

A api `assignAll`  vai limpar sua lista e vai adicionar objetos `Iterable` que você precisa.

Nós poderíamos remover a obrigação de usar o value em String e int com uma simples decoration e code generator, mas o propósito desse package é precisamente não precisar de nenhuma dependência externa. É para oferecer um ambiente pronto para programar, envolvendo os essenciais (gerenciamento de rotas, dependências e estados), numa forma simples, leve e performática sem precisar de packages externos. Você pode literalmente adicionar 3 letras e um ':' no seu pubspec.yaml e começar a programar. Todas as soluções incluídas por padrão, miram em facilidade, produtividade e performance.

O peso total desse package é menor que o de um único gerenciador de estado, mesmo sendo uma solução completa, e isso é o que você precisa entender.

Se você está incomodado com o `.value`, e gosta de code generator, MobX é uma excelente alternativa, e você pode usá-lo em conjunto com o Get. Para aqueles que querem adicionar uma única dependência no pubspec.yaml e começar a programar sem se preocupar sobre a versão de um package sendo incompatível com outra, ou se o erro de uma atualização do estado está vindo do gerenciador de estado ou da dependência, ou ainda, não quer se preocupar com a disponibilidade de controllers, prefere literalmente "só programar", Get é perfeito.

Agora se você não tem problemas com o code generator do MobX, ou não vê problema no boilerplate do BLoc, você pode simplesmente usar o Get para rotas, e esquecer que nele existe um gerenciador de estado. Get nasceu da necessidade, minha empresa tinha um projeto com mais de 90 controllers e o code generator simplesmente levava mais de 30 minutos para completar suas tarefas depois de um `flutter clean` numa máquina razoavelmente boa, se o seu projeto tem 5, 10, 15 controllers, qualquer gerenciador de estado vai ter satisfazer.

Se você tem um projeto absurdamente grande, e code generator é um problema para você, então você foi presenteado com essa solução que é o Get.

Obviamente, se alguém quiser contribuir para o projeto e criar um code generator, or algo similar, eu vou linkar no README como uma alternativa, minha necessidade não é a necessidade de todos os devs, mas por agora eu digo: há boas soluções que já fazem isso, como MobX.

Tipagem no Get usando Bindings é desnecessário. Você pode usar o widget `Obx()` em vez do GetX, e ele só recebe a função anônima que cria o widget.

## Gerenciamento de dependências simples

* Nota: Se você está usando o gerenciado de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api `Bindings`, que vai fazer tudo isso automaticamente para você.

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

Para remover a instância do Get:
```dart
Get.delete<Controller>();
```

## Bindings
Um dos grandes diferenciais desse package, talvez, seja a possibilidade de integração total com rotas, gerenciador de estado e gerenciador de dependências.

Quando uma rota é removida da stack, todos os controllers, variáveis e instâncias de objetos relacionados com ela são removidos da memória. Se você está usando streams ou timer, eles serão fechados automaticamente, e você não precisa se preocupar com nada disso.

Na versão 2.10 Get implementou completamente a API Bindings.

Agora você não precisa mais usar o método `init`. Você não precisa nem tipar seus controllers se não quiser. Você pode começar seus controllers e services num lugar apropriado para isso.

A classe Binding é uma classe que vai desacoplar a injeção de dependência, enquanto liga as rotas ao gerenciador de estados e o gerenciador de dependências.

Isso permite Get saber qual tela está sendo mostrada quando um controller particular é usado e saber onde e como descartar o mesmo.

Somando a isso, a classe Binding vai permitir que você tenha um controle de configuração SmartManager. Você pode configurar as dependências que serão organizadas quando for remover a rota da stack, ou quando o widget que usa ele é definido, ou nada disso. Você vai ter gerenciador de dependências inteligente trabalhando para você, e você pode configurá-lo como quiser.

### Como utilizar:
* Para usar essa API você só precisa criar uma classe que implementa a Bindings:

```dart
class HomeBinding implements Bindings {}
```

Sua IDE vai automaticamente te perguntar para dar override no método `dependencies()`, aí você clica na lâmpada, clica em "override the method", e insira todas as classes que você vai usar nessa rota:

```dart
class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
    Get.lazyPut<Service>(()=> Api());
  }
}
```

Agora você só precisa informar sua rota que você vai usar esse binding para fazer a conexão entre os gerenciadores de rotas, dependências e estados.

Usando rotas nomeadas
```dart
namedRoutes: {
  '/': GetRoute(Home(), binding: HomeBinding())
}
```

Usando rotas normais: 
```dart
Get.to(Home(), binding: HomeBinding());
```

Então, você não vai precisar se preocupar com gerenciamento da memória da sua aplicação mais, Get vai fazer para você.


## Workers
Workers vai te dar suporte, ativando callbacks específicos quando um evento ocorrer.

```dart
/// Chamada toda vez que a variável for alterada
ever(count1, (value) => print("novo valor: $value"));

/// Chamada apenas na primeira vez que a variável for alterada
once(count1, (value) => print("novo valor: $value (não vai mudar mais)"));

/// Anti DDos - Chamada toda vez que o usuário parar de digitar por 1 segundo, por exemplo.
debounce(count1, (value) => print("debouce $value"), time: Duration(seconds: 1));

/// Ignore todas as mudanças num período de 1 segundo.
interval(count1, (value) => print("interval $value"), time: Duration(seconds: 1));
```
- **ever**
é chamado toda vez que a variável mudar de valor. É só isso.

- **once**
é chamado somente na primeira vez que a variável mudar de valor.

- **debounce**
É muito útil em funções de pesquisa, onde você somente quer que a API seja chamada depois que o usuário terminar de digitar. Normalmente, se o usuário digitar "Jonny", será feita 5 requests na sua API, pelas letras 'J', 'o', 'n', 'n' e 'y'. Com o `debounce` isso não acontece, porque você tem a sua disposição uma função que só fazer a pesquisa na api quando o usuário parar de digitar. O `debounce` é bom para táticas anti-DDos, para funções de pesquisa em que cada letra digitada ativaria um request na API. Debounce vai esperar o usário parar de digitar o nome, para então fazer o request para API.

- **interval**
Quando se usa `debounce` , se o usuário fizer 1000 mudanças numa variável em 1 segundo, o `debounce` só computa a última mudança feita após a inatividade por um tempo estipulado (o padrão é 800 milisegundos). `interval` por outro lado vai ignorar todas as ações do usuário pelo período estipulado. Se o `interval` for de 1 segundo, então ele só conseguirá enviar 60 eventos por segundo. Se for 3 segundos de prazo, então o `interval` vai enviar 20 eventos por minuto (diferente do `debounce` que só enviaria o evento depois que o prazo estipulado acabar). Isso é recomendado para evitar abuso em funções que o usuário pode clicar rapidamente em algo para ter uma vantagem. Para exemplificar, imagine que o usuário pode ganhar moedas clicando num botão. Se ele clicar 300 vezes no botão em um minuto, ele vai ganhar 300 moedas. Usando o `interval`, você pode definir um prazo de 1 segundo por exemplo, e mesmo se ele clicasse 300 vezes em um minuto, ele ganharia apenas 60 moedas. Se fosse usado o `debounce`, o usuário ganharia apenas 1 moeda, porque só é executado quando o usuário para de clicar por um prazo estabelecido.

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
      namedRoutes: {
        '/': GetRoute(page: MyHomePage()),
        '/login': GetRoute(page: Login()),
        '/cadastro': GetRoute(page: Cadastro(),transition: Transition.cupertino);
      },
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
    namedRoutes: {
      '/': GetRoute(page: MyHomePage()),
      /// Importante! ':user' não é uma nova rota, é somente uma
      /// especificação do parâmentro. Não use '/segunda/:user/' e '/segunda'
      /// se você precisa de uma nova rota para o user, então
      /// use '/segunda/user/:user' se '/segunda' for uma rota
      '/segunda/:user': GetRoute(page: Segunda()), // recebe a ID
      '/terceira': GetRoute(page: Terceira(),transition: Transition.cupertino);
    },
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
### Outras APIs avançadas e Configurações Manuais

GetMaterialApp configura tudo para você, mas se quiser configurar Get manualmente, você pode usando APIs avançadas.
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
  navigatorObservers: [GetObserver(MiddleWare.observer)], // Aqui
);
```

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

// Equivalente ao método: MediaQuery.of(context).size.height
Get.height

// Equivalente ao método: MediaQuery.of(context).size.width
Get.width

// forncece o context da tela em qualquer lugar do seu código.
Get.context

// fornece o context de snackbar/dialog/bottomsheet em qualquer lugar do seu código.
Get.contextOverlay

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

Essa biblioteca sempre será atualizada e terá sempre nova features sendo implementadas. Sinta-se livre para oferecer PRs e contribuir com o package.


<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Me compre um café" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>