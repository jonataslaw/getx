---
sidebar_position: 1
---

# Empezar

## Pruebas

### Instalando

Añade a tu archivo pubspec.yaml:

```yml
dependencies:
  get:
```

Importar los archivos que se utilizarán:

```dart
import 'package:get/get.dart';
```

### Contador de aplicación con GetX

El proyecto "contador" creado por defecto en el nuevo proyecto en Flutter tiene más de 100 líneas (con comentarios). Para mostrar el poder de Get, demostraré cómo hacer un "contador" cambiando el estado con cada clic, cambiando entre páginas y compartiendo el estado entre pantallas, todo de una manera organizada, separando la lógica de negocio de la vista, en SOLO 26 LÍNEAS CÓDIGO INCLUDIANDO COMMENTES.

- Paso 1:
  Añade "Get" antes de tu MaterialApp, convirtiéndola en GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Nota: esto no modifica la aplicación MaterialApp de Flutter, GetMaterialApp no es una aplicación MaterialApp modificada es sólo un Widget preconfigurado, que tiene como hijo el MaterialApp predeterminado. Puede configurar esto manualmente, pero definitivamente no es necesario. GetMaterialApp creará rutas, inyectarlas, inyectar traducciones, inyectar todo lo necesario para la navegación por ruta. Si utiliza Get sólo para la administración del estado o la gestión de dependencias, no es necesario utilizar GetMaterialApp. GetMaterialApp es necesario para rutas, snackbars, internacionalización, bottomSheets, diálogos y apis de alto nivel relacionados con rutas y ausencia de contexto.

- Nota2: Este paso sólo es necesario si usted gonna usa la gestión de rutas (`Get.to()`, `Get.back()` y así sucesivamente). Si no lo usas no es necesario hacer el paso 1

- Paso 2:
  Crea tu clase lógica de negocio y coloca todas las variables, métodos y controladores dentro de ella.
  Puede hacer cualquier variable observable usando un simple ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Paso 3:
  Crea tu Vista, usa StatelessWidget y guarda algo de RAM, con Get puedes dejar de usar StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Resultado:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Este es un proyecto sencillo pero ya deja claro lo poderoso que es Get . A medida que tu proyecto crece, esta diferencia será más significativa.

Get fue diseñado para trabajar con equipos, pero hace el trabajo de un desarrollador individual simple.

Mejore sus plazos, entregue todo a tiempo sin perder el rendimiento. Get is not for everyone, but if you identified with that phrase, Get is for you!
