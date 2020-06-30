
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

Se você quiser registar uma instância assíncrona, você pode usar `Get.putAsync()`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('contador', 12345);
  return prefs;
});
```

Como usar:

```dart
int valor = Get.find<SharedPreferences>().getInt('contador');
print(valor); // Imprime: 123456
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

### Como utilizar

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

A classe Bindings é chamada quando uma rota é chamada. Você pode criar uma Binding inicial no seu GetMaterialApp para inserir todas as dependências que serão criadas.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
)
```

Se você quiser usar suas inicializações em um lugar, você pode usar `SmartManagement.keepfactory` para permitir isso.

Sempre prefira usar SmartManagement padrão (full), você não precisa configurar nada pra isso, o Get já te entrega ele assim por padrão. Ele com certeza irá eliminar todos seus controladores em desuso da memória, pois seu controle refinado remove a dependência, ainda que haja uma falha e um widget que utiliza ele não seja disposado adequadamente. Ele também é seguro o bastante para ser usado só com StatelessWidget, pois possui inúmeros callbacks de segurança que impedirão de um controlador permanecer na memória se não estiver sendo usado por nenhum widget. No entanto, se você se incomodar com o comportamento padrão, ou simplesmente não quiser que isso ocorra, Get disponibiliza outras opções mais brandas de gerenciamento inteligente de memória, como o SmartManagement.onlyBuilders, que dependerá da remoção efetiva dos widgets que usam o controlador da árvore para removê-lo, e você poderá impedir que um controlador seja disposado usando "autoRemove:false" no seu GetBuilder/GetX.

Com essa opção, apenas os controladores iniciados no "init:" ou carregados em um Binding com "Get.lazyPut" serão disposados, se você usar Get.put ou qualquer outra abordagem, o SmartManagement não terá permissões para excluir essa dependência.

Com o comportamento padrão, até os widgets instanciados com "Get.put" serão removidos, sendo a diferença crucial entre eles.

`SmartManagement.keepFactory` é como o SmartManagement.full, com uma única diferença. o full expurga até as fabricas das dependências, de forma que o Get.lazyPut() só conseguirá ser chamado uma única vez e sua fábrica e referências serão auto-destruídas. `SmartManagement.keepFactory` irá remover suas dependências quando necessário, no entanto, vai manter guardado a "forma" destas, para fabricar uma igual se você precisar novamente de uma instância daquela.

Em vez de usar `SmartManagement.keepFactory` você pode usar Bindings. Bindings cria fábricas transitórias, que são criadas no momento que você clica para ir para outra tela, e será destruído assim que a animação de mudança de tela acontecer. É tão pouco tempo, que o analyzer sequer conseguirá registrá-lo. Quando você navegar para essa tela novamente, uma nova fábrica temporária será chamada, então isso é preferível à usar `SmartManagement.keepFactory`, mas se você não quer ter o trabalho de criar Bindings, ou deseja manter todas suas dependências no mesmo Binding, isso certamente irá te ajudar. Fábricas ocupam pouca memória, elas não guardam instâncias, mas uma função com a "forma" daquela classe que você quer. Isso é muito pouco, mas como o objetivo dessa lib é obter o máximo de desempenho possível usando o mínimo de recursos, Get remove até as fabricas por padrão. Use o que achar mais conveniente para você.

* Nota: NÃO USE SmartManagement.keepfactory se você está usando vários Bindings. Ele foi criado para ser usado sem Bindings, ou com um único Binding ligado ao GetMaterialApp lá no `initialBinding`

* Nota²: Usar Bindings é completamente opcional, você pode usar Get.put() e Get.find() em classes que usam o controller sem problemas. Porém, se você trabalhar com Services ou qualquer outra abstração, eu recomendo usar Bindings. Especialmente em grandes empresas.
