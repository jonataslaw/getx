> GetX 5 RC: Este candidato ainda não foi publicado. A base validada é Flutter 3.47.9 e Dart 3.13.7 com as bibliotecas de interface incluídas no Flutter.

[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Idiomas: [Inglês](README.md), [Vietnamita](README-vi.md), [Indonésia](README.id-ID.md), [Urdu](README.ur-PK.md), [Chinês](README.zh-cn.md), Português (este arquivo), [Espanhol](README-es.md), [Russo](README.ru.md), [Polonês](README.pl.md), [Coreano](README.ko-kr.md), [Francês](README-fr.md)**

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

<h2> Pedimos desculpas por qualquer parte não traduzida aqui. O GetX™ é atualizado com muita frequência e as traduções podem não vir ao mesmo tempo. Então, para manter essa documentação pelo menos com tudo que a versão em inglês tem, eu vou deixar todos os textos não-traduzidos aqui (eu considero que é melhor ele estar lá em inglês do que não estar), então se alguém quiser traduzir, seria muito útil 😁</h2>

## Sumário

  - [Mudanças do GetX 5 nesta branch](#getx5-current)
- [Sobre Get](#readme-section-2)
- [Instalando](#readme-section-3)
- [App Counter usando GetX](#readme-section-4)
- [Os três pilares](#readme-section-5)
  - [Gerenciamento de estado](#readme-section-6)
    - [Reactive state manager](#readme-section-7)
    - [Mais detalhes sobre gerenciamento de estado](#readme-section-8)
    - [Explicação em video do gerenciamento de estado](#readme-section-9)
  - [Gerenciamento de rotas](#readme-section-10)
    - [Mais detalhes sobre gerenciamento de rotas](#readme-section-11)
    - [Explicação em video do gerenciamento de rotas](#readme-section-12)
  - [Gerenciamento de Dependência](#readme-section-13)
    - [Mais detalhes sobre gerenciamento de dependências](#readme-section-14)
- [Utilidades](#readme-section-15)
  - [Internacionalização](#readme-section-16)
    - [Traduções](#readme-section-17)
    - [Usando traduções](#readme-section-18)
    - [Localidade](#readme-section-19)
    - [Alterar local](#readme-section-20)
    - [Localidade do sistema operacional](#readme-section-21)
  - [Mudar tema (changeTheme)](#readme-section-22)
  - [GetConnect](#readme-section-23)
    - [Configuração Padrão](#readme-section-24)
    - [Configuração Personalizada](#readme-section-25)
  - [GetPage Middleware](#readme-section-26)
    - [Priority](#readme-section-27)
    - [Redirect](#readme-section-28)
    - [onPageCalled](#readme-section-29)
    - [OnBindingsStart](#readme-section-30)
    - [OnPageBuildStart](#readme-section-31)
    - [OnPageBuilt](#readme-section-32)
    - [OnPageDispose](#readme-section-33)
  - [Outras APIs avançadas](#readme-section-34)
    - [Configurações Globais opcionais e configurações manuais](#readme-section-35)
    - [Widgets de Estado Local](#readme-section-36)
    - [ValueBuilder](#readme-section-37)
    - [ObxValue](#readme-section-38)
    - [Explicação em vídeo sobre Outras Features do GetX](#readme-section-39)
  - [Dicas Úteis](#readme-section-40)
    - [GetView](#readme-section-41)
    - [GetWidget](#readme-section-42)
    - [GetxService](#readme-section-43)
- [Breaking Changes da versão 2 para 3](#readme-section-44)
  - [Tipagem Rx](#readme-section-45)
  - [RxController e GetBuilder se uniram](#readme-section-46)
  - [Rotas nomeadas](#readme-section-47)
    - [Porque essa mudança?](#readme-section-48)
- [Por que GetX™?](#readme-section-49)
- [Comunidade](#readme-section-50)
  - [Canais da comunidade](#readme-section-51)
  - [Como contribuir](#readme-section-52)
  - [Artigos e vídeos](#readme-section-53)

<a id="getx5-current"></a>

## Mudanças do GetX 5 nesta branch

Este candidato ainda não foi publicado. A base validada é Flutter 3.47.9 e Dart 3.13.7 com as bibliotecas de interface incluídas no Flutter.

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

Binding retorna `List<Bind>`. Use binds na aplicação e bindings nas rotas. Get.spawn substitui Get.create; aguarde a inicialização assíncrona e registre o valor com Get.put.

```dart
class RcNamesController extends GetxController with StateMixin<List<String>> {
  final labels = RxSet<String>();

  void showNames(List<String> names) =>
      change(GetStatus<List<String>>.success(names));

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
}

class RcNamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<RcNamesController>(() => RcNamesController()),
  ];
}

Widget rcNamesApplication() => GetMaterialApp(
  restorationScopeId: 'names-app',
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      restorationId: 'names',
      bindings: [RcNamesBinding()],
      page: () => Scaffold(
        body: Get.find<RcNamesController>().obx(
          (names) => Text(names.join(', ')),
          onEmpty: const Text('No data'),
          onError: (error) => Text(error ?? 'Unknown error'),
        ),
      ),
    ),
  ],
);
```

`GetStatus<T>.success(data)` contém os dados. futurize recebe uma função que cria Future e retorna void; os resultados seguem a ordem de conclusão. Coleções Rx vazias possuem armazenamento mutável independente.

A navegação usa Navigator 2. Get.back retorna páginas; feche diálogos, sheets e snackbars com helpers específicos. Get.context e Get.overlayContext podem ser null fora do ciclo de vida da aplicação.

Configure restorationScopeId e restorationId estáveis para restaurar o histórico nomeado. Argumentos compatíveis com JSON têm limites e passam pelo middleware; após a morte do processo são criados novos controllers e Futures.

Foram corrigidos a remoção de response modifiers e erros de autenticação, timeout, cancelamento e decodificação. HTTP/WebSocket são testados em IO, navegador e JS/WASM com liberação de recursos.

A limitação de percent-encoding no histórico web do Flutter 3.47.9 permanece documentada; testes web comuns não indicam sua correção. Teste refresh, back e restauração no host e dispositivo reais.

Configure GetMaterialApp ou GetCupertinoApp em vez do antigo Get.config. Um router personalizado exige configuração completa do Navigator 2.

GetNavigator e GetRouterOutlet.pickPages substituem `onPopPage` por `onDidRemovePage`, uma notificação após remover a página. Use `GetPage.canPop` ou `PopScope` para vetar back; o callback personalizado do outlet deve encaminhar para `delegate.didRemovePage`.

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# Sobre Get

- Get é uma biblioteca poderosa e extraleve para Flutter. Ela combina um gerenciador de estado de alta performance, injeção de dependência inteligente e gerenciamento de rotas de uma forma rápida e prática.

- GetX™ possui 3 princípios básicos, o que significa que esta é a prioridade para todos os recursos da biblioteca: **PRODUTIVIDADE, PERFORMANCE AND ORGANIZAÇÃO.**

  - **Desempenho:** GetX oferece APIs reativas e de streams sem criar manualmente um StreamController/StreamBuilder por valor. Escolha Obx ou GetBuilder conforme as atualizações e meça reconstruções e recursos da aplicação.

  - **PRODUTIVIDADE**: GetX™ usa uma sintaxe fácil e agradável. Não importa o que você queira fazer, sempre há uma maneira mais fácil com GetX™. Isso economizará horas de desenvolvimento e extrairá o máximo de desempenho que seu aplicativo pode oferecer.
  Geralmente, o desenvolvedor deve se preocupar em remover os controladores da memória. Com GetX™, isso não é necessário porque, por padrão, os recursos são removidos da memória quando não são usados. Se quiser mantê-lo na memória, você deve declarar explicitamente "permanent: true" em sua dependência. Dessa forma, além de economizar tempo, você corre menos risco de ter dependências desnecessárias na memória. O carregamento da dependência também é lazy por padrão.

  - **ORGANIZAÇÃO**: GetX™ permite o desacoplamento total da View, lógica de apresentação, lógica de negócios, injeção de dependência e navegação. Você não precisa de contexto para navegar entre as rotas, portanto, você não depende da árvore do widget (visualização) para isso. Você não precisa de contexto para acessar seus Controllers/BLoCs por meio de um inheritedWidget, então você desacopla completamente sua lógica de apresentação e lógica de negócios de sua camada de visualização. Você não precisa injetar suas classes Controllers/Models/BLoCs em sua árvore de widgets através de multiproviders, pois GetX™ usa seu próprio recurso de injeção de dependência, desacoplando a DI de sua View completamente. 
  Com GetX™ você sabe onde encontrar cada recurso de sua aplicação, tendo o código limpo por padrão. Isso além de facilitar a manutenção, torna o compartilhamento dos módulos, algo que até então em Flutter era impensável, em algo totalmente possível.
  O BLoC foi um ponto de partida para organizar o código no Flutter, ele separa a lógica de negócios da visualização. GetX™ é uma evolução natural disso, separando não apenas a lógica de negócios, mas a lógica de apresentação. O bônus da injeção de dependências e rotas também são dissociadas e a camada de dados está fora de tudo. Você sabe onde está tudo e tudo isso de uma maneira mais fácil do que construir um hello world. 
  GetX™ é a maneira mais fácil, prática e escalonável de construir aplicativos de alto desempenho com o Flutter SDK, com um grande ecossistema em torno dele que funciona perfeitamente em conjunto, sendo fácil para iniciantes e preciso para especialistas. É seguro, estável, atualizado e oferece uma grande variedade de APIs integradas que não estão presentes no Flutter SDK padrão.

- GetX™ não é inchado. Possui uma infinidade de recursos que permitem que você comece a programar sem se preocupar com nada, mas cada um desses recursos está em contêineres separados e só são iniciados após o uso. Se você usar apenas o Gerenciamento de estado, apenas o Gerenciamento de estado será compilado. Se você usar apenas rotas, nada do gerenciamento de estado será compilado. 

- GetX™ possui um enorme ecossistema, uma grande comunidade, um grande número de colaboradores e será mantido enquanto o Flutter existir. Getx também é capaz de rodar com o mesmo código no Android, iOS, Web, Mac, Linux, Windows e em seu servidor.
**É possível reutilizar totalmente seu código feito no frontend em seu backend com [Get Server](https://github.com/jonataslaw/get_server)**.

**Além disso, todo o processo de desenvolvimento pode ser totalmente automatizado, tanto no servidor quanto no front-end com **[Get CLI](https://github.com/jonataslaw/get_cli)**.

**Além disso, para aumentar ainda mais sua produtividade, temos a [extensão para VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) e a [extensão para Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

<a id="readme-section-3"></a>

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

<a id="readme-section-4"></a>

# App Counter usando GetX

O app 'Counter' criado por padrão no flutter com o comando `flutter create` tem mais de 100 linhas(incluindo os comentários). Para demonstrar o poder do Get, irei demonstrar como fazer o mesmo 'Counter' mudando o estado em cada toque trocando entre páginas e compartilhando o estado entre telas. Tudo de forma organizada, separando a lógica de negócio da View, COM SOMENTE 26 LINHAS INCLUINDO COMENTÁRIOS

- Passo 1:
Troque `MaterialApp` para `GetMaterialApp`

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- **Obs:** Isso não modifica o `MaterialApp` do Flutter, GetMaterialApp não é uma versão modificada do MaterialApp, é só um Widget pré-configurado, que tem como child o MaterialApp padrão. Você pode configurar isso manualmente, mas definitivamente não é necessário. GetMaterialApp vai criar rotas, injetá-las, injetar traduções, injetar tudo que você precisa para navegação por rotas (gerenciamento de rotas). Se você quer somente usar o gerenciador de estado ou somente o gerenciador de dependências, não é necessário usar o GetMaterialApp. Ele somente é necessário para:
  - Rotas
  - Snackbars/bottomsheets/dialogs
  - apis relacionadas a rotas e a ausência de `context`
  - Internacionalização
- **Obs²:** Esse passo só é necessário se você for usar o gerenciamento de rotas (`Get.to()`, `Get.back()` e assim por diante), Se você não vai usar isso então não é necessário seguir o passo 1

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

  @override
  Widget build(context) { 

    // Instancie sua classe usando Get.put() para torná-la disponível para todas as rotas subsequentes
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> para atualizar Text() sempre que a contagem é alterada.
      appBar: AppBar(title: Obx(() => Text("Total de cliques: ${c.count}"))),

      // Troque o Navigator.push de 8 linhas por um simples Get.to(). Você não precisa do 'context'
      body: Center(child: ElevatedButton(
              child: Text("Ir pra Outra tela"), onPressed: () => Get.to(() => Outra()))),
      floatingActionButton: 
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  } 
}

class Outra extends StatelessWidget {
  // Você pode pedir o Get para encontrar o controller que foi usado em outra página e redirecionar você pra ele.
  final Controller c = Get.find();
  @override
  Widget build(context) => Scaffold(body: Center(child: Text("${c.count}")));
}
```

Resultado:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Esse é um projeto simples mas já deixa claro o quão poderoso o Get é. Enquanto seu projeto cresce, essa diferença se torna bem mais significante.

Get foi feito para funcionar com times, mas torna o trabalho de um desenvolvedor individual simples.

Melhore seus prazos, entregue tudo a tempo sem perder performance. Get não é para todos, mas se você identificar com o que foi dito acima, Get é para você!


<a id="readme-section-5"></a>

# Os três pilares

<a id="readme-section-6"></a>

## Gerenciamento de estado

GetX™ possui dois gerenciadores de estado diferentes: o gerenciador de estado simples (vamos chamá-lo de GetBuilder) e o gerenciador de estado reativo (GetX/Obx)

<a id="readme-section-7"></a>

### Reactive state manager

Programação reativa pode alienar muitas pessoas porque é dito que é complicado. GetX™ transforma a programação reativa em algo bem simples:

* Você não precisa criar StreamControllers
* Você não precisa criar um StreamBuilder para cada variável
* Você não precisa criar uma classe para cada estado
* Você não precisa criar um get para o valor inicial
* Você não precisará usar geradores de código

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

<a id="readme-section-8"></a>

### Mais detalhes sobre gerenciamento de estado

**Veja uma explicação mais completa do gerenciamento de estado [aqui](./documentation/pt_BR/state_management.md). Lá terá mais exemplos e também a diferença do simple state manager do reactive state manager**

<a id="readme-section-9"></a>

### Explicação em video do gerenciamento de estado

Amateur Coder fez um vídeo ótimo sobre o gerenciamento de estado! (em inglês). Link: [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw)

Você vai ter uma boa idea do poder do GetX™

<a id="readme-section-10"></a>

## Gerenciamento de rotas

Se você for usar routes / snackbars / dialogs / bottomsheets sem contexto, GetX™ é excelente para você também, veja:

Adicione "Get" antes do seu MaterialApp, transformando-o em GetMaterialApp

```dart
GetMaterialApp( // Antes: MaterialApp(
  home: MyHome(),
)
```

Para navegar para uma próxima tela:

```dart
Get.to(() => ProximaTela());
```

Para navegar para uma próxima tela com uma rota nomeada. Veja mais detalhes sobre rotas nomeadas [aqui](./documentation/pt_BR/route_management.md#navegar-com-rotas-nomeadas)

```dart
Get.toNamed('/detalhes');
```

Para fechar snackbars, dialogs, bottomsheets, ou qualquer coisa que você normalmente fecharia com o `Navigator.pop(context)` (como por exemplo fechar a View atual e voltar para a anterior):

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

Para ir para a próxima tela e NÃO deixar opção para voltar para a tela anterior (bom para SplashScreens, telas de login e etc.):

```dart
Get.off(() => ProximaTela());
```

Para ir para a próxima tela e cancelar todas as rotas anteriores (útil em telas de carrinho, votações ou testes):

```dart
Get.offAll(() => ProximaTela());
```

Para navegar para a próxima rota e receber ou atualizar dados assim que retornar da rota:

```dart
var dados = await Get.to(() => Pagamento());
```

Notou que você não precisou usar `context` para fazer nenhuma dessas coisas? Essa é uma das maiores vantagens de usar o gerenciamento de rotas do GetX™. Com isso, você pode executar todos esse métodos de dentro da classe Controller, sem preocupações.

<a id="readme-section-11"></a>

### Mais detalhes sobre gerenciamento de rotas

**GetX™ funciona com rotas nomeadas também! Veja uma explicação mais completa do gerenciamento de rotas [aqui](./documentation/pt_BR/route_management.md)**

<a id="readme-section-12"></a>

### Explicação em video do gerenciamento de rotas

Amateur Coder fez um outro vídeo excelente sobre gerenciamento de rotas! Link: [Complete Getx Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI)

<a id="readme-section-13"></a>

## Gerenciamento de Dependência

- Nota: Se você está usando o gerenciador de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api `Bindings`, que vai fazer tudo isso automaticamente para você.

Já está usando o Get e quer fazer seu projeto o melhor possível? Get tem um gerenciador de dependência simples e poderoso que permite você pegar a mesma classe que seu Bloc ou Controller com apenas uma linha de código, sem Provider context, sem inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Em vez de Controller controller = Controller();
```

Em vez de instanciar sua classe dentro da classe que você está usando, você está instanciando ele dentro da instância do Get, que vai fazer ele ficar disponível por todo o App para que então você possa usar seu controller (ou uma classe Bloc) normalmente


**Dica:** O gerenciamento de dependência Get é desacoplado de outras partes do pacote, então se, por exemplo, seu aplicativo já estiver usando um gerenciador de estado (qualquer um, não importa), você não precisa reescrever tudo, você pode usar esta injeção de dependência sem problemas

```dart
controller.fetchApi();
```

Agora, imagine que você navegou por inúmeras rotas e precisa de dados que foram deixados para trás em seu controlador. Você precisaria de um gerenciador de estado combinado com o Provider ou Get_it, correto? Não com Get. Você só precisa pedir ao Get para "procurar" pelo seu controlador, você não precisa de nenhuma dependência adicional para isso:

```dart
Controller controller = Get.find();
// Sim, parece Magia, o Get irá descobrir qual é seu controller e irá te entregar.
// Você pode ter 1 milhão de controllers instanciados, o Get sempre te entregará o controller correto.
// Apenas se lembre de Tipar seu controller, final controller = Get.find(); por exemplo, não irá funcionar.
```

E então você será capaz de recuperar os dados do seu controller que foram obtidos anteriormente:

```dart
Text(controller.textFromApi);
```

Procurando por `lazyLoading` (carregar somente quando for usar)? Você pode declarar todos os seus controllers e eles só vão ser inicializados e chamados quando alguém precisar. Você pode fazer isso

```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock só será chamado quando alguém usar o Get.find<Service> pela primeira vez
```

<a id="readme-section-14"></a>

### Mais detalhes sobre gerenciamento de dependências

**Veja uma explicação mais completa do gerenciamento de dependência [aqui](./documentation/pt_BR/dependency_management.md)**

<a id="readme-section-15"></a>

# Utilidades

<a id="readme-section-16"></a>

## Internacionalização
<a id="readme-section-17"></a>

### Traduções
Nós mantemos as traduções num simples dictionary map de chave-valor.
Para adicionar traduções personalizadas, crie uma classe e estenda `Translations`.

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

<a id="readme-section-18"></a>

#### Usando traduções
Basta anexar `.tr` a chave especificada e ela será traduzida, usando o valor atual de `Get.locale` ou `Get.fallbackLocale`.
```dart
Text('hello'.tr);
```

<a id="readme-section-19"></a>

### Localidade
Passe parâmetros para `GetMaterialApp` definir a localidade e as traduções.

```dart
return GetMaterialApp(
    translations: Messages(), // suas traduções
    locale: Locale('en', 'US'), // as traduções serão exibidas para esta localidade
    fallbackLocale: Locale('en', 'UK'), // especifica uma localidade em caso de falha na localidade definida
);
```

<a id="readme-section-20"></a>

#### Alterar local
Use `Get.updateLocale(locale)` para atualizar a localidade. As traduções usarão automaticamente a nova localidade e a UI será atualizada.
```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-21"></a>

#### Localidade do sistema operacional
Para ler a localidade do sistema operacional, você pode usar `Get.deviceLocale`.
```dart
import 'dart:ui' as ui;

return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

<a id="readme-section-22"></a>

## Mudar tema (changeTheme)

Por favor não use widget acima do GetMaterialApp para atualizar o tema. Isso pode causar keys duplicadas. Várias pessoas estão acostumadas com o jeito normal de criar um Widget `ThemeProvider` só pra alterar o tema do app, mas isso definitivamente NÃO é necessário com GetX™.

Você pode criar seu tema customizado e simplesmente adicionar dentro do `Get.changeTheme` sem nenhum boilerplate para isso:

```dart
Get.changeTheme(ThemeData.light())
```

Se você quer criar algo como um botão que muda o tema com o toque, você pode combinar duas APIs GetX™ pra isso:
- A API que checa se o tema dark está sendo aplicado;
- A API de mudar o tema e colocar isso no `onPressed:`

```dart
Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark())
```

Quando o modo Dark está ativado, ele vai trocar pro modo light e vice versa.

Se você quiser saber mais como trocar o tema, você pode seguir esse tutorial no Medium que até ensina persistência do tema usando Get (e SharedPreferences):

- [Dynamic Themes in 3 lines using Get](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).


<a id="readme-section-23"></a>

## GetConnect
GetConnect é uma maneira fácil de se comunicar de trás para a frente com http ou websockets

<a id="readme-section-24"></a>

### Configuração Padrão
Você pode simplesmente estender GetConnect e usar os métodos GET/POST/PUT/DELETE/SOCKET para se comunicar com sua API Rest ou websockets.

```dart
class ApiUser {
  ApiUser(this.name);
  final String name;

  static ApiUser fromJson(dynamic data) =>
      ApiUser((data as Map<String, dynamic>)['name'] as String);
}

class UserProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response<ApiUser>> getUser(int id) =>
      get<ApiUser>('/users/$id', decoder: ApiUser.fromJson);

  Future<Response<dynamic>> createUser(String name) =>
      post<dynamic>('/users', {'name': name});

  Future<Response<dynamic>> uploadAvatar(List<int> bytes) =>
      post<dynamic>('/upload', FormData({
        'file': MultipartFile(bytes, filename: 'avatar.png'),
      }));
}
```
<a id="readme-section-25"></a>

### Configuração Personalizada
GetConnect é altamente personalizável, você pode definir uma base Url, modificadores de resposta, modificadores de Requests, definir um autenticador e até o número de tentativas em que tentará se autenticar, além de dar a possibilidade de definir um decodificador padrão que irá transformar todas as suas solicitações em seus modelos sem qualquer configuração adicional.

```dart
class HomeProvider extends GetConnect {
  HomeProvider(this.token);
  final String Function() token;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
    httpClient.addResponseModifier<dynamic>((request, response) {
      Get.log('HTTP status: ${response.statusCode}');
      return response;
    });
    httpClient.addAuthenticator<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token()}';
      return request;
    });
    httpClient.maxAuthRetries = 2;
  }

  Future<Response<Map<String, dynamic>>> getCases(String path) =>
      get<Map<String, dynamic>>(path);
}
```

<a id="readme-section-26"></a>

## GetPage Middleware

O GetPage agora tem uma nova propriedade que recebe uma lista de GetMiddleWare e executa cada item na ordem específica.

**Nota**: Quando GetPage tem Middlewares, todos os filhos desta página terão os mesmos middlewares automaticamente.

<a id="readme-section-27"></a>

### Priority

A ordem dos middlewares a serem executados pode ser definida pela prioridade no GetMiddleware.

```dart
class PriorityMiddleware extends GetMiddleware {
  PriorityMiddleware({super.priority});
}

final middlewares = [
  PriorityMiddleware(priority: 2),
  PriorityMiddleware(priority: 5),
  PriorityMiddleware(priority: 4),
  PriorityMiddleware(priority: -8),
];
```
Esses middlewares serão executados nesta ordem:  **-8 => 2 => 4 => 5**

<a id="readme-section-28"></a>

### Redirect

Em redirectDelegate, retorne route para continuar, outro RouteDecoder para redirecionar ou null para cancelar. Registre login e evite loops.

```dart
class AuthService extends GetxService {
  final authed = false.obs;
}

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({super.priority});

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final auth = Get.find<AuthService>();
    return auth.authed.value ? route : RouteDecoder.fromRoute('/login');
  }
}
```

<a id="readme-section-29"></a>

### onPageCalled

Esta função será chamada quando uma página for chamada, antes de qualquer coisa ser criada e
você pode usá-la para mudar algo sobre a página ou dar-lhe uma nova página

```dart
class PageTitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Welcome');
}
```

<a id="readme-section-30"></a>

### OnBindingsStart

Esta função será chamada logo antes da inicialização dos Bindings.
Aqui você pode alterar as ligações desta página.

```dart
class BindingMiddleware extends GetMiddleware {
  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);
}
```

<a id="readme-section-31"></a>

### OnPageBuildStart

Esta função será chamada logo após a inicialização dos Bindings.
Aqui você pode fazer algo depois de criar as ligações e antes de criar o widget da página.

```dart
class BuildMiddleware extends GetMiddleware {
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;
}
```

<a id="readme-section-32"></a>

### OnPageBuilt

Esta função será chamada logo após a função GetPage.page ser chamada e fornecerá o resultado da função e obtém o widget que será mostrado.

<a id="readme-section-33"></a>

### OnPageDispose

Esta função será chamada logo após descartar todos os objetos relacionados (controladores, visualizações, ...) da página.

<a id="readme-section-34"></a>

## Outras APIs avançadas

```dart
// fornece os arguments da tela atual
Get.arguments

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
Get.removeRoute('/details')

// volta repetidamente até o predicate retorne true.
Get.until((page) => page.name == '/home')

// vá para a próxima rota e remove todas as rotas
//anteriores até que o predicate retorne true.
Get.offUntil(() => const Scaffold(), (page) => page.name == '/home')

// vá para a próxima rota nomeada e remove todas as
//rotas anteriores até que o predicate retorne true.
Get.offNamedUntil('/details', (page) => page.name == '/home')

// Verifica em que plataforma o app está sendo executado
// (Esse método é completamente compatível com o FlutterWeb,
// diferente do método do framework "Platform.isAndroid")
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// Verifica o tipo de dispositivo
GetPlatform.isMobile
GetPlatform.isDesktop
// Todas as plataformas são suportadas de forma independente na web!
// Você pode saber se está executando dentro de um navegador
// no Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb

// Equivalente ao método: MediaQuery.of(context).size.width ou height, mas é imutável. 
// Significa que não irá atualizar mesmo que o tamanho da tela mude (como em navegadores ou app desktop)
Get.height
Get.width

// fornece o context da tela em qualquer lugar do seu código.
Get.context

// fornece o context de snackbar/dialog/bottomsheet em qualquer lugar do seu código.
Get.overlayContext

// Obs: os métodos a seguir são extensions do context. Já que se
// tem acesso ao context em qualquer lugar do código da UI, você pode usar lá

// Se você precisa de um width/height adaptável (como em navegadores em que a janela pode ser redimensionada) 
// você precisa usar 'context'
context.width
context.height

// Dá a você agora o poder de definir metade da tela, um terço da dela e assim por diante.
// Útil para aplicativos responsivos.
// param dividedBy (double) opcional - default: 1
// param reducedBy (double) opcional - default: 0
context.heightTransformer()
context.widthTransformer()

/// similar a MediaQuery.of(context).size
context.mediaQuerySize

/// similar a MediaQuery.of(this).padding
context.mediaQueryPadding

/// similar a MediaQuery.of(this).viewPadding
context.mediaQueryViewPadding

/// similar a MediaQuery.of(this).viewInsets;
context.mediaQueryViewInsets

/// similar a MediaQuery.of(this).orientation;
context.orientation

/// verifica se o dispositivo está no modo paisagem
context.isLandscape

/// verifica se o dispositivo está no modo retrato
context.isPortrait

/// similar a MediaQuery.of(this).devicePixelRatio;
context.devicePixelRatio

/// similar a MediaQuery.of(this).textScaleFactor;
context.textScaleFactor

/// obtém a menor dimensão (largura ou altura) da tela
context.mediaQueryShortestSide

/// retorna True se a largura da tela for maior que 800px
context.showNavbar

/// retorna True se a menor dimensão (largura ou altura) da tela for menor que 600px
context.isPhone

/// retorna True se a menor dimensão (largura ou altura) da tela for maior ou igual a 600px
context.isSmallTablet

/// retorna True se a menor dimensão (largura ou altura) da tela for maior ou igual a 720px
context.isLargeTablet

/// retorna True se o dispositivo é um Tablet
context.isTablet

/// Retorna um valor de acordo com o tamanho da tela
/// Os valores possíveis são:
/// swatch: se a menor dimensão (largura ou altura) da tela for menor que 300px
/// mobile: se a menor dimensão (largura ou altura) da tela for menor que 600px
/// tablet: se a menor dimensão (largura ou altura) da tela for menor que 1200px
/// desktop: se a largura da tela é maior ou iguial a 1200px  
context.responsiveValue<T>()
```

<a id="readme-section-35"></a>

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

Configure GetMaterialApp ou GetCupertinoApp em vez do antigo Get.config. Um router personalizado exige configuração completa do Navigator 2.

```dart
Widget configuredApplication() => GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 250),
  popGesture: true,
  logWriterCallback: localLogWriter,
  routingCallback: (routing) {
    if (routing != null) {
      debugPrint('Route: ${routing.current}');
    }
  },
  home: const Scaffold(body: Text('Configuration')),
);

void localLogWriter(String text, {bool isError = false}) {
  debugPrint('${isError ? "ERROR" : "GETX"}: $text');
}
```

É possível redirecionar todas as mensagens de log do GetX™. Útil quando se tem um package de logging e vc quer que ele lide com todos os logs

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // passage a mensagem para seu package de logging favorito aqui
  // Obs: mesmo que as mensagens de log estejam desativadas
  // com o comando "enableLog: false", as mensagens ainda vão passar por aqui
  // Você precisa checar essa config manualmente aqui se quiser respeitá-la
}
```

<a id="readme-section-36"></a>

### Widgets de Estado Local

Esses Widgets permitem que você gerencie um único valor e mantenha o estado efêmero e localmente. Temos versões para Reativo e Simples. Por exemplo, você pode usá-los para alternar obscureText em um `TextField`, talvez criar um painel expansível personalizado ou talvez modificar o índice atual em um `BottomNavigationBar` enquanto altera o conteúdo do corpo em um `Scaffold`.

<a id="readme-section-37"></a>

#### ValueBuilder
Uma simplificação de `StatefulWidget` que funciona com um callback de `setState` que passa o valor atualizado.


```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // mesma assinatura! Você poderia usar ( newValue ) => updateFn( newValue )
  ),
  // se você precisa chamar algo fora do método builder.
  onUpdate: (value) => print("Valor atualizado: $value"),
  onDispose: () => print("Widget desmontado"),   
),
```

<a id="readme-section-38"></a>

#### ObxValue
Similar a ValueBuilder, mas esta é a versão Reativa, você passa uma instância Rx (lembra do .obs mágico?) e 
atualiza automaticamente... não é incrível?

```dart
ObxValue(
  (data) => Switch(
    value: data.value,
    onChanged: data, // Rx tem uma função _callable_! Você poderia usar (flag) => data.value = flag,
  ),
  false.obs,
),
```

<a id="readme-section-39"></a>

### Explicação em vídeo sobre Outras Features do GetX

Amateur Coder fez um vídeo incrível sobre utils, storage, bindings e outras features! Link: [GetX Other Features](https://youtu.be/ttQtlX_Q0eU)


<a id="readme-section-40"></a>

## Dicas Úteis

`.obs`ervables (também conhecidos como _Rx_ Types) possuem uma grande variedade de métodos e operadores internos.

> É muito comum acreditar que uma propriedade com `.obs` **É** o valor real... mas não se engane!
> Evitamos a declaração de tipo da variável, porque o compilador do Dart é inteligente o suficiente e o código
> parece mais limpo, mas:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" é do tipo ${message.runtimeType}');
```

Mesmo que `message` _imprima_ o valor da string, seu tipo é **RxString**!

Então, você não pode fazer `message.substring( 0, 4 )`.
Você tem que acessar o `valor` real dentro do _observable_:
A "maneira" mais usada é utilizando `.value`, mas, você sabia que também pode usar:

```dart
class Person {
  Person({required this.name});
  String name;
}

void reactiveExamples() {
  final name = 'GetX'.obs;
  name.value = 'Hello';
  final enabled = false.obs;
  enabled.toggle();

  final items = RxList<int>()..add(1);
  final counters = RxMap<String, int>()..['visits'] = 1;
  final labels = RxSet<String>()..add('new');
  items.assignAll(items.where((value) => value > 0));

  final person = Person(name: 'Sara').obs;
  person.update((previous) => Person(name: '${previous!.name}!'));

  name.close();
  enabled.close();
  items.close();
  counters.close();
  labels.close();
  person.close();
}
```

<a id="readme-section-41"></a>

#### GetView

Eu amo este Widget, é tão simples, mas tão útil!

É um Widget `const Stateless` que tem um getter `controller` registrado para Controller, só isso.

```dart
class AwesomeController extends GetxController {
  final String title = 'My Awesome View';
}

// SEMPRE lembre de passar o `Type` que você usou para registrar seu controlador!
class AwesomeView extends GetView<AwesomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(controller.title ), // apenas chame `controller.something`
    );
  }
}
```

<a id="readme-section-42"></a>

#### GetWidget

GetWidget mantém o controller dessa instância de widget em cache e aceita const. Com Get.spawn, o controller criado é fechado ao remover o widget proprietário. GetView faz lookup sem esse cache.

```dart
class ItemController extends GetxController {
  final label = 'Item'.obs;
}

void registerItemFactory() => Get.spawn<ItemController>(() => ItemController());

class ItemView extends GetWidget<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Text(controller.label.value));
}
```

<a id="readme-section-43"></a>

#### GetxService

GetxService fornece onInit/onReady/onClose para serviços da aplicação. A exclusão normal o protege; force ou Get.reset permitem limpeza deliberada. Não persiste após a morte do processo. Aguarde init e use Get.put.

```dart
class DbService extends GetxService {
  Future<DbService> init() async => this;
}

class SettingsService extends GetxService {
  Future<SettingsService> init() async => this;
}

Future<void> initServices() async {
  final database = await DbService().init();
  Get.put<DbService>(database, permanent: true);
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
}

Future<void> startApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(home: const Scaffold(body: Text('Ready'))));
}
```

<a id="readme-section-44"></a>

# Breaking Changes da versão 2 para 3

<a id="readme-section-45"></a>

## Tipagem Rx

| Antes   | Depois     |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

<a id="readme-section-46"></a>

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

<a id="readme-section-47"></a>

## Rotas nomeadas

Antes:

```text
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
    GetPage(name: '/', page: () => Home()),
  ]
)
```

<a id="readme-section-48"></a>

### Porque essa mudança?

Frequentemente, pode ser necessário decidir qual pagina vai ser mostrada ao usuário a partir de um parâmetro, como um token de login. A forma abordada anteriormente não era flexível, já que não permitia isso.

Inserir a página numa função reduziu significativamente o consumo de RAM, já que as rotas não são alocadas na memória no momento que o app é iniciado e também permite fazer esse tipo de abordagem:

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

<a id="readme-section-49"></a>

# Por que GetX™?

1- Muitas vezes após uma atualização do Flutter, muitos dos seus packages irão quebrar. As vezes acontecem erros de compilação, muitas vezes aparecem erros que ainda não existem respostas sobre e o desenvolvedor necessita saber de onde o erro veio, rastreá-lo, para só então tentar abrir uma issue no repositório correspondente e ver seu problema resolvido. Get centraliza os principais recursos para o desenvolvimento (Gerência de estado, de dependências e de rotas), permitindo você adicionar um único package em seu pubspec e começar a trabalhar. Após uma atualização do Flutter, a única coisa que você precisa fazer é atualizar a dependencia do Get e começar a trabalhar. Get também resolve problemas de compatibilidade. Quantas vezes uma versão de um package não é compatível com a versão de outro, porque um utiliza uma dependência em uma versão e o outro em outra versão? Essa também não é uma preocupação usando Get, já que tudo está no mesmo package e é totalmente compatível.

2- Flutter é fácil, Flutter é incrível, mas Flutter ainda tem algum boilerplate que pode ser indesejado para maioria dos desenvolvedores, como o Navigator.of(context).push(context, builder[...]. Get simplifica o desenvolvimento. Em vez de escrever 8 linhas de código para apenas chamar uma rota, você pode simplesmente fazer: Get.to(() => Home()) e pronto, você irá para a próxima página. Urls dinâmicas da web é algo realmente doloroso de fazer com o Flutter atualmente e isso com o GetX™ é estupidamente simples. Gerenciar estados no Flutter e gerenciar dependências também é algo que gera muita discussão, por haver centenas de padrões na pub. Mas não há nada que seja tão fácil quanto adicionar um ".obs" no final de sua variável, colocar o seu widget dentro de um Obx e pronto, todas atualizações daquela variável serão automaticamente atualizadas na tela.

3- Facilidade sem se preocupar com desempenho. O desempenho do Flutter já é incrível, mas imagine que você use um gerenciador de estados e um locator para distribuir suas classes blocs/stores/controllers/ etc. Você deverá chamar manualmente a exclusão daquela dependência quando não precisar dela. Mas já pensou em simplesmente usar seu controlador e quando ele não tivesse mais sendo usado por ninguém, ele simplesmente fosse excluído da memória? É isso que GetX™ faz. Com o SmartManagement, tudo que não está sendo usado é excluído da memória e você não deve se preocupar em nada além de programar. Você terá garantia que está consumindo o mínimo de recursos necessários, sem ao menos ter criado uma lógica para isso.

4- Desacoplamento real. Você já deve ter ouvido o conceito "separar a view da lógica de negócios". Isso não é uma peculiaridade do BLoC, MVC ou MVVM, qualquer outro padrão existente no mercado tem esse conceito. No entanto, muitas vezes esse conceito pode ser mitigado no Flutter por conta do uso do context.
Se você precisa de context para localizar um InheritedWidget, você precisa disso na view ou passar o context por parâmetro. Eu particularmente acho essa solução muito feia e para trabalhar em equipes teremos sempre uma dependência da lógica de negócios da View. GetX™ é pouco ortodoxo com a abordagem padrão e apesar de não proibir totalmente o uso de StatefulWidgets, InitState e etc, ele tem sempre uma abordagem similar que pode ser mais limpa. Os controllers tem ciclos de vida e quando você precisa fazer uma solicitação APIREST por exemplo, você não depende de nada da view. Você pode usar onInit para iniciar a chamada http e quando os dados chegarem, as variáveis serão preenchidas. Como GetX™ é totalmente reativo (de verdade e trabalha sob streams), assim que os itens forem preenchidos, automaticamente será atualizado na view todos os widgets que usam aquela variável. Isso permite que as pessoas especialistas em UI trabalhem apenas com widgets e não precisem enviar nada para a lógica de negócio além de eventos do usuário (como clicar em um botão), enquanto as pessoas que trabalham com a lógica de negócio ficarão livres para criá-la e testá-la separadamente.  

<a id="readme-section-50"></a>

# Comunidade

<a id="readme-section-51"></a>

## Canais da comunidade

GetX™ tem uma comunidade altamente ativa e útil. Se você tiver dúvidas, ou quiser alguma ajuda com relação ao uso deste framework, por favor entre em nossos canais da comunidade, sua dúvida será respondida mais rapidamente, e será o lugar mais adequado. Este repositório é exclusivo para abertura de issues e solicitação de recursos, mas fique à vontade para fazer parte da Comunidade GetX™.

| **Slack (Inglês)**                                                                                                          | **Discord (Inglês e Português)**                                                                                            | **Telegram (Português)**                                                                                              |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="readme-section-52"></a>

## Como contribuir

_Quer contribuir com o projeto? Teremos o orgulho de destacá-lo como um de nossos colaboradores. Aqui estão alguns pontos onde você pode contribuir e tornar o Get (e Flutter) ainda melhor._

- Ajudando a traduzir o readme para outros idiomas.
- Adicionando documentação ao readme (muitas funções do Get ainda não foram documentadas).
- Escreva artigos ou faça vídeos ensinando como usar o Get (eles serão inseridos no Readme e futuramente em nosso Wiki).
- Fazendo PRs para código/testes.
- Incluindo novas funções.

Qualquer contribuição é bem-vinda!


<a id="readme-section-53"></a>

## Artigos e vídeos

- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr). (inglês)
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder. (inglês)
- [Complete GetX™ State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder. (inglês)
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder. (inglês)
- [Firestore User with GetX™ | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder. (inglês)
- [Firebase Auth with GetX™ | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder. (inglês)
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman). (inglês)
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Dependency Injection by [Aachman Garg](https://github.com/imaachman). (inglês)
- [GetX™, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli. (inglês)
- [Build a To-do List App from scratch using Flutter and GetX™](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli. (inglês)
- [GetX™ Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris. (inglês)
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter. (inglês)
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter. (inglês)
