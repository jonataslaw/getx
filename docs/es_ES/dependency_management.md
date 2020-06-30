
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
