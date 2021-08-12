## [4.3.7] 
- Fix wrong currentRoute when a route is removed
- Remove take that limits the router outlet depth (@steven-spiel)

## [4.3.6] 
- Fix error with autodispose of additional dependencies beyond GetxController
- Added ability to add your own delegate to RouterOutlet (@steven-spiel)
- Added listenAndPump to Rx to give Rx the same behavior as BehaviorSubject (@steven-spiel)

## [4.3.5] 
- Fix GetConnect timeout (@jasonlaw)
- Improve Vietnamese docs (@hp1909)
- Refactor placeholder name route to unnamed routes (@roipeker).
- Fix: Navigate to a page identical to Get.offNamed.
- Fix: Wrong nameRoute after a route is removed
- Added assert to prevent the user from starting a route name without slash.

## [4.3.4] 
- Improve docs

## [4.3.3] 
- Fix Get.reset

## [4.3.2] 
- Fix nullable on internacionalization (@jmguillens)
- Fix nullable on Rx.stream (@steven-spiel)

## [4.3.1] 
- Fix controller is not removed when keyboard is open.
- Improved: Safe removal and insertion of controllers.

## [4.3.0] 
- Added GetResponsiveWidget (@ahmednfwela)
- Added `Get.replace()` (@jwelmac)
- Added Improve korean doc (@sejun2)
- Fix multiple middlewares redirect (@liasica)
- Added gestureWidth and showCupertinoParallax to GetPage to customize cupertino transitions

## [4.2.5] 
- Added anchorRoute and filterPages to GetRouterOutlet (@ahmednfwela)
- Added scrollBehavior and scaffoldMessengerKey to GetMaterialapp(@ejabu and @alionour)
- Fix error when child on MaterialApp is null (@ahmednfwela)
- Fix Korean docs (@rws08)
- Fix error with onClose called before routeTransition on Get.offNamed

## [4.2.4] 
- Fix Get.offAll removing GetxServices from memory

## [4.2.3] 
- Fix back button on navigator 2
- Added parameters and arguments to Get.rootDelegate 

## [4.2.1] 
- Remove [] from docs to try fix pub score

## [4.2.0] - Big update

This update fixes important bugs as well as integrates with Navigator 2. It also adds GetRouterOutlet, similar to angular RouterOutlet thanks to @ahmednfwela. Also, the documentation translation for Vietnamese (@khangahs) has been added, making the GetX documentation available for 11 different languages, which is just fantastic for any opensource project. GetX has achieved more than 5.4k likes from the pub, and more than 4k stars on github, has videos about it with 48k on youtube, and has communities in the 4 hemispheres of the earth, besides having a large list of contributors as you see bellow. We're all happy to facilitate development with dart and flutter, and that making programming hassle-free has been taken around the world.

Changes in this version:

- Fix: Navigating to the same page with Get.offNamed does not delete the controller from that page using Get.lazyPut.

- Fix Readme GetMiddleware typos 
by @nivisi

- Fix url replace error
by @KevinZhang19870314 

- Changed response default encoding from latin1 to utf8 
by @heftekharm

- Add Duration in ExtensionBottomSheet
by @chanonpingpong

- Added compatibility with dart-lang/mockito
by @lifez

- Added extensions methods to convert value in percent value 
by @kauemurakami

- Set darkTheme equal theme when darkTheme is null 
by @eduardoFlorence

- Add padding to 'defaultDialog' 
by @KevinZhang19870314

- GraphQLResponse inherit Response info 
by @jasonlaw

- Fix Redundant concatenating base url 
by @jasonlaw

- Add content type and length into the headers when the content type is 'application/x-www-form-urlencoded'
by @calvingit

- Make withCredentials configurable 
by @jasonlaw

- Fix flutter 2.0 error
by @yunchiri

- Allow deleting all registered instances
by @lemps

- Refactor/rx interface notify children 
@by kranfix

- Fixed parameter parsing and middleware sorting 
by @ahmednfwela

- Improvements to router outlet 
by @ahmednfwela

- Minor improvements and bug fixes 
by @ahmednfwela

- Adding route guards and improving navigation 
by @ahmednfwela

- Fix RxInterface.proxy losing its previous value on exception
by @WillowWisp

- Added dispose() for bottomSheet.
by @furkankurt 

- Added Pull request template 
by @unacorbatanegra

- Fix and update documentation:
@Farid566, 
@galaxykhh, 
@arslee07, 
@GoStaRoff, 
@BondarenkoArtur, 
@denisrudnei,
@Charly6596, 
@nateshmbhat, 
@hrithikrtiwari, 
@Undeadlol1,
@rws08,
@inuyashaaa,
@broccolism, 
@aadarshadhakalg,
@ZeroMinJeon


## [4.1.4] 
- Adjust operator + and - to RxInt (@eduardoflorence)
- Fix dark theme (@eduardoflorence)
- Fix form-urlencoded on GetConnect (@aramayyes)


## [4.1.3] 
- Fix "Error: A value of type 'Locale?' can't be returned from a function"on flutter web (@nickwri)
- Fix plural translations to expressions >1 (@WolfVic)

## [4.1.2] 
- Fix warning ˜can add data to a closed stream˜ when GetBuilder and Obx are nested
- Fix get_connect decoder can not be null (@Goddchen)
- Migrate example code (@3lB4rt0)
- Fix initial value of nullables (@RafaRuiz)
- Improve error message to navigation (@maxzod)
- Fix typo on docs (@Rahulshahare)
- Fixed darktheme being changed only through Get.changeTheme and not through the DarkTheme theme property in MaterialApp (@GoldenSoju)
- Fix controller is removed when navigate to same page (@eduardoflorence)
- Fix missing reload() and reloadAll() to Get extensions (@lkloon123)


## [4.1.1] 
- Remove mandatory initialValue to nullables types

## [4.1.0] 
- Added Rxn to non nullables reactives types

## [4.0.3] 
- Added new linter rules to improve score

## [4.0.2] 
- Removed "!" of if else conditions until the null-safety of the dart is consistent for using it.

## [4.0.1] 
- Fix changelog

## [4.0.0] 
- Added append function to StateMixin. Now is possible track loading, success and error handle of your application with ONE LINE OF CODE. Ex: append(()=> api.getUser);
- Migrate to null-safety 
- Added ScrollMixin to controllers
- Added loadingMore status to RxStatus
- Fix content-type qual null (@katekko)
- Made GetInstance non nullable (@eduardoflorence)
- Fix multi-parameters url (@iMrLopez)
- Fix Expected value of SkDeletable error (@obadajasm)
- Added triggers, an Rx method that triggers events, even if they are the same as the previous event (@RafaRuiz)
- Improve docs: (@CNAD666), (@dhhAndroid), (@Jackylee1992),

Switching to null-safety:
You can continue using GetX as normal, with as little breaking changes as possible.
It is still possible to declare the var.obs variable, and this remains the preferred way, forcing null-safety and giving you all the security that sound null-safety delivers to your app. However, if you need to use null, we also provide a solution for you.
Declare the variables with `?` Ex: `final Rx<int?> count = 0.obs`.
You can also use custom Rxn types with null-safety:
`RxInt` == not nullable
`RxnInt` == nullable.

## [3.25.6] 
- Added documentation in French (@kamazoun)
- Fix logs messages (@damphat)
- Fix plural to zero on internacionalization (@RafaRuiz)
- Fix error when body hasn't content on GetConnect (@jasonlaw)
- Fix typos on readme (@bashleigh)
- Fix group updates to GetBuilder

## [3.25.5] 
- Fix Get.isDialogOpen when two or more open dialogs are closed

## [3.25.4] 
- Added logs and tests to unknownRoute

## [3.25.3] 
- Fix bindStream error 'Object.noSuchMethod'.

## [3.25.2] 
- Improved Workers system to accept a list of works

## [3.25.1] 
- Improved the log system to display the tag used in the controller that was created.

## [3.25.0] - Big update
- Added [reload] and [reloadAll] methods to reload your Controller to original values
- Added [FullLifeCycleController] - A GetxController capable of observing all the life cycles of your application. FullLifeCycleController has the life cycles:
  * onInit: called when the controller enters the application's memory
  * onReady: called after onInit, when build method from widget relationed to controller is done.
  * onClose: called when controller is deleted from memory. 
  * onPaused: called when the application is not currently visible to the user, and running in the background.
  * onInactive: called when the application is in an inactive state and is not receiving user input, when the user receives a call, for example
  * onResumed: The application is now visible and in the foreground
  * onDetached: The application is still hosted on a flutter engine but is detached from any host views.
  * didChangeMetrics: called when the window size is changed
- Added SuperController, a complete life circle controller with StateMixin 
- Improve Iterable Rx Api. Now, you can to use dart List, Map and Set as reactive, like: List<String> names = <String>['juan', 'pedro', 'maria'].obs;
- Added assign and assignAll extensions to default dart List
- Added parameters options from Get.toNamed, Get.offNamed, and Get.offAllNamed (@enghitalo)
- Improve Rx disposal logic to completely prevent memory leaks
- Improve Capitalize methods from GetUtils (@eduardoflorence)
- Prevent a close snackbar from close a Screen with double tap (@eduardoflorence)
- Includes GetLifeCycleBase mixin on delete/dispose (@saviogrossi)
- Added internacionalization example to sample app (@rodriguesJeff)
- Added headers to Graphql query and mutation(@asalvi0)
- Added translation with parameter extension (@CpdnCristiano)
- Added Get.parameter access to Middleware (@eduardoflorence)
- Fix RxBool typo (@emanuelmutschlechner)
- Added Filter to GetBuilder
- Added debouce to GetBuilder update 
- Added ability to insert an Enum, class, or type of an object as a GetBuilder's Id
- Improve upload time from GetConnect
- Create minified version to DartPad(@roipeker)
- Suggested to use `Get.to(() => Page())` instead of `Get.to(Page())`.
- Added more status codes to GetConnect (@romavic)
- Fix and improve docs: @unacorbatanegra, @lsm, @nivisi, @ThinkDigitalSoftware, @martwozniak, @UsamaElgendy, @@DominusKelvin, @jintak0401, @goondeal


## [3.24.0]
- GetWidget has been completely redesigned.
Throughout its lifetime, GetWidget has always been mentioned in the documentation as "something you shouldn't use unless you're sure you need it", and it had a very small use case. A short time ago we realized that it could have some unexpected behaviors, when compared to GetView, so we decided to rebuild it from scratch, creating a really useful widget for the ecosystem.
Objectively, GetWidget is now a Widget that caches the controller and protects children from their parents' reconstructions. This means that if you have a ListView or gridview, you can add items to it without the child (being a GetWidget) being rebuilt. The api is now more concise, as you can use Get.put / Get.lazyput for global dependencies, and Get.create with GetWidget for ephemeral dependencies, or when you need several identical controllers for the same widget, eliminating the need for tags for most cases.

- Workers now have error handlers, so if an error occurs in your stream, you can recover it from your workers.

- `isTrue` and `isFalse` setters were added to [RxBool], this will make the code more readable, and will mitigate the use of ".value" in Booleans.

- [Patch] method was added in GetConnect.

- Native methods for RxString (trim, contains, startWith, etc.) have been added.
   
- Standard constructors for RxList and RxMap have been added (RxList.generate, RxList.from, Map.of, Map.from, etc).

- Added "onEmpty" status in StateMixin (@alizera)

- Added query and mutation methods of graphql for getconnect.
  
- Added body string for content-type application/x-www-form-urlencoded on GetConnect (@eduardoflorence)

## [3.23.1]
- Fix allowSelfSigned on Flutter web
  
## [3.23.0]
- Add GetResponsive (@SchabanBo)
- Update tests, fix predicate for offNamedUntil (@vbuberen)
- Added Urdu Version for Pakistani Developers (@UsamaSarwar)
- Handle for List field with native datatype on GetConnect(@jasonlaw)
- Added WillPopScope to defaultDialog (@rakeshlanjewar)
- Fix optional query params not attach on createUri from GetConnect (@reinaldowebdev)
- Effective Get.testMode from navigator on tests (@eduardoflorence)
- Fix Navigator 2.0 on GetMaterialApp and CupertinoMaterialApp (@SchabanBo)
- Added Middlewares with initial Routes (@SchabanBo)
- Improve PT-br Docs (@eduardoflorence)
- Added the allowSelfSigned parameter to GetSocket(@eduardoflorence)
- Added Indonesian version to Indonesian Developers (@pratamatama)

## [3.22.2]
- Fix overlayEntries is null on Master/Dev branch of Flutter

## [3.22.1]
- Improve: auto jsonDecode occurs only if response.header.contentType is "application/json"
- Improve and fix requests types (@eduardoflorence)
- Fix HeaderValue variables with same name (@haidang93)


## [3.22.0]
- Added: more multipart options. Now you can send as multipart: 
  
File:
'file':MultipartFile(File('./images/avatar.png'), filename: 'avatar.png'),

String path:
'file':MultipartFile('./images/avatar.png', filename: 'avatar.png'),

Or bytes (Flutter web work only with bytes):
'file':MultipartFile(File('file').readAsBytesSync(), filename: 'avatar.png'),

- Added: Upload Progress to MultipartRequest
- Added support to List<MultipartFile> (@jasonlaw)


## [3.21.3] 
- Improve multipart file and defaultDecoder on GetConnect

## [3.21.2] 
- Fix GetConnect.request returning a PUT request

## [3.21.1] 
- Allow null body to POST method on GetConnect

## [3.21.0] - Big update
- This update attaches two nice features developed by (@SchabanBo): *GetPage Children* And *GetMiddleware*
In previous versions, to create child pages, you should do something like:

```dart
GetPage(
  name: '/home',
  page: () => HomeView(),
  binding: HomeBinding(),
),
GetPage(
  name: '/home/products',
  page: () => ProductsView(),
  binding: ProductsBinding(),
),
GetPage(
  name: '/home/products/electronics',
  page: () => ElectronicsView(),
  binding: ElectronicsBinding(),
),
```
Although the feature works well, it could be improved in several ways:
1- If you had many pages, the page file could become huge and difficult to read. Besides, it was difficult to know which page was the daughter of which module.
2- It was not possible to delegate the function of naming routes to a subroutine file.
With this update, it is possible to create a declarative structure, very similar to the Flutter widget tree for your route, which might look like this:
```dart
GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
            name: '/products',
            page: () => ProductsView(),
            binding: ProductsBinding(),
            children: [
              GetPage(
                 name: '/electronics',
                 page: () => ElectronicsView(),
                 binding: ElectronicsBinding(),
              ),
            ],
          ),
      ], 
  );
```
Thus, when accessing the url: '/home/products/electronics'
Or use Get.toNamed('/home/products/electronics') it will go directly to the page [ElectronicsView], because the child pages, automatically inherit the name of the ancestral page, so _with any small change on any father in the tree all children will be updated._ If you change [/products] to [/accessories], you don't nesse update on all child links. 

However, the most powerful feature of this version is *GetMiddlewares*.
The GetPage has now new property that takes a list of GetMiddleWare than can perform actions and run them in the specific order.

### Priority

The Order of the Middlewares to run can pe set by the priority in the GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```
those middlewares will be run in this order **-8 => 2 => 4 => 5**

### Redirect

This function will be called when the page of the called route is being searched for. It takes RouteSettings as a result to redirect to. Or give it null and there will be no redirecting.

```dart
GetPage redirect( ) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

This function will be called right before the Bindings are initialize.
Here you can change Bindings for this page.

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### OnPageBuildStart

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

### OnPageDispose

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

## [3.20.1] 
* Fix wrong reference with unnamed routes and added more tests

## [3.20.0] - Big update
* Added GetConnect. 
- GetConnect is an easy way to communicate from your back to your front. With it you can:
- Communicate through websockets
- Send messages and events via websockets.
- Listen to messages and events via websockets.
- Make http requests (GET, PUT, POST, DELETE).
- Add request modifiers (like attaching a token to each request made).
- Add answer modifiers (how to change a value field whenever the answer arrives)
- Add an authenticator, if the answer is 401, you can configure the renewal of your JWT, for example, and then it will again make the http request.
- Set the number of attempts for the authenticator
- Define a baseUrl for all requests
- Define a standard encoder for your Model.
- Note1: You will never need to use jsonEncoder. It will always be called automatically with each request. If you define an encoder for your model, it will return the instance of your model class ALREADY FILLED with server data.
- Note2: all requests are safety, you do not need to insert try / catch in requests. It will always return a response. In case of an error code, Response.hasError will return true. The error code will always be returned, unless the error was a connection error, which will be returned Response.hasError, but with error code null.
- These are relatively new features, and also inserted in separate containers. You don't have to use it if you don't want to. As it is relatively new, some functions, such as specific http methods, may be missing.
* Translation to Korean (@rws08)
* Fix Overlays state (@eduardoflorence)
* Update chinese docs (@jonahzheng)
* Added context.isDarkMode to context extensions
  

## [3.17.1]
- Allow list.assignAll, map.assignAll and set.assignAll operate with null values

## [3.17.0]
- Added GetCupertinoApp
- Added initial suport to navigator 2.0 

## [3.16.2]
- Clean RxList, RxMap and RxSet implementation
- Now when declaring an `RxList()`, it will be started empty. If you want to start a null RxList, you must use `RxList(null)`.
Improved GetStream to receive the same parameters as the StreamController, such as  `onListen`, `onPause`, `onResume` and `onCancel`.
- Improve docs

## [3.16.1]
- Fix compilation error on master
  
## [3.16.0]
- Documentation translated into Russian language. (@Renat Fakhrutdinov, @Doaxan and @BatttA)
- Added error message callback for StateMixin (@eduardoflorence)
- Fix incorrect Get.reference when pop route (@4mb1t) 
- Added Uppercase/Capital letter on GetUtils (@AleFachini)
- Redraw the Streams api to use GetStream instead of StreamControllers. Why this change? 
Dart provides a Streams API that is really rich. However, asynchronous streams add extra latency to ensure that events are delivered in the exact order.
It is not yet known whether this latency has any performance impact in mobile applications, and probably not, however, as GetX is also a server-side framework, we need to have the lowest latency at all, since our base is shared.
Dart also has a Synchronous Streams api that has very low latency, however, it is not suitable for use in state management for two reasons:
1- Synchronous Streams can only have one listen (see the issue opened by Hixie on dart lang for reference: https://github.com/dart-lang/sdk/issues/22240).
This means that we cannot use this api for more than one listener, which is the basis of global state management, where we aim to change the state of more than one location. You can test this with this simple snippet:

```dart
void main() {
  var controller = StreamController(sync: true);
  var stream = controller.stream;
  stream.listen((data) {
    print('$data');
    if (data == 'test4') controller.add('test5');
  });

  print('test1');
  controller.add('test2');
  stream.listen((event) {}); // second listen throws a exception
  print('test3');
  controller.add('test4');
  print('test6');
  controller.add('test7');
  print("test8");
}
```
2- Even with a single listener, the dart's Synchronous Streams api cannot deliver events in the exact order. We plan to work on a PR in the future at dart-lang to address this. So if we remove the line above that causes the exception, we will have the following output in the log:

```dart
void main() {
  var controller = StreamController(sync: true);
  var stream = controller.stream;
  stream.listen((data) {
    print('$data');
    if (data == 'test4') controller.add('test5');
  });

  print('test1');
  controller.add('test2');
  // stream.listen((event) {}); // second listen throws a exception
  print('test3');
  controller.add('test4');
  print('test6');
  controller.add('test7');
  print("test8");
}
///////////////////// log:
test1
test2
test3
test4
test6
test8
test5

```
As we can see, test 4 skips to test 6, which skips to test 8, which skips to test 5. Note that test 7 didn't even appear in the log.

However, if we work with GetStream, everything works as expected:
```dart
void main() {
  var controller = GetStream();
  var stream = controller.stream;
  stream.listen((data) {
    print('$data');
    if (data == 'test4') controller.add('test5');
  });

  print('test1');
  controller.add('test2');
  // stream.listen((event) {}); // second listen throws a exception
  print('test3');
  controller.add('test4');
  print('test6');
  controller.add('test7');
  print("test8");
}
///////////////////// log:
test1
test2
test3
test4
test5
test6
test7
test8

```

The dart documentation is clear that this api should be used with caution, and in view of these tests, we were sure that it is not stable enough to be used as the core of our state management, nor of the websockets notifications and get_server requests.

Clarification about the controversy over benchmarks:
In a version prior to changeLog, we talked about the 9000% difference in performance between Streams, and GetStreams that ended up causing a lot of controversy in the community.
Initially, we would like to clarify that this does not mean that you will have mobile applications 9000% faster. Only that one of our main resources, showed itself with a high rate of requests, 9000% faster than using traditional streams. In a real world scenario, you will hardly have so many simultaneous requests.
Skia renders frames on new devices at up to 120fps. This means that if you have a 10 second animation, you will have 1200 reconstructions. Unless you are working with animations, or something that requires rendering at the skia boundary, you won't need that much power. So this does not mean that we are revolutionizing the mobile world, only that we have created an alternative to Stream Sincronas, which works as expected, and which has satisfactory performance for low latency resources. The benchmarks are real, but that does not mean that you will have mobile applications 9000% faster, but that you have a new feature that performs at this level to use.
For reference only, the benchmark can be found ([HERE](https://github.com/jonataslaw/getx/blob/master/test/benchmarks/benckmark_test.dart))

In short: asynchronous streams from dart work perfectly, but add a latency that we want to remove on Get_server.
Synchronous dart streams have unexpected behaviors, cannot have more than 1 listener and do not deliver events in the correct order, which completely prevents their use in mobile state managements, since you run the risk of displaying data on the wrong screen, since the last event will not always be the last event entered by the sink.
The 9000% figures are real, however, they refer to the gross performance between Streams and GetStreams. This does not mean that this number will impact your applications, because you are unlikely to use all of that power.


## [3.15.0]	- Big update
- **Improve Performance**: We made modifications to make GetBuilder even faster. We have improved the structure behind it so that listeners are notified faster. Perhaps in version 4.0 everything will be based on this new structure, but maintaining the power and compatibility with streams. If you want to know how much Getx is faster than pure streams or ChangeNotifier (even after the last update using LinkedList), you can create run the repository tests at: (https://github.com/jonataslaw/getx/blob/master/test/benchmarks/benckmark_test.dart)
- **Added StateMixin**
StateMixin allows you to change the state of the controller, and display a loading, an error message, or a widget you want with 0 boilerplate. This makes things like API/Rest communication or websocket absurdly simple, and it's a real revolution in how state management has behaved so far.
You no longer need to have a ternary in your code, and you don't need a widget like FutureBuilder, StreamBuilder or even Obx/GetBuilder to encompass your Visibility. This will change with the way you manage the state of your controllers, decrease your boilerplate absurdly, and give you more security in your code.
- **Added GetNotifier**
GetNotifier is a super and powerful ValueNotifier, which in addition to having the life cycle of the controllers, is extremely fast, and can manage a single state, as a simplified immutable state management solution.
In theory, the only difference between it and GetxController is the possibility of setting an initial value in the constructor's super (exactly as ValueNotifier does). If the initial value is null, use GetxController. If you need a starting value, GetNotifier can be more useful and have less boilerplate, but both serve the same purpose: to decouple your visualization layer from your presentation logic.
- Other Fixes and improvements:
  - Fixed GetxController is closed twice when smartManagement.full is turn on
  - Fixed phone number validation
  - Fixed some inconsistencies in GetWidget and the life cycle of controllers
  - It made controller testing completely safe with navigation.
  - Improve docs (@eduardoflorence)
  - Improve security types on routes (@unacorbatanegra)
  - Improve code structure with less duplicate code: (@kranfix)
  - Fix named route erroring when route does not exist (@FiercestT)

## [3.13.2]	
- Reunification of the package.
During the 2 week period, we try to keep this package as a compilation of smaller packages. We were successful in separating, getx is well decoupled and it was only necessary to send the internal folders as packages to pub.dev, however, it became very complicated to contribute to the package. This is because it was necessary to clone the repository, replace all pubspec packages with local paths, and after modification, return the original paths to do the PR. With that, the frequency of updates, which was about 4 to 5 days, became almost 2 weeks, and this is not legal for a community as active as Getx, which uses this package precisely in addition to being modern and performance, be constantly improving. This led contributors to the conclusion that getx works best together.
Additional packages will continue to be maintained, and will have the same base as the main package, however, development will take place in the full and main package, and as the addition of new features or bug fixes arrives, we will migrate to the individual packages . Getx reached the mark of 50 contributors today, more than 1500 likes in the pub, and will continue to make development easy.
  
## [3.13.1]	
- Remove spaces whitespaces from dart files	
- 
## [3.13.0]
- Fix typos on code and docs (@wbemanuel and @Goddchen)
- Improve: typedef to GetBuilder and Getx widgets
- Improve behaviour of null route on lastest flutter version (@FiercestT)
- Fix onReady called twice on smartManagement.onlyBuilders
- Fix onClose called twice when GetBuilder is used
- Fix default customTransitions, and defaultDuration be ignored on unnamedRoutes
- Transition.native use default Flutter transitions
- Added Get.testMode to use contextless elements on unit tests 
- Added Get.appUpdate and improve Get.forceAppUpdate 

## [3.12.1]	
- Remove spaces whitespaces from dart files	

## [3.12.0]	
- Added BottomSheet Duration && Export SingleGetTickerProvider (@unacorbatanegra)	
- Improve docs from dependencies management (@ngxingyu)	
- Fix unknownRoute with null Custom Transition (@marcosfons)	
- Optimize capitalize method (@zl910627)	
- Added Chinese documentation (@idootop)	
- Added TextDirection property on GetMaterialApp to improve RTL layout (@justkawal)	
- Remove unnecessary files on git (@nipodemos)	
- Fix tags on Get.create() and GetWidget() (@roipeker)	
- Update mockito dependency on getTests	
- Added GetStatelessWidget, a StatelessWidget base to GetWidget with lifecycle control of controllers. Note: It's a base class, you don't need change to use it or change your GetView, GetWidget StatelessWidget to It.

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
