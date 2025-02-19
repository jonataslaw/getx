---
sidebar_position: 2
---

# Acerca de GetX

- GetX es una solución extra ligera y potente para Flutter. Combina gestión estatal de alto rendimiento, inyección inteligente de dependencias y gestión de rutas de manera rápida y práctica.

- GetX tiene 3 principios básicos. Esto significa que estos son la prioridad para todos los recursos de la biblioteca: **PRODUCTIVIDAD, PERFORMANCIA Y ORGANIZACIÓN.**

  - **PERFORMANCE:** GetX se centra en el rendimiento y el consumo mínimo de recursos. GetX no usa Streams o ChangeNotifier.

  - **PRODUCTIVITY:** GetX utiliza una sintaxis fácil y agradable. No importa lo que quiera hacer, siempre hay una manera más fácil con GetX. Ahorrará horas de desarrollo y proporcionará el máximo rendimiento que su aplicación puede proporcionar.

    Generalmente, el desarrollador debería preocuparse por eliminar los controladores de la memoria. Con GetX esto no es necesario porque los recursos se eliminan de la memoria cuando no son usados por defecto. Si desea conservarlo en la memoria, debe declarar explícitamente "permanente: true" en su dependencia. De esta manera, además de ahorrar tiempo, corremos menos riesgo de tener dependencias innecesarias en la memoria. La carga de dependencias también es perezosa por defecto.

  - **ORGANIZACIÓN:** GetX permite el desacoplamiento total de la Vista, lógica de presentación, lógica de negocio, inyección de dependencias y navegación. No necesita contexto para navegar entre rutas, por lo que no depende del árbol de widgets (visualización) para esto. No necesitas contexto para acceder a tus controladores/bloques a través de una herededWidget, por lo que desacoplas completamente tu lógica de presentación y lógica de negocio de tu capa de visualización. No necesita inyectar las clases Controllers/Modelos/Blocs en su árbol de widgets a través de `MultiProvider`s. Para esto, GetX utiliza su propia característica de inyección de dependencias, desacoplando el DI desde su vista completamente.

    Con GetX usted sabe dónde encontrar cada característica de su aplicación, teniendo código limpio de forma predeterminada. Además de facilitar el mantenimiento, esto hace que el intercambio de módulos sea algo que hasta entonces en Flutter era impensable, algo totalmente posible.
    BLoC fue un punto de partida para organizar código en Flutter, separa la lógica de negocio de la visualización. GetX es una evolución natural de esto, no sólo separando la lógica de negocio, sino también la lógica de presentación. La inyección adicional de dependencias y rutas también se desacoplan, y la capa de datos está fuera de todo. Sabes dónde está todo y todo esto de una manera más fácil que construir un mundo feliz.
    GetX es la forma más fácil, práctica y escalable de construir aplicaciones de alto rendimiento con el Flutter SDK. Tiene un gran ecosistema a su alrededor que funciona a la perfección, es fácil para los principiantes, y es preciso para los expertos. Es seguro, estable, actualizado, y ofrece una amplia gama de API integradas que no están presentes en el SDK por defecto.

- GetX no está inflado. Tiene una multitud de características que te permiten comenzar a programar sin preocuparte de nada, pero cada una de estas características están en contenedores separados y sólo se inician después de su uso. Si sólo utiliza la Administración del Estado, sólo se compilará la Administración del Estado. Si usted sólo utiliza rutas, no se compilará nada de la gestión estatal.

- GetX tiene un enorme ecosistema, una gran comunidad, un gran número de colaboradores, y se mantendrá mientras exista el Flutter. GetX también es capaz de ejecutarse con el mismo código en Android, iOS, Web, Mac, Linux, Windows y en su servidor.
  **Es posible reutilizar completamente tu código hecho en el frontend de tu backend con [Get Server](https://github.com/jonataslaw/get_server)**.

**Además, todo el proceso de desarrollo puede ser completamente automatizado, tanto en el servidor como en el frontal con [Obtener CLI](https://github.com/jonataslaw/get_cli)**.

**Además, para aumentar aún más tu productividad, tenemos la
[extensión de VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) y la [extensión de Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

## ¿Por qué conseguir?

1- Muchas veces después de una actualización de Flutter, muchos de sus paquetes se romperán. A veces ocurren errores de compilación, a menudo aparecen errores de los que todavía no hay respuestas, y el desarrollador necesita saber de dónde viene el error, rastrear el error, sólo entonces intente abrir un problema en el repositorio correspondiente, y vea su problema resuelto. Obtener centraliza los recursos principales para el desarrollo (gestión de rutas), permitiendo añadir un solo paquete a tu pubspec, y empezar a trabajar. Después de una actualización de Flutter, lo único que necesita hacer es actualizar la dependencia Obtener y ponerse a trabajar. Obtener también resuelve problemas de compatibilidad. Cuántas veces una versión de un paquete no es compatible con la versión de otra, porque uno usa una dependencia en una versión, y el otro en otra versión? Tampoco es una preocupación utilizar Get, ya que todo está en el mismo paquete y es totalmente compatible.

2- Flutter es fácil, Flutter es increíble, pero Flutter todavía tiene algo de caldera que puede no ser deseado para la mayoría de los desarrolladores, como `Navigator. f(context).push (contexto, constructor [...]`. Obtener simplifica el desarrollo. En lugar de escribir 8 líneas de código para simplemente llamar a una ruta, puedes hacerlo: `Obtener. o(Home())` y listo, irás a la página siguiente. Las urls dinámicas de la web son algo realmente doloroso que ver con Flutter actualmente, y que con GetX es absurdamente simple. Gestionar estados en Flutter, y gestionar las dependencias también es algo que genera mucha discusión, ya que hay cientos de patrones en el pub. Pero no hay nada tan fácil como añadir un ". bs" al final de su variable, y colocar su widget dentro de un Obx, y eso es así, todas las actualizaciones de esa variable se actualizarán automáticamente en la pantalla.

3- Únete sin preocuparte por el rendimiento. El rendimiento de Flutter ya es sorprendente, pero imagina que usas un administrador de estado, y un localizador para distribuir tus clases, bloques/almacenes/controladores, etc. Tendrás que llamar manualmente a la exclusión de esa dependencia cuando no la necesites. Pero ¿alguna vez has pensado en usar simplemente tu controlador, y cuando ya no estaba siendo utilizado por nadie, simplemente se borraría de la memoria? Eso es lo que hace GetX. Con SmartManagement, todo lo que no se está usando se borra de la memoria, y no debería tener que preocuparse por nada más que programar. Estarán seguros de que están consumiendo los recursos mínimos necesarios, sin ni siquiera haber creado una lógica para ello.

4- Desacoplamiento real. Puede que haya escuchado el concepto "separar la vista de la lógica de negocio". Esto no es una pecularidad de BLoC, MVC, MVM, y cualquier otro estándar en el mercado tiene este concepto. Sin embargo, este concepto puede mitigarse a menudo en Flutter debido al uso del contexto.
Si necesita contexto para encontrar un inheritedWidget, lo necesita en la vista, o pasar el contexto por parámetro. Me parece que esta solución es muy fea, y para trabajar en equipos siempre dependeremos de la lógica empresarial de View. Getx es poco ortodoxo con el enfoque estándar, y aunque no prohíbe completamente el uso de StatefulWidgets, InitState, etc. siempre tiene un enfoque similar que puede ser más limpio. Los controladores tienen ciclos de vida, y cuando necesita hacer una solicitud APIREST por ejemplo, no depende de nada en la vista. Puede usar onInit para iniciar la llamada http, y cuando los datos llegan, las variables se llenarán. Como GetX es completamente reactivo (realmente, y funciona bajo streams), una vez que los elementos son llenados, todos los widgets que usen esa variable se actualizarán automáticamente en la vista. Esto permite a las personas con experiencia en la interfaz de usuario trabajar sólo con widgets, y no tiene que enviar nada a la lógica de negocio aparte de los eventos del usuario (como hacer clic en un botón), mientras que la gente que trabaja con la lógica de negocios será libre de crear y probar la lógica de negocio por separado.

Esta biblioteca siempre se actualizará e implementará nuevas características. Siéntase libre de ofrecer PRs y contribuir a ellos.
