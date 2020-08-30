- [Gestión de dependencias](#gestión-de-dependencias)
  - [Simple Instance Manager](#simple-instance-manager)
  - [Options](#options)
  - [Bindings](#bindings)
    - [Cómo utilizar](#cómo-utilizar)
  - [SmartManagement](#smartmanagement)


# Gestión de dependencias

## Simple Instance Manager

- Nota: si está utilizando el gestor de estado de GetX, no tiene que preocuparse por esto, solo lea para obtener información, pero preste más atención a la API de bindings, que hará todo esto automáticamente por usted.

¿Ya estás utilizando GetX y quieres que tu proyecto sea lo más ágil posible? GetX tiene un gestor de dependencias simple y poderoso que le permite recuperar la misma clase que su BLoC o Controller con solo una líneas de código, sin contexto de Provider, sin inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

En lugar de crear una instancia de su clase dentro de la clase que está utilizando, la está creando dentro de la instancia GetX, que la hará disponible en toda su aplicación. Entonces puede usar su Controller (o BLoC) normalmente.

```dart
controller.fetchApi();
```

Imagine que ha navegado a través de numerosas rutas y necesita datos que quedaron en su controlador, necesitaría un gestor de estado combinado con Providere o Get_it, ¿correcto? No con GetX. Solo necesita pedirle a GetX que "encuentre" su controlador, no necesita dependencias adicionales:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Y luego podrá recuperar los datos de su controlador que se obtuvieron allí:

```dart
Text(controller.textFromApi);
```

¿Buscando lazy loading? Puede declarar todos sus controladores, y se llamará solo cuando alguien lo necesite. Puedes hacer esto con:

```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock will only be called when someone uses Get.find<Service> for the first time
```

Si desea registrar una instancia asincrónica, puede usar Get.putAsync.

```dart
Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 12345);
    return prefs;
});
```

uso:

```dart
  int count = Get.find<SharedPreferences>().getInt('counter');
  print(count);
  // out: 12345
}
```

Para eliminar una instancia de GetX:

```dart
Get.delete<Controller>();
```

## Instancing methods

Although Getx already delivers very good settings for use, it is possible to refine them even more so that it become more useful to the programmer. The methods and it's configurable parameters are:

- Get.put():

```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: that "S" means that it can be anything
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
  FcBuilderFunc<S> builder,
)
```

- Get.lazyPut:

```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  // Example: Get.lazyPut<Controller>( () => Controller() )
  FcBuilderFunc builder,
  
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

- Get.putAsync:

```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  // Example: Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
  FcBuilderFuncAsync<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
```

- Get.create:

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

### Diferences between methods:

First, let's of the `fenix` of Get.lazyPut and the `permanent` of the other methods.

The fundamental difference between `permanent` and `fenix` is how you want to store your instances.
Reinforcing: by default, GetX deletes instances when they are not is use.
It means that: If screen 1 has controller 1 and screen 2 has controller 2 and you remove the first route from stack, (like if you use `Get.off()` or `Get.offName()`) the controller 1 lost it's use so it will be erased.
But if you want to opt to `permanent:true`, then the controller will not be lost in this transition - which is very usefult for services that you want to keep alive thoughout the entire application.
`fenix` in the other hand is for services that you don't worry in losing between screen changes, but when you need that service, you expect that it is alive. So basically, it will dispose the unused controller/service/class, but when you need that, it will "recreate from the ashes" a new instance.

Proceeding with the differences between methods: 

- Get.put and Get.putAsync follow the same creation order, with the difference that asyn opt for applying a asynchronous method: those two methods create and initialize the instance. That one is inserted directly in the memory, using the internal method `insert` with the parameters `permanent: false` and `isSingleton: true` (this isSingleton parameter only porpuse is to tell if it is to use the dependency on `dependency` or if it is to use the dependency on `FcBuilderFunc`). After that, `Get.find()` is called that immediately initialize the instances that are on memory.

- Get.create: As the name implies, it will "create" your dependency! Similar to `Get.put()`, it also call the internal method `insert` to instancing. But `permanent` became true and `isSingleton` became false (since we are "creating" our dependency, there is no way for it to be a singleton instace, that's why is false). And because it has `permanent: true`, we have by default the benefit of not losing it between screens! Also, `Get.find()` is not called immediately, it wait to be used in the screen to be called. It is created this way to make use of the parameter `permanent`, since then, worth noticing, `Get.create()` was made with the goal of create not shared instances, but don't get disposed, like for example a button in a listView, that you want a unique instance for that list - because of that, Get.create must be used together with GetWidget.

- Get.lazyPut: As the name implies, it is a lazy proccess. The instance is create, but it is not called to be used immediately, it remains waiting to be called. Contrary to the other methods, `insert` is not called here. Instead, the instance is inserted in another part of the memory, a part responsable to tell if the instance can be recreated or not, let's call it "factory". If we want to create something to be used later, it will not be mix with things been used right now. And here is where `fenix` magic enters: if you opt to leaving `fenix: false`, and your `smartManagement` are not `keepFactory`, then when using `Get.find` the instance will change the place in the memory from the "factory" to common instance memory area. Right after that, by default it is removed from the "factory". Now, if you opt for `fenix: true`, the instance continues to exist in this dedicated part, even going to the common area, to be called again in the future.


## Bindings

Una de las grandes diferencias de este paquete, tal vez, es la posibilidad de una integración completa de las rutas, gestor de estado y dependencias.

Cuando se elimina una ruta del stack, todos los controladores, variables e instancias de objetos relacionados con ella se eliminan de la memoria. Si está utilizando stream o timers, se cerrarán automáticamente y no tendrá que preocuparse por nada de eso.

En la versión 2.10 GetX se implementó por completo la API de bindings.

Ahora ya no necesita usar el método init. Ni siquiera tiene que escribir sus controladores si no lo desea. Puede iniciar sus controladores y servicios en un lugar apropiado para eso.

La clase Binding es una clase que desacoplará la inyección de dependencia, al tiempo que vinculará rutas con el gestor de estado y el gestor de dependencias.

Esto permite conocer qué pantalla se muestra cuando se utiliza un controlador en particular y saber dónde y cómo descartarlo.

Además, la clase Binding le permitirá tener el control de configuración SmartManager. Puede configurar las dependencias que se organizarán al eliminar una ruta de la pila, o cuando el widget que lo usó se presenta, o ninguno de los dos. Tendrá una gestión inteligente de dependencias que funcione para usted, pero aun así, puede configurarla como desee.

### Cómo utilizar

- Crea una clase e implementa Binding

```dart
class HomeBinding implements Bindings{
```

Su IDE le pedirá automáticamente que anule el método de "dependencies", y solo necesita hacer clic en la lámpara, anular el método e insertar todas las clases que va a utilizar en esa ruta:

```dart
class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
    Get.lazyPut<Service>(()=> Api());
  }
}
```

Ahora solo necesita informar su ruta, que utilizará ese binding para establecer la conexión entre el gestor de rutas, las dependencias y los estados.

- Uso de rutas nombradas:

```dart
namedRoutes: {
  '/': GetRoute(Home(), binding: HomeBinding())
}
```

- Usando rutas normales:

```dart
Get.to(Home(), binding: HomeBinding());
```

Allí, ya no tiene que preocuparse por la administración de memoria de su aplicación, GetX lo hará por usted.

La clase Binding se llama cuando se llama una ruta, puede crear un initialBinding en su GetMaterialApp para insertar todas las dependencias que se crearán.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

## SmartManagement

Siempre prefiera usar SmartManagement estándar (full), no necesita configurar nada para eso, GetX ya se lo proporciona de forma predeterminada. Seguramente eliminará todos los controladores en desuso de la memoria, ya que su control refinado elimina la dependencia, incluso si se produce un error y un widget que lo utiliza no se elimina correctamente.

El modo "full" también es lo suficientemente seguro como para usarlo con StatelessWidget, ya que tiene numerosos callbacks de seguridad que evitarán que un controlador permanezca en la memoria si ningún widget lo está utilizando, y los disposers no son importante aquí. Sin embargo, si le molesta el comportamiento predeterminado, o simplemente no quiere que suceda, GetX ofrece otras opciones más indulgentes para la administración inteligente de la memoria, como SmartManagement.onlyBuilders, que dependerá de la eliminación efectiva de los widgets que estén usando el controller para eliminarlo, y puede evitar que se implemente un controlador usando "autoRemove: false" en su GetBuilder/GetX.

Con esta opción, solo se eliminarán los controladores iniciados en "init:" o cargados en un enlace con "Get.lazyPut"; si usa Get.put o cualquier otro enfoque, SmartManagement no tendrá permisos para excluir esta dependencia.

Con el comportamiento predeterminado, incluso los widgets instanciados con "Get.put" se eliminarán, a diferencia de SmartManagement.onlyBuilders.

SmartManagement.keepFactory es como SmartManagement.full, con una diferencia. SmartManagement.full purga los factories de las premises, de modo que Get.lazyPut() solo podrá llamarse una vez y su factory y sus referencias se autodestruirán. SmartManagement.keepFactory eliminará sus dependencias cuando sea necesario, sin embargo, mantendrá la "forma" de estas, para hacer una igual si necesita una instancia de eso nuevamente.

En lugar de usar SmartManagement.keepFactory, puede usar Bindings.

Bindings crea factories transitorios, que se crean en el momento en que hace clic para ir a otra pantalla, y se destruirán tan pronto como ocurra la animación de cambio de pantalla. Es tan poco tiempo que el analizador ni siquiera podrá registrarlo. Cuando navegue de nuevo a esta pantalla, se llamará a una nueva factory temporal, por lo que es preferible usar SmartManagement.keepFactory, pero si no desea crear enlaces o desea mantener todas sus dependencias en el mismo enlace, sin duda te ayudará. Las factories ocupan poca memoria, no tienen instancias, sino una función con la "forma" de esa clase que desea. Esto es muy poco, pero dado que el propósito de esta lib es obtener el máximo rendimiento posible utilizando los recursos mínimos, GetX elimina incluso las factories por defecto. Use el que sea más conveniente para usted.

- NOTA: NO USE SmartManagement.keepFactory si está utilizando bindings múltiples. Fue diseñado para usarse sin bindings, o con uno único vinculado en el binding inicial de GetMaterialApp.

- NOTA2: El uso de bindings es completamente opcional, puede usar Get.put() y Get.find() en clases que usan un controlador dado sin ningún problema.

Sin embargo, si trabaja con Servicios o cualquier otra abstracción, le recomiendo usar binding para una organización más grande.
