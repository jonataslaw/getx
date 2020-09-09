# Gerenciamento de dependência
- [Gerenciamento de dependência](#gerenciamento-de-dependência)
  - [Gerenciamento de dependências simples](#gerenciamento-de-dependências-simples)
  - [Métodos de criar instâncias](#métodos-de-criar-instâncias)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Usando as classes/dependências instanciadas](#usando-as-classesdependências-instanciadas)
  - [Diferenças entre os métodos](#diferenças-entre-os-métodos)
  - [Bindings](#bindings)
    - [Classe Bindings](#classe-bindings)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Como alterar](#como-alterar)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
      - [Como os Bindings funcionam](#como-os-bindings-funcionam)
  - [Notas](#notas)

Get tem um gerenciador de dependência simples e poderoso que permite você pegar a mesma classe que seu Bloc ou Controller com apenas uma linha de código, sem Provider context, sem inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Em vez de Controller controller = Controller();
```

Em vez de instanciar sua classe dentro da classe que você está usando, você está instanciando ele dentro da instância do Get, que vai fazer ele ficar disponível por todo o App

Para que então você possa usar seu controller (ou uma classe Bloc) normalmente

- Nota: Se você está usando o gerenciado de estado do Get, você não precisa se preocupar com isso, só leia a documentação, mas dê uma atenção a api [Bindings](#bindings), que vai fazer tudo isso automaticamente para você.
- Nota²: O gerenciamento de dependência do get é desacoplado de outras partes do package, então se por exemplo seu aplicativo já está usando um outro gerenciador de estado (qualquer um, não importa), você não precisa de reescrever tudo, pode simplesmente usar só a injeção de dependência sem problemas

## Métodos de criar instâncias
Todos os métodos e seus parâmetros configuráveis são:

### Get.put()
A forma mais comum de instanciar uma dependência. Bom para os controllers das views por exemplo.

```dart
Get.put<Classe>(Classe());

Get.put<LoginController>(LoginController(), permanent: true);

Get.put<ListItemController>(
  ListItemController,
  tag: "uma string única",
);
```

E essas são todas as opções que você pode definir:
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

### Get.lazyPut
É possível que você vá inserir essa instância, mas sabe que não vai usá-la imediatamente no app.
Nesses casos pode ser usado o lazyPut que só cria a instância no momento que ela for necessária pela primeira vez.
É útil também caso seja uma classe que é muito pesada e você não quer carregar ela junto com tudo quando o app abre.

```dart
/// ApiMock só será instanciado quando Get.find<ApiMock> for usado pela primeira vez
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () => {
  // ... alguma lógica se necessário
    return FirebaseAuth()
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

E essas são todas as opções que você pode definir:
```dart
Get.lazyPut<S>(
  // obrigatório: um método que vai ser executado quando sua classe é chamada pela primeira vez
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

### Get.putAsync
Se você quiser criar uma instância assíncrona, você pode usar `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<SuaClasseAssincrona>( () async => await SuaClasseAssincrona() )
```

E essas são todas as opções que você pode definir:
```dart
Get.putAsync<S>(

  // Obrigatório: um método assíncrono que vai ser executado para instanciar sua classe
  AsyncInstanceBuilderCallback<S> builder,

  // opcional: igual ao Get.put(), é usado quando você precisa de múltiplas instâncias de uma mesma classe
  // precisa ser uma string única
  String tag,

  // opcional: igual ao Get.put(), usado quando você precisa manter a instância ativa no app inteiro.
  // padrão: false
  bool permanent = false
```

### Get.create
Esse é mais específico. Uma explicação detalhada do que esse método é e as diferenças dele para os outros podem ser encontradas em [Diferenças entre os métodos](#diferenças-entre-os-métodos)


```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

E essas são todas as opções que você pode definir:
```dart
Get.create<S>(
  // Obrigatório: Uma função que retorna uma classe que será "fabricada" toda vez que Get.find() for chamado
  InstanceBuilderCallback<S> builder,

  // opcional: igual ao Get.put(), mas é usado quando você precisa de múltiplas instâncias de uma mesma classe. 
  // Útil caso você tenha uma lista em que cada item precise de um controller próprio
  // precisa ser uma string única. Apenas mudou o nome de tag para name.
  String name,

  // opcional: igual ao Get.put(), usado quando você precisa manter a instância ativa no app inteiro. A diferença
  // é que com Get.create o permanent está habilitado por padrão
  bool permanent = true
```

## Usando as classes/dependências instanciadas

Agora, imagine que você navegou por inúmeras rotas e precisa de dados que foram deixados para trás em seu controlador. Você precisaria de um gerenciador de estado combinado com o Provider ou Get_it, correto? Não com Get. Você só precisa pedir ao Get para "procurar" pelo seu controlador, você não precisa de nenhuma dependência adicional para isso:

```dart
final controller = Get.find<Controller>();
// OU
Controller controller = Get.find();
// Sim, parece Magia, o Get irá descobrir qual é seu controller, e irá te entregar.
// Você pode ter 1 milhão de controllers instanciados, o Get sempre te entregará o controller correto.
// Apenas se lembre de Tipar seu controller, final controller = Get.find(); por exemplo, não irá funcionar.
```

E então você será capaz de recuperar os dados do seu controller que foram obtidos anteriormente:

```dart
Text(controller.textFromApi);
```

Já que o valor retornado é uma classe normal, você pode fazer o que quiser com ela:

```dart
int valor = Get.find<SharedPreferences>().getInt('contador');
print(valor); // Imprime: 123456
```

Para remover a instância do Get:

```dart
Get.delete<Controller>();
```

## Diferenças entre os métodos

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

### Classe Bindings

Crie uma classe qualquer que implemente a Bindings.

```dart
class HomeBinding implements Bindings {}
```

Sua IDE vai automaticamente te perguntar para dar override no método `dependencies()`, aí você clica na lâmpada, clica em "override the method", e insira todas as classes que você vai usar nessa rota:

```dart
class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<Service>(()=> Api());
  }
}

class DetalhesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetalhesController>(() => DetalhesController());
  }
}
```

Agora você só precisa informar sua rota que você vai usar esse binding para fazer a conexão entre os gerenciadores de rotas, dependências e estados.

Usando rotas nomeadas

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/detalhes',
    page: () => DetalhesView(),
    binding: DetalhesBinding(),
  ),
];
```

Usando rotas normais:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetalhesView(), binding: DetalhesBinding())
```

Então, você não vai precisar se preocupar com gerenciamento da memória da sua aplicação mais, Get vai fazer para você.

A classe Bindings é chamada quando uma rota é chamada. Você pode criar uma Binding inicial no seu GetMaterialApp para inserir todas as dependências que serão criadas.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
)
```

### BindingsBuilder

A forma padrão de criar um binding é criando uma classe que implementa o Bindings.

Mas alternativamente, você também pode usar a função `BindingsBuilder` par que você possa simplesmente usar uma função pra criar essas instâncias

Exemplo:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/detalhes',
    page: () => DetalhesView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<DetalhesController>(() => DetalhesController());
    }),
  ),
];
```

Dessa forma você pode evitar criar uma classe Binding para cada rota, deixando tudo mais simples.

As duas formas funcionam perfeitamente e você é livre para usar o que mais se encaixa no seu estilo de uso

### SmartManagement

GetX por padrão descarta controllers não utilizados da memória, mesmo que uma falha ocorra e um widget que usa ele não for propriamente descartado.
Essa é o chamado modo `full` do gerenciamento de dependências.
Mas se você quiser mudar a forma que o GetX controla o descarte das classes, você tem a sua disposição a classe `SmartManagement` que pode definir diferentes comportamentos.

#### Como alterar

Se você quiser alterar essa configuração (que normalmente você não precisa mudar) essa é a forma:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //Aqui
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

É o padrão. Descarta as classes que não estão mais sendo utilizadas e que não foram definidas para serem permanents. Na grande maioria dos casos você não vai querer nem precisar alterar essa configuração. Se você for novo com GetX, não altere isto.

#### SmartManagement.onlyBuilders
Com essa opção, somente controllers iniciados pelo `init:` or iniciados dentro de um Binding com `Get.lazyPut()` serão descartados.

Se você usar `Get.put()` ou `Get.putAsync()` or qualquer outra forma, SmartManagement não vai ter permissão para excluir essa dependência.

Com o comportamento padrão, até widgets instanciados com `Get.put()` serão removidos, ao contrário do `SmartManagement.onlyBuilders`.

#### SmartManagement.keepFactory

Assim como o modo `full`, ele vai descartar as dependências quando não estiverem sendo mais utilizadas. Porém, ele irá manter a "factory" de cada dependência. Isso significa que caso você precise de da dependência novamente, ele vai recriar aquele instância novamente.

#### Como os Bindings funcionam
Bindings cria fábricas transitórias, que são criadas no momento que você clica para ir para outra tela, e será destruído assim que a animação de mudança de tela acontecer.
É tão pouco tempo, tão rápido, que o analyzer sequer conseguirá registrá-lo.
Quando você navegar para essa tela novamente, uma nova fábrica temporária será chamada, então isso é preferível à usar `SmartManagement.keepFactory`, mas se você não quer ter o trabalho de criar Bindings, ou deseja manter todas suas dependências no mesmo Binding, isso certamente irá te ajudar.
Fábricas ocupam pouca memória, elas não guardam instâncias, mas uma função com a "forma" daquela classe que você quer.
Isso é muito pouco, mas como o objetivo dessa lib é obter o máximo de desempenho possível usando o mínimo de recursos, Get remove até as fábricas por padrão. Use o que achar mais conveniente para você.

## Notas

* Nota: NÃO USE SmartManagement.keepfactory se você está usando vários Bindings. Ele foi criado para ser usado sem Bindings, ou com um único Binding ligado ao GetMaterialApp lá no `initialBinding`

* Nota²: Usar Bindings é completamente opcional, você pode usar Get.put() e Get.find() em classes que usam o controller sem problemas. Porém, se você trabalhar com Services ou qualquer outra abstração, eu recomendo usar Bindings. Especialmente em grandes empresas.
