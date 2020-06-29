![](get.png)

*Idiomas: [Inglês](README.md), Português Brasileiro (este arquivo), [Spanish](README-es.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Me compre um café" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

- [Sobre Get](#sobre-get)
  - [Instalando e iniciando](#instalando-e-iniciando)
- [Os três pilares](#os-três-pilares)
  - [Gerenciamento de estado](#gerenciamento-de-estado)
    - [Explicação completa](#explicação-completa)
  - [Gerenciamento de rotas](#gerenciamento-de-rotas)
    - [Explicação completa](#explicação-completa-1)
  - [Gerenciamento de Dependência](#gerenciamento-de-dependência)
    - [Explicação completa](#explicação-completa-2)
- [Utilidades](#utilidades)
  - [Outras APIs avançadas e Configurações Manuais](#outras-apis-avançadas-e-configurações-manuais)

# Sobre Get

- Get é uma biblioteca poderosa e extra-leve para Flutter. Ela combina um gerenciador de estado de alta performance, injeção de dependência inteligente e gerenciamento de rotas de uma forma rápida e prática.
- Get não é para todos, seu foco é
  - **Performance**: Já que gasta o mínimo de recursos
  - **Produtividade**: Usando uma sintaxe fácil e agradável
  - **Organização**: Que permite o total desacoplamento da View e da lógica de negócio.
- Get vai economizar horas de desenvolvimento, e vai extrair a performance máxima que sua aplicação pode entregar, enquanto é fácil para iniciantes e preciso para experts.
- Navegue por rotas sem `context`, abra `Dialog`s, `Snackbar`s ou `BottomSheet`s de qualquer lugar no código, gerencie estados e injete dependências de uma forma simples e prática.
- Get é seguro, estável, atualizado e oferece uma enorme gama de APIs que não estão presentes no framework padrão.
- GetX não é um `bloc` da vida. Ele tem uma variedade de recursos que te permite começar a programar sem se preocupar com nada, mas cada um desses recursos estão em um container separado, ou seja, nenhuma depende da outra para funcionar. Elas só são inicializadas após o uso. Se você usa apenas o gerenciador de estado, apenas ele será compilado. Teste você mesmo, vá no repositório de benchmark do getX e perceberá: usando somente o gerenciador de estado do Get, a aplicação ficou mais leve do que outros projetos que também estão usando só o gerenciador de estado, porque nada que não seja usado será compilado no seu código, e cada recuro do GetX foi feito para ser muito leve. O mérito vem também do AOT do próprio Flutter que é incrível, e consegue eliminar recursos não utilizados de uma forma que nenhum outro framework consegue.

**GetX faz seu desenvolvimento mais produtivo, mas quer deixá-lo mais produtivo ainda? Adicione a extensão [GetX extension to VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) no seu VSCode**. Não disponível para outras IDEs por enquanto.

Quer contribuir no projeto? Nós ficaremos orgulhosos de ressaltar você como um dos colaboradores. Aqui vai algumas formas em que você pode contribuir e fazer Get (e Flutter) ainda melhores

- Ajudando a traduzir o README para outras linguagens.
- Adicionando mais documentação ao README (até o momento, nem metade das funcionalidades do Get foram documentadas).
- Fazendo artigos/vídeos ensinando a usar o Get (eles serão inseridos no README, e no futuro na nossa Wiki).
- Fazendo PR's (Pull-Requests) para código/testes.
- Incluindo novas funcionalidades.

Qualquer contribuição é bem-vinda!

## Instalando e iniciando

<!-- - Flutter Master/Dev/Beta: version 2.0.x-dev 
- Flutter Stable branch: version 2.0.x
(procure pela versão mais recente em pub.dev) -->

Adicione Get ao seu arquivo pubspec.yaml

```yaml
dependencies:
  get:
```

Troque seu `MaterialApp()` por `GetMaterialApp()` e aproveite!

```dart
import 'package:get/get.dart';

GetMaterialApp( // Antes: MaterialApp(
  home: HomePage(),
)
```

# Os três pilares

## Gerenciamento de estado

Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/route_management.md)

O app 'Counter' criado por padrão no com o comando `flutter create` tem mais de 100 linhas(incluindo os comentários). Para demonstrar o poder do Get, irei demonstrar como fazer o mesmo 'Counter' mudando o estado em cada toque trocando entre páginas e compartilhando o estado entre telas. Tudo de forma organizada, separando a lógica de negócio da View, COM SOMENTE 26 LINHAS INCLUINDO COMENTÁRIOS

- Passo 1:
Troque `MaterialApp` para `GetMaterialApp`

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- **Obs:** Isso não modifica o `MaterialApp` do Flutter, GetMaterialApp não é uma versão modificada do MaterialApp, é só um Widget pré-configurado, que tem como child o MaterialApp padrão. Você pode configurar isso manualmente, mas definitivamente não é necessário. GetMaterialApp vai criar rotas, injetá-las, injetar traduções, injetar tudo que você precisa para navegação por rotas (gerenciamento de rotas). Se você quer somente usar o gerenciado de estado ou somente o gerenciador de dependências, não é necessário usar o GetMaterialApp. Ele somente é necessário para:
  - Rotas
  - Snackbars/bottomsheets/dialogs
  - apis relacionadas a rotas e a ausência de `context`

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

### Explicação completa

**Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/route_management.md)**

## Gerenciamento de rotas

Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/state_management.md)

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

### Explicação completa

**GetX funciona com rotas nomeadas também! Veja uma explicação mais completa do gerenciamento de rotas [aqui](./docs/pt_BR/route_management.md)**

## Gerenciamento de Dependência

**Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/dependency_management.md)**

- Nota: Se você está usando o gerenciado de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api `Bindings`, que vai fazer tudo isso automaticamente para você.

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

### Explicação completa

**Veja uma explicação mais completa do gerenciamento de estado [aqui](./docs/pt_BR/dependency_management.md)**

# Utilidades

## Outras APIs avançadas e Configurações Manuais

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

// Equivalente ao método: MediaQuery.of(context).size.height, mas é imutável.
// Se você precisa de um height adaptável (como em navegadores em que a janela pode ser redimensionada)
// você precisa usar 'context.height'
Get.height

// Equivalente ao método: MediaQuery.of(context).size.width, mas é imutável.
// Se você precisa de um width adaptável (como em navegadores em que a janela pode ser redimensionada)
// você precisa usar 'context.width'
Get.width

// forncece o context da tela em qualquer lugar do seu código.
Get.context

// fornece o context de snackbar/dialog/bottomsheet em qualquer lugar do seu código.
Get.contextOverlay

```

Essa biblioteca sempre será atualizada e terá sempre nova features sendo implementadas. Sinta-se livre para oferecer PRs e contribuir com o package.
