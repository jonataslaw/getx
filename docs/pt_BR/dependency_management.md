- [Gerenciamento de dependência](#gerenciamento-de-dependência)
  - [Gerenciamento de dependências simples](#gerenciamento-de-dependências-simples)
  - [Opções](#opções)
  - [Bindings](#bindings)
    - [Como utilizar](#como-utilizar)

# Gerenciamento de dependência

## Gerenciamento de dependências simples

Já está usando o Get e quer fazer seu projeto o melhor possível? Get tem um gerenciador de dependência simples e poderoso que permite você pegar a mesma classe que seu Bloc ou Controller com apenas uma linha de código, sem Provider context, sem inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Em vez de Controller controller = Controller();
```

* Nota: Se você está usando o gerenciado de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api `Bindings`, que vai fazer tudo isso automaticamente para você.

Em vez de instanciar sua classe dentro da classe que você está usando, você está instanciando ele dentro da instância do Get, que vai fazer ele ficar disponível por todo o App

Para que então você possa usar seu controller (ou uma classe Bloc) normalmente

**Tip:** O gerenciamento de dependência do get é desacoplado de outras partes do package, então se por exemplo seu aplicativo já está usando um outro gerenciador de estado (qualquer um, não importa), você não precisa de reescrever tudo, pode simplesmente usar só a injeção de dependência sem problemas

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

## Métodos de instanciamento.

Apesar do Get já entregar configurações muito boas para uso, é possível refiná-las ainda mais para que sejam de utilidade ainda maior para você programador. Os métodos e seus parâmetros configuráveis são:

- Get.put():

```dart
Get.put<S>(
  // obrigatório: a classe que você quer salvar, como um controller ou qualquer outra coisa
  // obs: Esse "S" significa que pode ser qualquer coisa
  S dependency

  // opcional: isso é pra quando você quer múltiplas classess que são do mesmo tipo
  // já que você normalmente pega usando "Get.find<Controller>()",
  // você precisa usar uma tag para dizer qual das instâncias vc precisa
  // precisa ser uma string única
  String tag,

  // opcional: por padrão, get vai descartar as instâncias quando elas não são mais usadas (exemplo,
  // o controller de uma view que foi fechada) // Mas talvez você precisa quea instância seja mantida por todo o app, como a instância do SharedPreferences por exemplo
  // então vc usa isso
  // padrão: false
  bool permanent = false,

  // opcional: permite criar a dependência usando uma função em vez da dependênia em si
  InstanceBuilderCallback<S> builder,
)
```

- Get.lazyPut:

```dart
Get.lazyPut<S>(
  // obrigatório: um método que vai ser executado quando sua classe é chamada pela primeira vez
  // Exemplo: "Get.lazyPut<Controller>( () => Controller()
  InstanceBuilderCallback builder,
  
  // opcional: igual ao Get.put(), é usado quando você precisa de múltiplas instâncias de uma mesma classe
  // precisa ser uma string única
  String tag,

  // opcional: é similar a "permanent", mas a instância é descartada quando
  // não é mais usada e é refeita quando precisa ser usada novamente
  // Assim como a opção SmartManagement.keepFactory na api Bindings
  // padrão: false
  bool fenix = false
  
)
```

- Get.putAsync:

```dart
Get.putAsync<S>(
  // Obrigatório: um método assíncrono que vai ser executado para instanciar sua classe
  // Exemplo: Get.putAsyn<YourAsyncClass>( () async => await YourAsyncClass() )
  AsyncInstanceBuilderCallback<S> builder,

  // opcional: igual ao Get.put(), é usado quando você precisa de múltiplas instâncias de uma mesma classe
  // precisa ser uma string única
  String tag,

  // opcional: igual ao Get.put(), usado quando você precisa manter a instância ativa no app inteiro.
  // padrão: false
  bool permanent = false
```

- Get.create:

```dart
Get.create<S>(
  // Obrigatório: Uma função que retorna uma classe que será "fabricada" toda vez que Get.find() for chamado
  // Exemplo: Get.create<YourClass>(() => YourClass())
  InstanceBuilderCallback<S> builder,

  // opcional: igual ao Get.put(), mas é usado quando você precisa de múltiplas instâncias de uma mesma classe. 
  // Útil caso você tenha uma lista em que cada item precise de um controller próprio
  // precisa ser uma string única. Apenas mudou o nome de tag para name.
  String name,

  // opcional: igual ao Get.put(), usado quando você precisa manter a instância ativa no app inteiro. A diferença
  // é que com Get.create o permanent está habilitado por padrão
  bool permanent = true
```

### Diferenças entre os métodos:

Primeiro, vamos falar do `fenix` do Get.lazyPut e o `permanent` dos outros métodos.

A diferença fundamental entre `permanent` e `fenix` está em como você quer armazenar as suas instâncias.
Reforçando: por padrão, o Get apaga as instâncias quando elas não estão em uso.
Isso significa que: Se a tela 1 tem o controller 1 e a tela 2 tem o controller 2 e você remove a primeira rota da stack (usando `Get.off()` ou `Get.offNamed`), o controller 1 perdeu seu uso portanto será apagado.
Mas se você optar por usar `permanent: true`, então ela não se perde nessa transição - o que é muito útil para serviços que você quer manter rodando na aplicação inteira.
Já o `fenix`, é para serviços que você não se preocupa em perder por uma tela ou outra, mas quando você precisar chamar o serviço, você espera que ele "retorne das cinzas" (`fenix: true`), criando uma nova instância.

Prosseguindo com as diferenças entre os métodos:

- Get.put e Get.putAsync seguem a mesma ordem de criação, com a diferença que o Async opta por aplicar um método assíncrono: Esses dois métodos criam e já inicializam a instância. Esta é inserida diretamente na memória, através do método interno `insert` com os parâmetros `permanent: false` e `isSingleton: true` (esse parâmetro `isSingleton` serve apenas para dizer se é para utilizar a dependência colocada em `dependency`, ou se é para usar a dependência colocada no `InstanceBuilderCallback`). Depois disso, é chamado o `Get.find` que imediatamente inicializa as instâncias que estão na memória. 

- Get.create: Como o nome indica, você vai "criar" a sua dependência! Similar ao `Get.put`, ela também chama o método interno `insert` para instanciamento. Contudo, `permanent` e `isSingleton` passam a ser `true` e `false` (Como estamos "criando" a nossa dependência, não tem como ela ser um Singleton de algo, logo, `false`). E por ser `permanent: true`, temos por padrão o benefício de não se perder entre telas! Além disso, não é chamado o `Get.find`, logo ela fica esperando ser chamada para ser usada. Ele é criado dessa forma para aproveitar o uso do parâmetro `permanent`, já que, vale ressaltar, o Get.create foi criado com o objetivo de criar instâncias não compartilhadas, mas que não se perdem, como por exemplo um botão em um listView, que você quer uma instância única para aquela lista - por conta disso, o Get.create deve ser usado em conjunto com o GetWidget. 

- Get.lazyPut: Como o nome dá a entender, é um processo preguiçoso (lazy). A instância é criada, mas ela não é chamada para uso logo em seguida, ela fica aguardando ser chamada. Diferente dos outros métodos, o `insert` não é chamado. Ao invés disso, a instância é inserida em outra parte na memória, uma parte responsável por dizer se a instância pode ser recriada ou não, vamos chamá-la de "fábrica". Se queremos criar algo para ser chamado só depois, não vamos misturá-lo com as coisas que estão sendo usadas agora. E é aqui que entra a mágica do `fenix`. Se você optou por deixar `fenix: false`, e seu `smartManagement` não for `keepFactory`, então ao usar o `Get.find` a instância passa da "fábrica" para a área comum das instância. Em seguinda, por padrão é removida da "fábrica". Agora, se você optou por  `fenix: true`, a instância continua a existir nessa parte dedicada, mesmo indo para a área comum, para ser chamada futuramente caso precise. 

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
