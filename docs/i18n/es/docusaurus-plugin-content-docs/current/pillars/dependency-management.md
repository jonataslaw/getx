---
sidebar_position: 3
---

# Dependencia

Get tiene un gestor de dependencias simple y potente que te permite recuperar la misma clase que tu Bloc o Controlador con solo 1 línea de código, sin contexto de proveedores, sin inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

En lugar de instanciar su clase dentro de la clase que está usando, lo instancias dentro de la instancia Obténgala, que lo hará disponible a través de tu aplicación.
Así que puedes usar tu controlador (o clase Bloc) normalmente

- Nota: Si estás usando Get's State Manager, presta más atención a la app [Bindings](#bindings), lo que hará más fácil conectar tu vista a tu controlador.
- Nota2: Obtener la gestión de dependencias es desglosado de otras partes del paquete, así que si por ejemplo tu aplicación ya está usando un administrador de estado (cualquier otro, no importa), no necesitas cambiar eso, puedes usar este gestor de inyección de dependencias sin ningún problema

## Métodos de Instancia

Los métodos y sus parámetros configurables son:

### Get.put()

La forma más común de insertar una dependencia. Bueno para los controladores de tus vistas, por ejemplo.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Esto es todas las opciones que se pueden establecer al usar put:

```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: "S" means that it can be a class of any type
  S dependency

  // optional: this is for when you want multiple classess that are of the same type
  // since you normally get a class by using Get.find<Controller>(),
  // you need to use tag to tell which instance you need
  // must be unique string
  String tag,

  // optional: by default, get will dispose instances after they are not used anymore (example,
  // the controller of a view that is closed), but you might need that the instance
  // to be kept there throughout the entire app, like an instance of sharedPreferences or something
  // so you use this
  // defaults to false
  bool permanent = false,

  // optional: allows you after using an abstract class in a test, replace it with another one and follow the test.
  // defaults to false
  bool overrideAbstract = false,

  // optional: allows you to create the dependency using function instead of the dependency itself.
  // this one is not commonly used
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut

Es posible lazyLoad una dependencia para que se instancie sólo cuando se use. Muy útil para clases caras computacionales o si desea instanciar varias clases en un solo lugar (como en una clase Bindings) y sabe que no va a utilizar esa clase en ese momento.

```dart
/// ApiMock will only be called when someone uses Get.find<ApiMock> for the first time
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... some logic if needed
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

Esta es todas las opciones que puedes establecer al usar lazyPut:

```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  InstanceBuilderCallback builder,
  
  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: It is similar to "permanent", the difference is that the instance is discarded when
  // is not being used, but when it's use is needed again, Get will recreate the instance
  // just the same as "SmartManagement.keepFactory" in the bindings api
  // defaults to false
  bool fenix = false
  
)
```

### Get.putAsync

Si desea registrar una instancia asíncrona, puede utilizar `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

Esto es todas las opciones que se pueden establecer cuando se utiliza putAsync:

```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  AsyncInstanceBuilderCallback<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
)
```

### Get.create

Este es complicado. Una explicación detallada de lo que es esto y de las diferencias entre el otro se puede encontrar en la sección [Diferencias entre métodos:](#differences-between-methods)

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Estas son todas las opciones que puedes establecer al usar create:

```dart
Get.create<S>(
  // required: a function that returns a class that will be "fabricated" every
  // time `Get.find()` is called
  // Example: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // optional: just like Get.put(), but it is used when you need multiple instances
  // of a of a same class
  // Useful in case you have a list that each item need it's own controller
  // needs to be a unique string. Just change from tag to name
  String name,

  // optional: just like int`Get.put()`, it is for when you need to keep the
  // instance alive thoughout the entire app. The difference is in Get.create
  // permanent is true by default
  bool permanent = true
```

## Usando métodos/clases instanciadas

Imagina que has navegado a través de numerosas rutas, y necesitas un dato que se haya dejado atrás en tu controlador, Necesitaría un administrador estatal combinado con el Proveedor o Get\_it, ¿correcto? No con obtener. Sólo necesitas preguntar Get to "encontrd" para tu controlador, no necesitas ninguna dependencia adicional:

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// Yes, it looks like Magic, Get will find your controller, and will deliver it to you.
// You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Y entonces podrás recuperar los datos de tu controlador que se obtuvieron de vuelta allí:

```dart
Text(controller.textFromApi);
```

Dado que el valor devuelto es una clase normal, puedes hacer lo que quieras:

```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Para remover una instancia de Get:

```dart
Get.delete<Controller>(); //usually you don't need to do this because GetX already delete unused controllers
```

## Especificar una instancia alternativa

Una instancia actualmente insertada puede ser reemplazada con una instancia de clase similar o extendida usando el método `replace` o `lazyReplace`. Esto puede ser recuperado usando la clase original.

```dart
abstract class BaseClass {}
class ParentClass extends BaseClass {}

class ChildClass extends ParentClass {
  bool isChild = true;
}


Get.put<BaseClass>(ParentClass());

Get.replace<BaseClass>(ChildClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); //true


class OtherClass extends BaseClass {}
Get.lazyReplace<BaseClass>(() => OtherClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); // false
print(instance is OtherClass); //true
```

## Diferencias entre métodos

Primero, vamos al "fenix" de Get.lazyPut y al "permanente" de los otros métodos.

La diferencia fundamental entre `permanent` y `fenix` es cómo quieres almacenar tus instancias.

Refuerzo: por defecto, GetX elimina las instancias cuando no están en uso.
Significa que: Si la pantalla 1 tiene el controlador 1 y la pantalla 2 tiene el controlador 2 y se quita la primera ruta de la pila, (como si usas `Obtener. ff()` o `Get.offNamed()`) el controlador 1 perdió su uso por lo que será borrado.

Pero si quieres optar por usar `permanent:true`, entonces el controlador no se perderá en esta transición - que es muy útil para los servicios que desea mantener vivo a lo largo de toda la aplicación.

`fenix` en la otra mano es para servicios que no te preocupas al perder entre los cambios de pantalla, pero cuando usted necesita ese servicio, usted espera que esté vivo. Básicamente, dispondrá el controlador/servicio/clase/clase no utilizado, pero cuando lo necesite, "recreará desde las ashes" una nueva instancia.

Continuando con las diferencias entre métodos:

- Get.put y Get. utAsync sigue el mismo orden de creación, con la diferencia de que el segundo utiliza un método asíncrono: esos dos métodos crean e inicializan la instancia. Que uno se inserta directamente en la memoria, usando el método interno `insert` con los parámetros `permanente: false` y `isSingleton: true` (este parámetro isSingleton sólo tiene el propósito de indicar si es para usar la dependencia de `dependency` o si es para usar la dependencia de `FcBuilderFunc`). Después de eso, `Get.find()` es llamado que inmediatamente inicializa las instancias que están en memoria.

- Get.create: ¡Como su nombre lo implica, "creará" su dependencia! Similar a `Get.put()`, también llama al método interno `insert` para instanciar. Pero `permanent` se hizo cierto y `isSingleton` se volvió falso (ya que estamos "creando" nuestra dependencia, no hay manera de que sea una instancia singleton, por eso es falso). Y porque tiene `permanente: true`, tenemos por defecto el beneficio de no perderlo entre las pantallas! Además, `Get.find()` no se llama inmediatamente, espera a ser usado en la pantalla para ser llamado. Se crea de esta manera para hacer uso del parámetro `permanent`, desde entonces, vale la pena observar, `Obtener. reate()` se hizo con el objetivo de crear instancias no compartidas, pero no eliminar, como por ejemplo un botón en una listView, que desea una instancia única para esa lista - por eso, Obtener. reate debe ser utilizado junto con GetWidget.

- Get.lazyPut: Como su nombre implica, es un proceso perezoso. La instancia es creada, pero no es llamada para ser utilizada inmediatamente, permanece esperando a ser llamada. Contrario a los otros métodos, `insert` no es llamado aquí. En su lugar, la instancia se inserta en otra parte de la memoria, una parte responsable de decir si la instancia puede ser recreada o no, llamémosla "fábrica". Si queremos crear algo que se utilice más tarde, no se mezclará con las cosas que se han utilizado en este momento. Y aquí es donde entra la magia de `fenix`: si optas por dejar `fenix: false`, y tu `smartManagement` no son `keepFactory`, entonces cuando usas `Get. ind` la instancia cambiará el lugar en la memoria de la "fábrica" al área de memoria de instancia común. Justo después de eso, por defecto se elimina de la "fábrica". Ahora, si optas por `fenix: true`, la instancia sigue existiendo en esta parte dedicada, ir incluso al espacio común para ser llamado de nuevo en el futuro.

## Enlaces

Una de las grandes diferencias de este paquete, tal vez, es la posibilidad de la plena integración de las rutas, el administrador del estado y el gestor de dependencias.
Cuando una ruta es removida de la pila, todos los controladores, variables e instancias de objetos relacionados con ella son removidos de la memoria. Si está usando secuencias o temporizadores, se cerrarán automáticamente, y no tiene que preocuparse por nada de eso.
En la versión 2.10 Obtenga la implementación completa de la API Bindings.
Ahora ya no necesita utilizar el método init. Ni siquiera tienes que escribir tus controladores si no quieres. Puedes iniciar tus controladores y servicios en el lugar apropiado para ello.
La clase Binding es una clase que desacoplará la inyección de dependencias, mientras que las rutas "vinculantes" al administrador de estado y al gestor de dependencias.
Esto le permite a Get saber qué pantalla se muestra cuando se utiliza un controlador en particular y saber dónde y cómo eliminarlo.
Además, la clase Binding le permitirá tener el control de configuración de SmartManager. Puede configurar las dependencias a organizar al eliminar una ruta de la pila, o cuando el widget que lo usó está dispuesto, o ninguna de las dos. Tendrás una gestión inteligente de dependencias trabajando para ti, pero aún así, puedes configurarla como quieras.

### Clase de enlaces

- Crear una clase e implementa Binding

```dart
class HomeBinding implements Bindings {}
```

Su IDE automáticamente le pedirá que reemplace el método "dependencias" y sólo necesita hacer clic en la lámpara, sobreescribir el método, e insertar todas las clases que va a utilizar en esa ruta:

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<Service>(()=> Api());
  }
}

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
```

Ahora sólo necesita informar a su ruta, que utilizará ese enlace para hacer la conexión entre el gestor de rutas, las dependencias y los estados.

- Usando rutas nombradas:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: DetailsBinding(),
  ),
];
```

- Usando rutas normales:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Allí, ya no tienes que preocuparte por la administración de memoria de tu aplicación. Get lo hará por ti.

La clase Binding es llamada cuando se llama a una ruta, puedes crear un "initialBinding en tu GetMaterialApp para insertar todas las dependencias que se crearán.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### Constructor de enlaces

La forma predeterminada de crear un enlace es creando una clase que implemente Bindings.
Pero alternativamente, puedes usar el callback `BindingsBuilder` para que puedas simplemente usar una función para instanciar lo que desees.

Ejemplo:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

De esta manera puede evitar crear una clase Binding para cada ruta, haciendo esto aún más sencillo.

Ambas formas de trabajar perfectamente y queremos que usted utilice lo que más se adapte a sus gustos.

### Gestión inteligente

GetX por defecto dispone de controladores no utilizados de la memoria, incluso si ocurre un fallo y un widget que lo usa no está correctamente eliminado.
Esto es lo que se llama el modo 'completo' de gestión de dependencias.
Pero si quieres cambiar la forma en que GetX controla la eliminación de clases, tienes la clase `SmartManagement` que puedes establecer diferentes comportamientos.

#### Cómo cambiar

Si desea cambiar esta configuración (que normalmente no necesita) esta es la manera:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilder //here
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

Es el predeterminado. Descartar las clases que no están siendo usadas y que no están configuradas como permanentes. En la mayoría de los casos querrá mantener esta configuración sin tocar. Si usted es nuevo en GetX entonces no cambie esto.

#### SmartManagement.onlyBuilder

Con esta opción, sólo se eliminarán los controladores iniciados en `init:` o cargados en un enlace con `Get.lazyPut()`.

Si utiliza `Get.put()` o `Get.putAsync()` o cualquier otro enfoque, SmartManagement no tendrá permisos para excluir esta dependencia.

Con el comportamiento por defecto, incluso los widgets instanciados con "Get.put" serán eliminados, a diferencia de SmartManagement.onlyBuilder.

#### SmartManagement.keepFactory

Al igual que SmartManagement.full, eliminará sus dependencias cuando ya no se esté usando. Sin embargo, mantendrá su fábrica, lo que significa que recreará la dependencia si se necesita esa instancia de nuevo.

### Cómo funcionan los enlaces bajo el capó

Los enlaces crean fábricas de transitorio, que se crean en el momento en que hace clic para ir a otra pantalla, y será destruido tan pronto como ocurra la animación de cambio de pantalla.
Esto sucede tan rápido que el analizador ni siquiera será capaz de registrarlo.
Cuando navega a esta pantalla de nuevo, se llamará a una nueva fábrica temporal, por lo que es preferible usar SmartManagement. eepFactory, pero si no quieres crear enlaces, o quieres mantener todas tus dependencias en el mismo enlace, seguramente te ayudará.
Las fábricas ocupan poca memoria, no guardan las instancias, sino una función con la "forma" de la clase que quieras.
Esto tiene un costo muy bajo en la memoria, pero dado que el propósito de esta librería es obtener el máximo rendimiento posible utilizando los recursos mínimos, Obtener elimina incluso las fábricas de forma predeterminada.
Utilice el que más le convenga.

## Notas

- NO USE SmartManagement.keepFactory si está utilizando múltiples enlaces. Ha sido diseñado para ser utilizado sin enlaces, o con un solo enlazado en el initialBinding de GetMaterialApp.

- Usar enlaces es completamente opcional, si lo deseas, puedes usar `Get.put()` y `Get.find()` en clases que usan un controlador dado sin ningún problema.
  Sin embargo, si usted trabaja con Servicios o cualquier otra abstracción, recomiendo usar Bindings para una mejor organización.
