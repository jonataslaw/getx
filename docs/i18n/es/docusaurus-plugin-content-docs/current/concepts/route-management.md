---
sidebar_position: 2
---

# Gestión de rutas

Si vas a usar rutas/barras/barrashacas/diálogo/hojas de abajo sin contexto, GetX es excelente para ti también, solo verlo:

Añade "Obtener" antes de tu MaterialApp, convirtiéndola en GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Navegar a una nueva pantalla:

```dart

Get.to(NextScreen());
```

Navega a la nueva pantalla con nombre. Ver más detalles sobre rutas con nombre [here](/docs/pillars/route-management#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

Para cerrar barras de rejillas, diálogos, hojas de fondo, o cualquier cosa que normalmente cierre con Navigator.pop(context);

```dart
Get.back();
```

Para ir a la siguiente pantalla y no hay opción para volver a la pantalla anterior (para uso en SplashScreens, pantallas de inicio de sesión, etc.)

```dart
Get.off(NextScreen());
```

Para ir a la siguiente pantalla y cancelar todas las rutas anteriores (útil en carritos de la compra, encuestas y pruebas)

```dart
Get.offAll(NextScreen());
```

¿Has notado que no tienes que usar contexto para hacer ninguna de estas cosas? Esta es una de las mayores ventajas de usar Get route manager. Con esto, puede ejecutar todos estos métodos desde la clase de su controlador, sin preocuparse.

### Más detalles sobre la gestión de rutas

**¡Hazte trabajar con rutas con nombre y también ofrece un control de bajo nivel sobre tus rutas! Hay documentación en profundidad [here](/docs/pillars/route-management)**
