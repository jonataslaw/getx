---
sidebar_position: 1
---

# Estado

GetX no usa Streams o ChangeNotifier como otros administradores de estado. ¿Por qué? Además de crear aplicaciones para android, iOS, web, ventanas, macos y linux, con GetX puede construir aplicaciones de servidor con la misma sintaxis que Flutter/GetX. Para mejorar el tiempo de respuesta y reducir el consumo de RAM, creamos GetValue y GetStream, que son soluciones de baja latencia que ofrecen un gran rendimiento, a un bajo costo operativo. Utilizamos esta base para construir todos nuestros recursos, incluida la gestión estatal.

- _Complexity_: Algunos administradores estatales son complejos y tienen un montón de boilerplate. Con GetX no tienes que definir una clase para cada evento, el código es muy limpio y claro, y usted hace mucho más escribiendo menos. Muchas personas han renunciado a Flutter por este tema y ahora finalmente tienen una solución absurdamente sencilla para la gestión de los Estados.
- _Sin generadores de código_: Pasa la mitad de su tiempo de desarrollo escribiendo la lógica de su aplicación. Algunos administradores de estado confían en que los generadores de código tengan código mínimamente legible. Cambiar una variable y tener que ejecutar build\_runner puede ser improductivo, y a menudo el tiempo de espera después de un polvo limpio será largo, y usted tendrá que beber un montón de café.

Con GetX todo es reactivo, y nada depende de generadores de código, aumentando su productividad en todos los aspectos de su desarrollo.

- _No depende del contexto_: Probablemente ya necesites enviar el contexto de tu vista a un controlador, hacer que la vista se acople a su lógica de negocio alto. Probablemente haya tenido que usar una dependencia para un lugar que no tiene contexto, y tuvo que pasar el contexto a través de varias clases y funciones. Esto no existe con GetX. Usted tiene acceso a sus controladores desde dentro de sus controladores sin ningún contexto. No necesita enviar el contexto por parámetro para literalmente nada.
- _Control granular_: la mayoría de los administradores de estados se basan en ChangeNotifier. CambiarNotificador notificará todos los widgets que dependen de ellos cuando se llama a notificarListeners. Si tienes 40 widgets en una pantalla, que tienen una variable de tu clase ChangeNotificfier al actualizar uno, todos ellos serán reconstruidos.

Con GetX, incluso los widgets anidados son respetados. Si tienes Obx viendo tu vista de lista, y otra viendo una casilla dentro de la vista de lista, al cambiar el valor de la casilla de verificación, sólo se actualizará cuando se cambie el valor de la lista, sólo se actualizará la vista de lista.

- _Sólo reconstruye si su variable cambia REGISTRAMENTE_: GetX tiene control de flujo, lo que significa que si muestra un texto con 'Paola', si cambia la variable observable a 'Paola' de nuevo, el widget no será reconstruido. Esto se debe a que GetX sabe que 'Paola' ya se muestra en Texto, y no hará reconstrucciones innecesarias.

La mayoría (si no todos) los administradores de estado actuales se reconstruirán en la pantalla.

## Gestor de estado reactivo

La programación reactiva puede alienar a mucha gente porque se dice que es complicada. GetX convierte la programación reactiva en algo bastante simple:

- No necesitará crear StreamControllers.
- No necesitará crear un StreamBuilder para cada variable
- No necesitará crear una clase para cada estado.
- No necesitará crear un get para un valor inicial.

Programación reactiva con Get es tan fácil como usar setState.

Imaginemos que tienes una variable de nombre y queremos que cada vez que la cambies, todos los widgets que la usan se cambien automáticamente.

Esta es tu variable de contador:

```dart
var name = 'Jonatas Borges';
```

Para hacerla observable, sólo tienes que añadir ".obs" al final de la misma:

```dart
var name = 'Jonatas Borges'.obs;
```

Eso es todo. Es _es_ simple.

A partir de ahora, podríamos referirnos a esta variable reactiva-".obs"(ervables) como _Rx_.

¿Qué hicimos bajo el capó? Hemos creado un `Stream` de `String` s, asignado el valor inicial `"Jonatas Borges"` , notificamos a todos los widgets que usan `"Jonatas Borges"` que ahora "pertenecen" a esta variable, y cuando el valor _Rx_ cambie, también tendrán que cambiar.

Esta es la **magia de GetX**, gracias a las capacidades de Dart.

Pero, como sabemos, un `Widget` sólo puede ser cambiado si está dentro de una función, porque las clases estáticas no tienen el poder de "cambio automático".

Necesitarás crear un `StreamBuilder` , suscribirte a esta variable para escuchar los cambios, y crea una "cascada" de `StreamBuilder` anidado si quieres cambiar varias variables en el mismo ámbito, ¿verdad?

No, no necesitas un `StreamBuilder` , pero tienes razón sobre las clases estáticas.

Bueno, en la vista, normalmente tenemos un montón de boilerplate cuando queremos cambiar un Widget específico, esa es la manera de Flutter.
Con **GetX** también puedes olvidarte de este código de boilerplate .

`StreamBuilder( … )` ? `initialValue: …` ? `builder: …` ? No, sólo necesitas colocar esta variable dentro de un Widget `Obx()`.

```dart
Obx (() => Text (controller.name));
```

_¿Qué necesitas memorizar?_ Sólo `Obx(() =>` .

Usted está pasando ese Widget a través de una función de flecha en un `Obx()` (el "Observador" del _Rx_).

`Obx` es bastante inteligente, y solo cambiará si el valor de `controller.name` cambia.

Si `name` es `"John"` , y lo cambias a `"John"` ( `name. alue = "John"` ), como es el mismo `valor` que antes, nada cambiará en la pantalla, y `Obx` , para ahorrar recursos, simplemente ignorará el nuevo valor y no reconstruirá el Widget. **¿No es asombroso?**

> Entonces, ¿qué pasa si tengo 5 variables _Rx_ (observables) dentro de un `Obx`?

Sólo se actualizará cuando **cualquiera** de ellos cambie.

> Y si tengo 30 variables en una clase, cuando actualicé una, ¿actualizará **todas** las variables que están en esa clase?

No, sólo el **Widget específico** que usa esa variable _Rx_.

Por lo tanto, **GetX** sólo actualiza la pantalla, cuando la variable _Rx_ cambia su valor.

```

final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```

### Ventajas

**GetX()** te ayuda cuando necesitas un control **granular** sobre lo que se está actualizando.

Si no necesitas `identificadores únicos` , porque todas tus variables serán modificadas cuando realices una acción, entonces usa `GetBuilder` ,
porque es un Actualizador de Estado Simple (en bloques, como `setState()` ), hecho en unas pocas líneas de código.
Se hizo simple, para tener el menor impacto de la CPU, y sólo para cumplir un único propósito (una reconstrucción de _Estado_) y gastar los recursos mínimos posibles.

Si necesitas un administrador de estado **poderoso**, no puedes ir mal con **GetX**.

No funciona con variables, pero **flows**, todo en él es `Streams` bajo el capó.

Puedes usar _rxDart_ junto con él, porque todo es `Streams`,
puedes escuchar el `evento` de cada variable "_Rx_",
porque todo en él son `Streams`.

Es literalmente un enfoque _BLoC_ más fácil que _MobX_, y sin generadores de código ni decoraciones.
Puedes convertir **cualquier cosa** en un _"Observable"_ con sólo un `.obs` .

### Máximo rendimiento:

Además de tener un algoritmo inteligente para recompilaciones mínimas, **GetX** utiliza comparadores
para asegurarse de que el Estado ha cambiado.

If you experience any errors in your app, and send a duplicate change of State,
**GetX** will ensure it will not crash.

Con **GetX** el estado sólo cambia si el `valor` cambia.
Esa es la diferencia principal entre **GetX**, y usando \_ `computed` de MobX\_.
Al unirse a dos **observables**, y uno cambia; el oyente de ese _observable_ también cambiará.

Con **GetX**, si te unes a dos variables, `GetX()` (similar a `Observer()` ) sólo se reconstruirá si implica un cambio real de Estado.

### Declarando una variable reactiva

Tienes 3 maneras de convertir una variable en un "observable".

1 - El primero está usando **`Rx{Type}`**.

```dart
// initial value is recommended, but not mandatory
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - El segundo es usar **`Rx`** y usar Darts Genéricos, `Rx<Type>`

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Custom classes - it can be any class, literally
final user = Rx<User>();
```

3 - El tercero, más práctico, más fácil y preferido enfoque, sólo añade **`.obs`** como una propiedad de tu `valor`:

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - it can be any class, literally
final user = User().obs;
```

##### Tener un estado reactivo es fácil.

Como sabemos, _Dart_ ahora se dirige hacia _null\_nul_.
Para estar preparado, a partir de ahora, siempre deberías iniciar tus variables _Rx_ con un **valor inicial**.

> Transformar una variable en un _observable_ + _valor inicial_ con **GetX** es el enfoque más simple y práctico.

Literalmente añadirás un " `.obs` " al final de tu variable, y **eso**, lo has hecho observable,
y su `. alue` , bueno, será el _valor inicial_).

### Usar los valores en la vista

```dart
// controller file
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// view file
GetX<Controller>(
  builder: (controller) {
    print("count 1 rebuild");
    return Text('${controller.count1.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 2 rebuild");
    return Text('${controller.count2.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 3 rebuild");
    return Text('${controller.sum}');
  },
),
```

Si incrementamos `count1.value++` , se imprimirá:

- `cuenta 1 reconstrucción`

- `cuenta 3 de reconstrucción`

porque `count1` tiene un valor de `1` y `1 + 0 = 1` , cambiando el valor de `suma` getter.

Si cambiamos `count2.value++` , se imprimirá:

- `count 2 recompilación`

- `cuenta 3 de reconstrucción`

porque `count2.value` cambió, y el resultado de la `sum` es ahora `2` .

- NOTA: De forma predeterminada, el primer evento reconstruirá el widget, incluso si es el mismo `value`.

Este comportamiento existe debido a variables booleanas.

Imagina que hiciste esto:

```dart
var isLogged = false.obs;
```

Y luego, comprobaste si un usuario está "conectado" para activar un evento en `ever` .

```dart
@override
onInit() async {
  ever(isLogged, fireRoute);
  isLogged.value = await Preferences.hasToken();
}

fireRoute(logged) {
  if (logged) {
   Get.off(Home());
  } else {
   Get.off(Login());
  }
}
```

si `hasToken` fuera `false` , no habría ningún cambio en `isLogged` , así que `ever()` nunca sería llamado.
Para evitar este tipo de comportamiento, el primer cambio a un _observable_ siempre activará un evento,
incluso si contiene el mismo `. alue` .

Puede eliminar este comportamiento si lo desea, usando:
`isLogged.firstRebuild = false;`

### Condiciones para reconstruir

Además, Get proporciona un control refinado del estado. Puede condicionar un evento (como agregar un objeto a una lista), en una determinada condición.

```dart
// First parameter: condition, must return true or false.
// Second parameter: the new value to apply if the condition is true.
list.addIf(item < limit, item);
```

Sin decoraciones, sin un generador de código, sin complicaciones :smile:

¿Conoces la aplicación contador de Flutter? Tu clase Controller podría verse así:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Con un simple:

```dart
controller.count.value++
```

Puede actualizar la variable contador en su interfaz de usuario, independientemente de dónde se almacena.

### Donde .obs pueden ser usados

Puedes transformar cualquier cosa en obs. Aquí hay dos maneras de hacerlo:

- Puedes convertir los valores de tu clase a obs

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

- o puede convertir toda la clase para ser observable

```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

### Nota sobre listas

Las listas son completamente observables al igual que los objetos dentro de ellas. De esta manera, si añade un valor a una lista, automáticamente reconstruirá los widgets que la utilizan.

También no necesitas usar ".value" con listas, la increíble api dart nos permitió eliminar eso.
Lamentablemente no se pueden extender tipos primitivos como String y int, haciendo uso de . alue obligory, pero eso no será un problema si trabajas con consigue y setters para estos.

```dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // String need to have .value in front of it
ListView.builder (
  itemCount: controller.list.length // lists don't need it
)
```

Cuando estás haciendo que tus propias clases sean observables, hay una forma diferente de actualizarlas:

```dart
// on the model file
// we are going to make the entire class observable instead of each attribute
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}

// on the controller file
final user = User().obs;
// when you need to update the user variable:
user.update( (user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});
// an alternative way of update the user variable:
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// you can also access the model values without the .value:
user().name; // notice that is the user variable, not the class (variable has lowercase u)
```

No tienes que trabajar con conjuntos si no lo deseas. Puedes usar el "assign 'and" asignado "api".
La api "asignar" borrará su lista y añadirá un solo objeto que desea comenzar allí.
La api "assignAll" borrará la lista existente y añadirá cualquier objeto iterable que se inyecte en ella.

### ¿Por qué tengo que usar .value

Podríamos eliminar la obligación de usar 'valor' en 'cadena' e 'int' con un generador de código y decoración simple, pero el propósito de esta biblioteca es precisamente evitar dependencias externas. Queremos ofrecer un entorno listo para la programación, que implique lo esencial (gestión de rutas, dependencias y estados), de una manera sencilla, ligera y eficiente, sin necesidad de un paquete externo.

Literalmente puedes añadir 3 letras a tu pubspec (get) y dos puntos y empezar a programar. Todas las soluciones incluidas por defecto, desde la gestión de rutas hasta la gestión estatal, apuntan a la facilidad, productividad y rendimiento.

El peso total de esta biblioteca es menor que el de un único administrador estatal, aunque sea una solución completa, y eso es lo que ustedes deben entender.

Si usted está molesto por `. alue` , y como un generador de código, MobX es una gran alternativa, y puede usarlo junto con Get. Para aquellos que quieran añadir una sola dependencia en pubspec y empezar a programar sin preocuparse por que la versión de un paquete sea incompatible con otra, o si el error de una actualización de estado proviene del administrador de estado o dependencia, o aún así, no quieren preocuparse por la disponibilidad de controladores, si literalmente "sólo programación", obtener es perfecto.

Si no tiene ningún problema con el generador de código MobX, o no tiene ningún problema con el boilerplate BLoC, usted puede simplemente usar Get para rutas, y olvidar que tiene el administrador del estado. Obtener SEM y RSM nacieron de la necesidad, mi empresa tenía un proyecto con más de 90 controladores, y el generador de código simplemente tardó más de 30 minutos en completar sus tareas después de una limpieza de flujido en una máquina razonablemente buena, si su proyecto tiene 5, 10, 15 controladores, cualquier administrador estatal le suministrará bien. Si tiene un proyecto absurdamente grande, y el generador de código es un problema para usted, se le ha concedido esta solución.

Obviamente, si alguien quiere contribuir al proyecto y crear un generador de código, o algo similar, enlazaré en este léame como una alternativa, Mi necesidad no es la necesidad de todos los desarrolladores, pero por ahora digo, hay buenas soluciones que ya hacen eso, como MobX.

### Obx()

Escribir en Get using Bindings es innecesario. puede utilizar el widget Obx en lugar de GetX que sólo recibe la función anónima que crea un widget.
Obviamente, si no usas un tipo, necesitarás tener una instancia de tu controlador para usar las variables, o usar `Get. enlazar<Controller>()` .value o Controller.to.value para recuperar el valor.

### Trabajadores

Los trabajadores le ayudarán, activando llamadas específicas cuando ocurra un evento.

```dart
/// Called every time `count1` changes.
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

Todos los trabajadores (excepto `debounce` ) tienen un parámetro llamado `condition`, que puede ser un `bool` o un callback que devuelva un `bool` .
Esta `condición` define cuando la función `callback` se ejecuta.

Todos los trabajadores devuelven una instancia de `Worker`, que puedes usar para cancelar ( a través de `dispose()` ) el worker.

- **`nunca`**

se llama cada vez que la variable _Rx_ emite un nuevo valor.

- **`todo`**

Al igual que `ever` , pero toma una `List` de valores _Rx_ llamada cada vez que su variable es cambiada. Eso es todo.

- **`una vez`**

'una vez' se llama sólo la primera vez que la variable ha sido cambiada.

- **`debounce`**

'debounce' es muy útil en las funciones de búsqueda, donde sólo quieres que se llame a la API cuando el usuario termine de teclear. Si el usuario escribe "Jonny", tendrá 5 búsquedas en las APIs, por la letra J, n, n y y. Con Get esto no sucede, porque usted tendrá un Trabajador de "deshacer" que sólo se activará al final de la escritura.

- **`intervalo`**

'intervalo' es diferente del escombro. debouce si el usuario hace 1000 cambios a una variable dentro de 1 segundo, enviará sólo el último después del temporizador sofocado (el valor por defecto es 800 milisegundos). Intervalo en su lugar ignorará todas las acciones del usuario durante el período asfixiado. Si envías eventos por 1 minuto, 1000 por segundo, descomprimir sólo te enviará el último, cuando el usuario deje de abrir eventos. el intervalo entregará eventos cada segundo, y si se establece en 3 segundos, producirá 20 eventos ese minuto. Esto se recomienda para evitar abusos, en funciones donde el usuario puede hacer clic rápidamente en algo y obtener alguna ventaja (imagina que el usuario puede ganar monedas haciendo clic en algo, si hizo clic 300 veces en el mismo minuto, tendría 300 monedas, usando intervalo, puedes establecer un marco de tiempo durante 3 segundos, e incluso luego hacer clic en 300 o mil veces, el máximo que obtendría en 1 minuto serían 20 monedas, haciendo clic en 300 o 1 millón de veces). La desconexión es adecuada para anti-DDos, para funciones como buscar donde cada cambio a onChange causaría una consulta a tu api. Debounce esperará a que el usuario deje de escribir el nombre, para hacer la solicitud. Si se utilizara en el escenario de monedas mencionado anteriormente, el usuario sólo ganaría 1 moneda, porque sólo se ejecuta cuando el usuario "pausa" para el tiempo establecido.

- NOTA: Los trabajadores deben ser usados siempre al iniciar un controlador o clase, por lo que siempre debe estar en onInit (recomendado), constructor de clase, o el estado inicial de un StatefulWidget (esta práctica no se recomienda en la mayoría de los casos, pero no debería tener efectos secundarios).

## Gestor de Estado simple

Obtener tiene un administrador de estado que es extremadamente ligero y fácil, que no utiliza ChangeNotifier, satisfará especialmente las necesidades de los nuevos a Flutter, y no causará problemas para grandes aplicaciones.

GetBuilder está dirigido precisamente al control de múltiples estados. Imagínese que ha añadido 30 productos a un carrito, haga clic en eliminar uno, al mismo tiempo que la lista se actualiza, el precio se actualiza y la insignia en el carrito de la compra se actualiza a un número más pequeño. Este tipo de enfoque hace que GetBuilder mate, porque agrupa a todos y los cambia a la vez sin ninguna "lógica computacional" para eso. GetBuilder fue creado con este tipo de situación en mente, desde el cambio efemeral de estado, puede usar setState y no necesitará un gestor de estado para esto.

De esta manera, si quieres un controlador individual, puedes asignar IDs para eso, o usar GetX. Esto depende de ti, recordando que cuanto más widgets "individual" tengas, más destacará el rendimiento de GetX mientras que el rendimiento de GetBuilder debe ser superior, cuando hay un cambio de estado múltiple.

### Ventajas

1. Actualizar sólo los widgets necesarios.

2. No utiliza changeNotifier, es el gestor de estado el que usa menos memoria (cerca de 0mb).

3. ¡Olvidar StatefulWidget! Con Get nunca lo necesitará. Con los otros administradores de estado, probablemente tendrás que usar StatefulWidget para obtener la instancia de tu Provider, BLoC, Controlador MobX, etc. Pero, ¿alguna vez has parado a pensar que tu appBar, tu andamio y la mayoría de los widgets que están en tu clase son sin estado? Entonces, ¿por qué salvar el estado de toda una clase, si sólo puedes salvar el estado del Widget que es estatuario? Consigue que esto también se resuelva. Crea una clase sin Estado, haz que todo esté sin estado. Si necesita actualizar un solo componente, envolverlo con GetBuilder, y su estado se mantendrá.

4. Organiza tu proyecto de forma real! Los controladores no deben estar en tu interfaz de usuario, colocar tu TextEditController, o cualquier controlador que utilices dentro de tu clase Controller.

5. ¿Necesitas activar un evento para actualizar un widget tan pronto como se procese? GetBuilder tiene la propiedad "initState", al igual que StatefulWidget, y puedes llamar a eventos desde tu controlador, directamente desde él, ya no más eventos colocados en tu estado inicial.

6. ¿Necesitas desencadenar una acción como cerrar secuencias, temporizadores y etc? GetBuilder también tiene la propiedad de disponer, donde puede llamar a eventos tan pronto como ese widget sea destruido.

7. Usar streams sólo si es necesario. Puede utilizar sus Controladores StreamControllers dentro de su controlador normalmente, y usar StreamBuilder también normalmente, pero recuerde, un flujo consume razonablemente memoria, la programación reactiva es hermosa, pero no debería abusar de ella. 30 streams abiertos simultáneamente pueden ser peores que changeNotifier (y changeNotifier es muy mal).

8. Actualizar widgets sin gastar rama para eso. Obtén tiendas sólo el ID del creador GetBuilder, y actualiza ese GetBuilder cuando sea necesario. El consumo de memoria del almacenamiento con ID en memoria es muy bajo, incluso para miles de GetBuilders. Cuando creas un nuevo GetBuilder, realmente estás compartiendo el estado de GetBuilder que tiene un ID de creador. Un nuevo estado no se crea para cada GetBuilder, que guarda un LOT OF ram para aplicaciones grandes. Básicamente su solicitud será completamente sin estado y los pocos Widgets que serán Stateful (dentro de GetBuilder) tendrán un solo estado, y por lo tanto actualizar uno los actualizará todos. El Estado es sólo uno.

9. Get es omnisciente y en la mayoría de los casos sabe exactamente el tiempo para sacar a un controlador de la memoria. No deberías preocuparte por cuándo desmontar un controlador, Obtener sabe el mejor momento para hacer esto.

### Uso

```dart
// Create controller class and extends GetxController
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // use update() to update counter variable on UI when increment be called
  }
}
// On your Stateless/Stateful class, use GetBuilder to update Text when increment be called
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```

**Hecho!**

- Ya has aprendido a manejar estados con Get.

- Nota: Es posible que desee una organización más grande, y no utilizar la propiedad init. Para eso, puedes crear una clase y extender la clase Binding y dentro de ella mencionar los controladores que se crearán dentro de esa ruta. No se crearán controladores en ese momento, al contrario, se trata simplemente de una declaración. para que la primera vez que utilices un Controller, Obtener sabrá dónde mirar. Get will remain perazyLoad, and will continue to dispose Controllers when they are not needed. Vea el ejemplo pub.dev para ver cómo funciona.

Si navega muchas rutas y necesita datos que estaban en su controlador previamente usado, sólo necesita usar GetBuilder otra vez (sin inicio):

```dart
class OtherClass extends StatelessWidget {
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

Si necesitas usar tu controlador en muchos otros lugares, y fuera de GetBuilder, sólo tienes que crear un get en tu controlador y tenerlo fácilmente. (o usa `Get.find<Controller>()` )

```dart
class Controller extends GetxController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.increment();
  /// with no static method: Get.find<Controller>().increment();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other the IDE will autocomplete it.
  static Controller get to => Get.find(); // add this line

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

Y entonces puedes acceder directamente a tu controlador, de esa manera:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

Al pulsar FloatingActionButton, todos los widgets que estén escuchando la variable 'contador' se actualizarán automáticamente.

### Cómo maneja los controladores

Digamos lo siguiente:

`Clase a => Clase B (tiene controlador X) => Clase C (tiene controlador X)`

En la clase A, el controlador no está todavía en la memoria, porque aún no la ha utilizado (Get is lazyLoad). En la clase B usó el controlador, y entró en la memoria. En la clase C utilizaste el mismo controlador que en la clase B, Obtener compartirá el estado del controlador B con el controlador C, y el mismo controlador todavía está en memoria. Si cierra la pantalla C y la pantalla B, Get sacará automáticamente el controlador X de la memoria y liberará recursos porque la clase a no está usando el controlador. Si navega a B de nuevo, el controlador X volverá a entrar en la memoria, si en lugar de ir a la clase C, volviendo a la clase A otra vez, Get sacará el controlador de la memoria de la misma manera. Si la clase C no usó el controlador, y sacaste la clase B de la memoria, ninguna clase usaría el controlador X y tampoco estaría dispuesta. La única excepción que puede molestar con Get, es si elimina B de la ruta inesperadamente, e intenta usar el controlador en C. En este caso, el ID del creador del controlador que estaba en B fue eliminado, y Get fue programado para eliminarlo de la memoria de cada controlador que no tiene ID de creador. Si usted tiene la intención de hacer esto, agregue la bandera "autoRemove: false" a la clase B GetBuilder y use adoptID = true; en la clase C GetBuilder.

### Ya no necesitarás StatefulWidgets

Usar StatefulWidgets significa almacenar el estado de pantallas enteras innecesariamente, incluso porque necesita reconstruir mínimamente un widget, lo insertarás en un Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, el cual será otro StatefulWidget.
La clase StatefulWidget es una clase mayor que StatelessWidget, que asignará más RAM, y esto puede no marcar una diferencia significativa entre una o dos clases, pero sin duda lo hará cuando tenga 100 de ellas!
A menos que necesite usar una mixin, como TickerProviderStateMixin, será totalmente innecesario usar un StatefulWidget con Get.

Puedes llamar a todos los métodos de un StatefulWidget directamente desde un GetBuilder.
Si necesita llamar al método initState() o dispose() por ejemplo, puede llamarlos directamente;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Un enfoque mucho mejor que esto es usar el método onInit() y onClose() directamente desde el controlador.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- NOTA: Si quieres iniciar un método por el momento el controlador es llamado por primera vez, NO ES NECESARIO usar constructores para esto, de hecho, usando un paquete orientado al rendimiento como Get, esto limita con la mala práctica. porque se desvia de la lógica en la que se crean o asignan los controladores (si se crea una instancia de este controlador, el constructor será llamado inmediatamente, estarás poblando un controlador antes de que se utilice, está asignando memoria sin que esté en uso, esto definitivamente perjudica los principios de esta biblioteca). Los métodos onInit(); y onClose(); fueron creados para esto, serán llamados cuando el controlador sea creado, o usado por primera vez, dependiendo de si usted está usando Get. azyPut o no. Si quieres, por ejemplo, hacer una llamada a tu API para rellenar datos, puedes olvidarte del método anticuado de initState/dispose, simplemente inicia tu llamada a la api en onInit, y si necesitas ejecutar cualquier comando como cerrar streams, usa onClose() para eso.

### Por qué existe

El propósito de este paquete es precisamente ofrecerle una solución completa para la navegación de rutas, gestión de dependencias y estados, utilizando las menos dependencias posibles, con un alto grado de desacoplamiento. Consiga involucrarse con todas las APIs de nivel alto y bajo dentro de sí mismo, para asegurarse de que trabaja con el menor acoplamiento posible. Centralizamos todo en un solo paquete, para asegurar que no tenga ningún tipo de acoplamiento en su proyecto. De esa manera, solo puedes poner widgets en tu vista, y dejar libre la parte de tu equipo que trabaja con la lógica de negocio. trabajar con la lógica de negocio sin depender de ningún elemento de la Vista. Esto proporciona un entorno de trabajo mucho más limpio, de modo que parte de tu equipo sólo funciona con widgets, sin preocuparse por enviar datos a tu controlador, y parte de su equipo trabaja sólo con la lógica de negocio en su pan, sin depender de ningún elemento de la vista.

Así que para simplificar esto:
No necesitas llamar a métodos en initState y enviarlos por parámetro a tu controlador, ni utilice el constructor de su controlador para eso, tiene el método onInit() que se llama en el momento adecuado para iniciar sus servicios.
No necesita llamar al dispositivo, tiene el método onClose() que será llamado en el momento exacto en que su controlador ya no es necesario y será eliminado de la memoria. De esa manera, deje las vistas para los widgets solamente, acepte cualquier tipo de lógica de negocio de ella.

No llamar a un método de dispose dentro de GetxController, no hará nada, recuerda que el controlador no es un Widget, no debería "eliminarlo", y será eliminada de forma automática e inteligente de la memoria por Get. Si ha utilizado alguna secuencia en ella y quiere cerrarla, simplemente insertarla en el método de cierre. Ejemplo:

```dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// close stream = onClose method, not dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Ciclo de vida del controlador:

- onInit() donde se crea.
- onClose() donde está cerrado para realizar cualquier cambio en la preparación del método de eliminación
- eliminado: no tiene acceso a esta API porque está literalmente eliminando el controlador de la memoria. Es literalmente eliminado, sin dejar rastro.

### Otras formas de usarlo

Puede utilizar la instancia del controlador directamente en el valor de GetBuilder:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

También puede que necesites una instancia de tu controlador fuera de tu GetBuilder, y puedes usar estos métodos para lograr esto:

```dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// on you view:
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Controller.to.counter}', //here
  )
),
```

o

```dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // with no static get
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

- Puedes usar enfoques "no canónicos" para hacer esto. Si estás usando algún otro gestor de dependencias, como get\_it, modular, etc., y solo quieres entregar la instancia del controlador, puedes hacer esto:

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, //here
  builder: (_) => Text(
    '${controller.counter}', // here
  ),
),

```

### IDs únicos

Si desea refinar el control de actualizaciones de un widget con GetBuilder, puede asignarles IDs únicos:

```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

Y actualícela este formulario:

```dart
update(['text']);
```

También puede imponer condiciones para la actualización:

```dart
update(['text'], counter < 10);
```

GetX hace esto automáticamente y sólo reconstruye el widget que utiliza la variable exacta que fue cambiada, si cambia una variable a la misma que la anterior y eso no implica un cambio de estado , GetX no reconstruirá el widget para ahorrar memoria y ciclos de CPU (3 se muestra en la pantalla, y cambias la variable a 3 de nuevo. En la mayoría de los administradores estatales, esto causará una nueva reconstrucción, pero con GetX el widget sólo se reconstruirá de nuevo, si de hecho su estado ha cambiado).

## Mezclar los dos administradores estatales

Algunas personas abrieron una petición de características, ya que querían usar solo un tipo de variable reactiva, y las otras mecánicas, y necesarias para insertar un Obx en un GetBuilder para esto. Pensando en ello se creó MixinBuilder. Permite tanto cambios reactivos cambiando variables ".obs", como actualizaciones mecánicas a través de update(). Sin embargo, de los 4 widgets él es el que consume más recursos, ya que además de tener una Suscripción para recibir eventos de cambio de sus hijos, se suscribe al método de actualización de su controlador.

Extender GetxController es importante, ya que tienen ciclos de vida, y pueden "iniciar" y "terminar" eventos en sus métodos onInit() y onClose(). Puede usar cualquier clase para esto, pero le recomiendo encarecidamente que utilice la clase GetxController para colocar sus variables, sean observables o no.

## Mixin de estado

Otra forma de manejar tu estado `UI` es usar el `StateMixin<T>` .
Para implementarlo, usa el `con` para agregar el `StateMixin<T>`
a tu controlador que permite un modelo T.

```dart
class Controller extends GetController with StateMixin<User>{}
```

El método `change()` cambia el Estado siempre que queremos.
Simplemente pase los datos y el estado de esta manera:

```dart
change(data, status: RxStatus.success());
```

RxStatus permite estos estados:

```dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Para representarlo en la interfaz de usuario, use:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

## GetBuilder vs GetX vs Obx vs MixinBuilder

En una década trabajando con la programación pude aprender algunas lecciones valiosas.

Mi primer contacto con la programación reactiva fue tan "wow, esto es increíble" y de hecho la programación reactiva es increíble.
Sin embargo, no es adecuado para todas las situaciones. A menudo todo lo que necesitas es cambiar el estado de 2 o 3 widgets al mismo tiempo, o un cambio efemeral de estado, en cuyo caso la programación reactiva no es mala, pero no es apropiada.

La programación reactiva tiene un mayor consumo de RAM que puede ser compensado por el flujo de trabajo individual, que asegurará que sólo un widget sea reconstruido y cuando sea necesario, pero crear una lista con 80 objetos, cada uno con varios streams no es una buena idea. Abre el oscurecimiento y comprueba cuánto consume un StreamBuilder, y entenderás lo que estoy tratando de decirte.

Con eso en mente, creé el simple gestor estatal. Es simple, y eso es exactamente lo que debería exigir de él: actualizar el estado en bloques de una manera sencilla, y de la manera más económica.

GetBuilder es muy económico en RAM, y apenas hay un enfoque más económico que él (al menos no puedo imaginar uno, si existe, por favor háganoslo saber).

Sin embargo, GetBuilder sigue siendo un gestor de estado mecánico, necesita llamar update() del mismo modo que necesita llamar notificar a Provider().

Hay otras situaciones en las que la programación reactiva es realmente interesante, y no trabajar con ella es lo mismo que reinventar la rueda. Con esto en mente, GetX fue creado para proporcionar todo lo que es más moderno y avanzado en un administrador estatal. Actualiza sólo lo que es necesario y cuando es necesario, si tiene un error y envía 300 cambios de estado simultáneamente, GetX filtrará y actualizará la pantalla sólo si el estado realmente cambia.

GetX es aún más económico que cualquier otro gestor de estado reactivo, pero consume un poco más de RAM que GetBuilder. Pensando en ello y tratando de maximizar el consumo de recursos que Obx fue creado. A diferencia de GetX y GetBuilder, no podrás inicializar un controlador dentro de un Obx, es sólo un Widget con un StreamSubssubscription que recibe cambios de eventos de sus hijos, eso es todo. Es más económico que GetX, pero pierde en GetBuilder, que era de esperar, ya que es reactivo, y GetBuilder tiene el enfoque más simplista que existe, de almacenar el hashcode de un widget y su StateSetter. Con Obx no necesitas escribir tu tipo de controlador y puedes escuchar el cambio desde múltiples controladores diferentes, pero necesita inicializarse antes, ya sea usando el método de ejemplo al principio de este readme, o usando la clase Bindings.
