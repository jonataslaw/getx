---
sidebar_position: 1
---

# Gestión del estado

Get tiene dos administradores de estado diferentes: el simple administrador de estado (lo llamaremos GetBuilder) y el administrador de estado reactivo (GetX/Obx)

### Gestor de estado reactivo

La programación reactiva puede alienar a mucha gente porque se dice que es complicada. GetX convierte la programación reactiva en algo bastante simple:

- No necesitará crear StreamControllers.
- No necesitará crear un StreamBuilder para cada variable
- No necesitará crear una clase para cada estado.
- No necesitará crear un get para un valor inicial.
- No necesitará utilizar generadores de código

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

Y en la interfaz de usuario, cuando quieras mostrar ese valor y actualizar la pantalla siempre que cambien los valores, simplemente haz esto:

```dart
Obx(() => Text("${controller.name}"));
```

Eso es todo. Es _simple_ simple.

### Más detalles sobre la gestión del estado

**Ver una explicación más detallada de la gestión del estado \[here]\(/docs/pilars/gestión del estado). Allí verá más ejemplos y también la diferencia entre el gestor de estado simple y el administrador de estado reactivo**

Tendrás una buena idea de la potencia de GetX.
