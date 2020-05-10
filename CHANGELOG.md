## [2.2.2] 
- Fix GetRoute not found

## [2.2.1] 
- Improve lazyPut

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
