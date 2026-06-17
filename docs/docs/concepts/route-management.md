---
sidebar_position: 2
---

# Route management

If you are going to use routes/snackbars/dialogs/bottomsheets without context, GetX is excellent for you too, just see it:

Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Navigate to a new screen:

```dart

Get.to(NextScreen());
```

Navigate to new screen with name. See more details on named routes [here](/docs/pillars/route-management#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);

```dart
Get.back();
```

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens, etc.)

```dart
Get.off(NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(NextScreen());
```

Noticed that you didn't have to use context to do any of these things? That's one of the biggest advantages of using Get route management. With this, you can execute all these methods from within your controller class, without worries.

### More details about route management

**Get works with named routes and also offers lower-level control over your routes! There is in-depth documentation [here](/docs/pillars/route-management)**