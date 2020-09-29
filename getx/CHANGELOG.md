## [3.11.1]
- Fix docs

## [3.11.0]
- Refactor structure from scratch to split GetX completely into separate packages. When using the main package (get) you will have everything working perfectly together. However, if you only want one of the resources, you can use the packages separately. 
- Improve Rx types 
- Added RTL support
- Added GetTests, a set of tools to help you create unit tests using Getx
- RAM consumption improved by dividing resources into smaller components, preventing related classes that are unnecessary from being loaded
- Fix example app (missing activity) (@Grohden)
- Added Get.create() lifecycle (@roipeker)
- Added section Contribution videos and articles in Readme (@stefandevo)
- fix isNullOrBlank extension
- Added all operators overload (@grohden)
- Fixes subscription for Rx::bindStream (@roipeker)
- Added Ability to use tags with GetX widgets (@na2axl)
- Change Arguments from Object to dynamic (@roipeker)
- Added Persistent bottomsheet (@mohak852)
- Improve extensions tests (@Nipodemos)
- Refactor Route Observer (@grohden)
- Added print extensions (@unacorbatanegra)
- Update PT-br Readme (@eduardoflorence)
- Fix analyzer crash (@eduardoflorence)
- Fix for switch types usages in GetUtils (@grohden)
- Improvement: RxList, RxSet and RxMap null check in the constructor (@Hitsu91)
- Improve readme example (@dafinoer)

## [3.10.2]
- Fixed the use of tags with lazyPut and added Ability to overwrite "tag" in GetView and GetWidget.

## [3.10.1]
- Fix analyzer

## [3.10.0]
Getx 3.10 released with CLI and Get Server.
- Added: analyser + effective dart (@Grohden)
- Added TextStyle to generalDialog title and message (@roipeker)
- renamed and added defaults transition duration and types in "GetInterface" (@roipeker)
- added missing parameters in Get.to/Get.offAll (@roipeker)
- added optional transitionDuration and transitionCurve to Get.dialog() (@roipeker)
- Changed HashMap<int,GetStateUpdate> to HashSet<GetStateUpdate> and allow update IDs groups on GetBuilder (@roipeker)
- Added a internal VoidCallback in GetStateUpdaterMixin::getUpdate (@roipeker)
- Added Curve property to routes (@roipeker)
- Improve docs, code cleanup, new GetStateUpdaterMixin and GetStateUpdate in favour of StateSetter on GetxController, GetBuilder, SimpleBuilder. (@roipeker)
- Added RxBool.toggle() as an easy shortcut for switching true/false values. (@roipeker)
- Added _RxImp.nil() to easily set the value to null (@roipeker)
- Added missing docs to Rx classes. (@roipeker)
- Added Get.delete(force:false) to Get extensions (@roipeker)
- Added Docs and comments (@nipodemos)
- Added docs to PT-br and fix typos (@eduardoflorence)
- Cleanup route code (@justkawal)
- Extension to facilitate insert widgets inside a CustomScrollView (@alexkharech)
- Fix docs .obs examples (@kai-oswald)
- Added tag capability to GetView 
- Improve code separation of RouteManagement and Internacionalization

## [3.8.0]
- Added: Snackbar Status: Open, Opening, Closing and Closed
example:
```dart
 Get.snackbar('title', 'message', snackbarStatus: (status) {
                  if (status == SnackbarStatus.CLOSED) {
                    // made anything
                  }
                });
```

## [3.7.0]
- Added: RxSet. Sets can now also be reactive.
- Added isDesktop/isMobile (@roipeker) 
- Improve GetPlatform: It is now possible to know which device the user is using if GetPlatform.isWeb is true.
context.responsiveValue used device orientation based on web and non-web applications. Now it checks if it is a desktop application (web or desktop application) to do the responsiveness calculation. (@roipeker) 
- Change: The documentation previously stated that Iterables should not access the ".value" property.
However, many users did not pay attention to this fact, and ended up generating unnecessary issues and bugs in their application.
In this version, we focus on code security. Now ".value" is protected, so it cannot be accessed externally by Lists, Maps or Sets.
- Change: Observable lists are now Dart Lists.
There is no difference in your use:
`RxList list = [].obs;`
And you use
`List list = [].obs;`
- Change: You do not need to access the ".value" property of primitives.
For Strings you need interpolation.
For num, int, double, you will have the normal operators, and use it as dart types.
This way, `.value` can be used exclusively in ModelClasses.
Example:

```dart
var name = "Jonny" .obs;
// usage:
Text ("$name");

var count = 0.obs;
// usage:
increment() => count ++;
Text("$count");
```

Thus: List, Map, Set, num, int, double and String, as of this release, will no longer use the .value property.

NOTE:
The changes were not break changes, however, you may have missed the details of the documentation, so if you faced the message: "The member 'value' can only be used within instance members of subclasses of 'rx_list.dart' "you just need to remove the" .value "property from your list, and everything will work as planned.
The same goes for Maps and Sets.

## [3.6.2]
- Fix more formatting issues

## [3.6.1]
- Fix formatting issues

## [3.6.0]
- Added RxSet
- Change default logger to developer.log (@jorgegaticav)
- Added BindingsBuilder, ValueBuilder, and ObxValue (@roipeker) 
- Fix fallback locale not working if missing country code (@thaihuynhxyz)
- Fix validation of email ".com.br"

## [3.5.1]
- Remove unnecessary whitespaces

## [3.5.0]
- Added logwritter (@stefandevo)
- Added responsiveValue (@juanjoseleca)
- Fixed ghost url for snackbar, bottomsheets, and dialogs and unnamed navigation.

## [3.4.6]
- Fix TextField dispose throw on last Flutter hotfix

## [3.4.5]
- Fix typo on RxList.remove that could cause type errors.
- Remove initialization console print

## [3.4.4]
- Fix exception 'isInit called null' when tags are used in conjunction with dependencies. (@djade007) 
- Fix typos (@tiagocpeixoto)

## [3.4.3]
- Fix onInit fired only first time 
- Fix language callback(@lundin)
- Fix docs (@nipodemos)

## [3.4.2]
- Fix individual imports

## [3.4.1]
- Structure organization, and improvements.

## [3.4.0]
- Added '[everAll]' Worker: Listen a List of '.obx'
- Added Workers dispose
- Fix transition.noTransition
- Fix TextField and VideoPlayController dispose before transition animation

## [3.3.0]
- Fix extensions (@stefandevo)
- Added CPF to utils options (@kauemurakami)
- Added fenix mode to Get.lazyPut. 
Use `Get.lazyPut<Controller>(()=> Controller(), fenix:true)` to have a controller that after being destroyed, has the ability to be recreated in case someone needs it. This is a function that already exists in smartManagement.keepFactory which is now also possible in full mode.
- Fix native transition on android

## [3.2.2]
- Improve transitions and refactor route system

## [3.2.1]
- Prevent black blackground on cupertino fullscreenDialog

## [3.2.0]
- Improve GetBuilder ram usage
- Added method update to Rx 
Now you no longer need to make an entire class reactive to get an element update from it, you can simply call the update method of its instance, like this:
```dart
class User{
  User(this.name = '', this.age = 0);
  String name; 
  int age;
}

final user = User().obs;

Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))

// To update:
user.update((user){
user.name = 'Jonny';
user.age = 18;
});
```

Now is also possible to access a value without using the ".value". Just open and close parentheses.
In the previous example, you could do:
```dart
user().name; // before: user.value.name
```
And it is also possible to set a value without using the value, inserting the value directly into the variable.
```dart
user(User('João', 35)); // before: user.value = User('João', 35)
```
Added fenix mode to Get.lazyPut.


## [3.1.4]
- Update readme banner

## [3.1.3]
- Activate unknownRoute on version 3
- Go back transitions.size and transitions.cupertino

## [3.1.2]
- Expose GetInstance

## [3.1.1]
- Improvement .obs methods

## [3.1.0]
- Added extensions to GetUtils and fix typo on GetUtils.isEmail (@stefandevo)
- Added .gitignore file (@hdeyana)

## [3.0.1]
- Breaking changes on Rx api and GetController and RxController were merged, and now you only have the 'GetxController'
- Refactor routing system. Now you can add custom transitions and more
- Improved the use of dynamic routes, you can now define two different pages according to your arguments.
- Added GetView widget
- Added internacionalization
- Added validations
- Added Get queqe
- Added GetStorage (with separated package)
- Minor bug fixes.


## [2.14.0]
- Added getPages API. 
- Deprecated namedPages
- Fix default transition 
- Added Duration on Get.offAll(@kluverua)

## [2.13.1]
- Added sort to ListX
- Prepared the framework for version 3

## [2.13.0]
- Added Get.focusScope

## [2.13.0]
- Update docs
- Fix Bindings list on GetPageRoute

## [2.12.5]
- Update readme

## [2.12.4]
- Prevent exceptions on onReady with nullables

## [2.12.3]
- Fix List lenght == null 

## [2.12.2]
- Fix Workers

## [2.12.1]
- Added: onReady on Controllers LifeCycle
- Added: Observable maps
- Refactor: observable variables that now consume even less RAM.

## [2.11.3]
- Type parameters and added docs

## [2.11.2]
- Added docs
- Improvement performance of Obx

## [2.11.1]
- Fixed: oninit calling only once.

## [2.11.0]
- Added Permissions:
You can now revoke permissions to SmartManagement so that it cannot delete a particular controller.
Add to Get.put (Controller(), permanent: true); to make it indelible.
Get.lazyPut() will not receive this resource. Initially he had it, but we saw in internal tests that it could cause problems with the bindings API. Bindings were created to initialize and delete an instance, if it were allowed to make a controller started with lazyPut permanent, copies of that Controller would be created every time Binding was called. For the safety of users, especially new users who could easily do this, it was decided that this feature will only be present in Get.put.
- Improve: Now a controller's life cycle has no connection with the View life cycle. It is no longer called internally in an "initState", it is now called when the Controller enters memory. This means that now onInit will always be called, regardless of where you started your dependency.
- removed: this property of the update() method has been permanently removed.

## [2.10.3]
- GetBuilder refactor. 11% reduction in RAM consumption and 2% in CPU consumption for the sample application. (using as base Flutter for linux desktop).

- The "this" property of the "update" method has been deprecated and will be removed in the next update. Please don't use it anymore. Just use "update()" now.

## [2.10.2]
- Fix Get.generalDialog default options

## [2.10.1]
- Fix broken links on pub
- Fix List empty error

## [2.10.0]
- Added SmartManagement, your application's memory is managed intelligently like never before!
- Added Obx, a widget that knows when to rebuild a child, without needing any type.
- Added MixinBuilder - If you need to use GetBuilder in conjunction with GetX, use GetxController with this widget, and the changes will occur either using update (this) or changing some reactive variable. Use only if necessary, for better RAM consumption, prefer widgets in that order:
Obx => GetX => GetBuilder => MixinBuilder.
Obx is the lightest of all, and MixinBuilder is a mix of the other 3, whenever possible, use the specific widget.
- Refactor: StateManager of Get.
- Changed: full List API refactor, now value is no longer needed.
- Added Workers: You can hear changes to a variable and trigger custom callbacks.
- Added Bindings API docs.
- Added Portuguese language to readme(@Nipodemos)

# [2.7.1]
- Improve list to set and get methods

## [2.7.0]
- Added obx, a simple state interceptor. 
- Improve Bindings, ListX, and 
- fix docs typos e broken code (@ghprod)


## [2.6.3]
- Flutter currently has a problem on some devices where using showModalBottomSheet() can cause TextFields to be hidden behind the keyboard (https://github.com/flutter/flutter/issues/18564) this issue is closed, even users reporting that the problem still occurs.
The problem happens casually, as well as the problem of the snackbar on the iPhone SE 2, and checking the code, I realized that a padding with MediaQuery.of(context).viewInsets.bottom is missing inside the bottomSheet to make it work correctly, since it does not have any constraint with the keyboard.
For stability, I decided not to use the standard Flutter bottomSheet, which contains many bugs, mainly related to keyboard padding, and the lack of respect for topBar's safeArea, and to use a proprietary bottomSheet implementation that is more stable. The Flutter dialog has no problem, so it will be used as the basis for Get.dialog. The bottomSheet will be based on the Flutter bottomSheet Raw API (_ModalBottomSheetRoute), applying bug fixes.
- Added Get.isSnackbarOpen tests

## [2.6.2]
- Refactor Bindings API

## [2.6.1]
- Expose Bindings API

## [2.6.0]
- Added bindings.
You can now add bindings from your controllers to your routes, to prepare GetBuilder or GetX to create a dependency already declared in a Binding class. This feature is in an experimental phase, and will not be documented until the end of the tests.

## [2.5.10]
- Removed remnants of previousArgs on routeObserver.
This feature had been deprecated in previous updates, and was removed in version 2.5.8. Some remaining references on the routeObserver were causing exceptions in version 2.5.9, and were removed completely in version 2.5.10.

## [2.5.9]
- Fix Get.find with named instance

## [2.5.8]
- Added docs
- Added tests(@chimon2000)

## [2.5.7]
- Fix Get.generalDialog optionals
- Added GetX onInit support

## [2.5.6]
- GetBuilder refactor to work with lazyPut.
Now you can list your controllers in advance with Get.lazyPut, and only when it is called for the first time will it be relocated in memory.
- Fix english typos(@gumbarros)

## [2.5.5]
- Fix arguments broken by new methods

## [2.5.4]
- Refactor methods

## [2.5.3]
- Fix snackbar padding on iPhone SE 2.
- Added themes docs
- Added ThemeMode (@RodBr)

## [2.5.2]
- Fix: key not found when Get.key is used with no MaterialApp

## [2.5.1]
- Improve - GetBuilder uses 18% less ram on more of 20 controllers.

## [2.5.0]
- Added List.obs
- Now you can transform any class on obs

## [2.4.0] 
- Added GetX, state manager rxDart based. 
- Fix error on add for non global controllers

## [2.3.2] 
- Fix close method called on not root GetBuilder

## [2.3.1] 
- Auto close stream inside close method
- Added docs

## [2.3.0] 
- Added interface to GetX support

## [2.2.8] 
- Added api to platform brightness

## [2.2.7] 
- Fix typos

## [2.2.6] 
- Fix cancel button on defaultDialog don't appear when widget implementation usage

## [2.2.5] 
- Refator defaultDialog

## [2.2.4] 
- Clean code
- Fix Get.LazyPut

## [2.2.3] 
- Remove defaultDialog type

## [2.2.2] 
- Fix GetRoute not found

## [2.2.1] 
- Improve lazyPut and fix tag to lazyput(@rochadaniel)

## [2.2.0] 
- Added: Ability to choose or delay a widget's state change according to its ID.
- Added: Ability to fire triggers when loading materialApp.
- Added: Ability to change theme dynamically.
- Added: Ability to rebuild the entire app with one command.
- Added: Ability to trigger events on the MaterialApp.
- Added: Get.lazyPut (lazy loading of dependencies).
- Added: Get.creator - a factory of dependencies .
- Added: Capability of define abstract class on dependencies. 

## [2.1.2] 
- Get.defaultDialog refactor

## [2.1.1] 
- fix typo

## [2.1.0] 
- Added Get.rawSnackbar
- Added instantInit config to snackbars
- Refactor Get Instance Manager
- Improved performance and bug fix to Get State Manager 
- Improved performance of GetRoute on namedRoutes
- Hotfix on namedRoutes

## [2.0.10] 
- Bump new Flutter version
- Added Get.generalDialog

## [2.0.6] 
- Fix typo on readme

## [2.0.5] 
- Changing the bottomsheet API to comply with the documentation.

## [2.0.4] 
- Fix type not found in some versions of Flutter stable

## [2.0.3] 
- Update Docs

## [2.0.2] 
- Update GetObserver

## [2.0.1] 
- Fix docs and typos

## [2.0.0] 
- Added easy state manager
- Change dialog API 
- Added GetMaterialApp 
- Added new experimental APIs 
- Improve Observer 
- Added default duration on Transitions 
- Added new routeNamed sistem
- Added Global stateManager config 
- Improve Get instance manager 
- Added routingCallback 
- Added closeOverlays to Get.back 
- Added dynamic urls 
- Cleaner code
- Improve lib performance 
- Many others minor APIs added

## [1.20.1] 
- Improve: Get.finds

## [1.20.0] 
- Added Get Instance Manager
  Get.put / Get.find / Get.delete

## [1.19.1] 
- Fix default transitions for namedRoutes

## [1.19.0] 
- Added nested navigators

## [1.18.0] 
- Added SafeArea to bottomsheets
- Added docs

## [1.17.0] 
- Added experimental APIs


## [1.16.1] 
- Improve: GetObserver

## [1.16.0-dev] 
- Added Get config
- Added logEnable 
- Added Default transition 
- Added default popGesture behaviour 
- Added overlayContext 
- Fix Duration transition

## [1.14.1-dev] 
- Fix ternary on new dart version

## [1.14.0-dev] 
- Added compatibility with Flutter 1.17.1
- Added back popGesture to iOS (default) and Android (optional)
- Improve performance
- Decrease lib size to 94.9kb (25.4k after compiled on release)

## [1.13.1-dev] 
- Fix back function

## [1.13.0-dev] 
- Plugin refactor
- Added GetPlatform

## [1.12.0-dev] 
-Compatibility with Dev branch

## [1.11.4] 
- Refactor code of library

## [1.11.3] 
-Added docs


## [1.11.2] 
 -Fix flutter web platform and added GetPlatform

## [1.11.1] 
 -Improve swipe to back on iOS devices

 ## [1.11.0] 
 -Added experimental GetCupertino

## [1.10.5] 
 -Added setKey to improve modular compatibility
 -Added ability to define transition duration directly when calling the new route.

## [1.10.4] 
 -Improve Get.offAll() - predicate now is optional

## [1.10.3] 
 -Improve default color from dialogs

 ## [1.10.2] 
 -Improve snackbar text color
 -Added background color to snackbar (@claudneysessa)

 ## [1.10.1] 
 -Backdrop improvement

## [1.10.0] 
 -Added backdrop

## [1.9.2] 
 -Added docs to GetObserver

 ## [1.9.1] 
 -Fix typo on snackbar route

## [1.9.0] 
 -Added: Navigator observer 
 -Added: Get.args to named routes 
 -Improve snackbar performance 

## [1.8.1] 
 -Fix new snackbar features

## [1.8.0] 
 -Add Get.close method.
 -Add many Snackbars features

## [1.7.4] 
 -Fix dialog child error

## [1.7.3] 
 -Added transitions docs

## [1.7.2] 
 -Fix bottomsheet on macos

## [1.7.1] 
 -Fix docs

## [1.7.0] 
   
 - Improve geral performance. Get.to Wrap now consumes even less RAM and CPU. In an application with 20 screens, it obtained 82% less RAM usage compared to the traditional method Navigator.push and had a CPU normalization of 23% in a Moto z2, against 64% CPU usage in Navigator.push with MaterialPageRoute. Test it for yourself!
 - Added BottomSheet with no context 
 - Added modern Blur Snackbar
 - Added customs transitions
 - Improve dialogs performance

## [1.6.4] 
   
 - Improve performance. 

## [1.6.3] 
   
 - Clean code. 

## [1.6.2] 
   
 - Fix bugs on blurred Snackbars

## [1.6.1] 
   
 - Add docs and improve performance
 
## [1.6.0] 
   
 - Add support to snackbars

## [1.5.0+1] 
  
 - Add color and opacity to dialogs
 
## [1.5.0] 
  
 - Add support to dialogs

## [1.4.0+7] 
 
 - Add more documentation

## [1.4.0+6] 

- Improve performance and bug fix 

## [1.4.0] 

- Added Get.removeRoute // ability to remove one route. 
        Get.until // back repeatedly until the predicate returns true.
        Get.offUntil // go to next route and remove all the previous routes until the predicate returns true.
        Get.offNamedUntil // go to next named route and remove all the previous routes until the predicate returns true.
        
## [1.3.4] 

- Improve performance

## [1.3.3] 

- Fix Get.back arguments

## [1.3.2] 

- Improve performance

## [1.3.1] 

- Update docs

## [1.3.0] 

- Update docs, readme, and add full support to flutter_web

## [1.2.1] 

- Fix bug currentState = null


## [1.2.0] 

- Add routes navigation with no context

## [1.1.0] 

- Add support to named routes 

## [1.0.3] 

- Improve Performance

## [1.0.2] 

- Add examples

## [1.0.1] 

- Doc changes

## [1.0.0] 

- initial release
