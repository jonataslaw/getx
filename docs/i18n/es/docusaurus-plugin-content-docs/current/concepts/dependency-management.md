---
sidebar_position: 3
---

# Gestión de dependencias

Get tiene un gestor de dependencias simple y potente que te permite recuperar la misma clase que tu Bloc o Controlador con solo 1 línea de código, sin contexto de proveedores, sin inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Nota: Si está usando Get's State Manager, preste más atención a la API de enlaces, lo que hará más fácil conectar tu vista a tu controlador.

En lugar de instanciar su clase dentro de la clase que está usando, lo instancias dentro de la instancia Obténgala, que lo hará disponible a través de tu aplicación.
Así que puede utilizar su controlador (o bloque de clase) normalmente

**Consejo:** Obtener la gestión de dependencias está desacoplado de otras partes del paquete, así que, si por ejemplo, tu aplicación ya está usando un administrador de estado (cualquier otro, no importa), no necesitas reescribirlo todo, puedes usar esta inyección de dependencias sin ningún problema

```dart
controller.fetchApi();
```

Imagina que has navegado a través de numerosas rutas, y necesitas datos que quedaron atrás en tu controlador, Necesitaría un administrador estatal combinado con el Proveedor o Get\_it, ¿correcto? No con obtener. Sólo necesitas preguntar Get to "encontrd" para tu controlador, no necesitas ninguna dependencia adicional:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Y entonces podrás recuperar los datos de tu controlador que se obtuvieron de vuelta allí:

```dart
Text(controller.textFromApi);
```

### Más detalles sobre la gestión de dependencias

**Ver una explicación más detallada de la gestión de dependencias [here](/docs/pillars/dependency-management)**
