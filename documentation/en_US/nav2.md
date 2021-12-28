# Navigator 2 Support on GetX

GetX added support for Nav 2 api starting from [4.2.0](https://pub.dev/packages/get/changelog#420---big-update), this improves and simplifies alot of the navigation problems that people had before.

# What is new in the Nav 2 API ?

you can read the [Design docs by flutter](https://docs.google.com/document/d/1Q0jx0l4-xymph9O6zLaOY4d_f7YFpNWX_eGbzYxr9wY/edit) or [the many articles on medium](https://medium.com/search?q=flutter%20navigator%202) for a detailed explaination, but here is the summary


1. Introducing a new `Router` widget in addition to the old `Navigator`
   1. It's created by default when using `MaterialApp.router` (or `GetMaterialApp.router`)
   2. It listens to a `RouterDelegate` and rebuilds when it changes
2. Introducing a new `RouterDelegate` class which is responsible for managing the navigation stack (instead of storing it in `NavigatorState`)
3. Introducing a new `RouteInformationParser` class which is responsible for parsing/loading the navigation stack
4. The navigation stack now represents the actual history of navigation
   - e.g. you can go from route `/A` to `/A/B/C/D` and go back to `/A`
   - previously on the old navigator API, you would `pop` back to `/A/B/C`, since it had no concept of navigation history
   - This is a big thing for web apps, since it's similar to how a browser works, and it's also good for mobile apps since it naturally simplifies [Deep linking](https://docs.flutter.dev/development/ui/navigation/deep-linking)
5. plus much more ...

# What does GetX do ?
- GetX provides its own customizable implmentation of `RouterDelegate` (`GetDelegate`) and `RouteInformationParser` (`GetInformationParser`)
- The navigation state is now represented in `GetNavConfig` (representing a history entry) and `GetPage` (representing a single page)
- Introduce utility widgets that simplify nested navigation `RouterOutlet`  and `GetRouterOutlet`
- changes to the existing `GetMiddleware` and `GetPage`

# Re-think in terms of routes
- Imagine navigating to a web page `https://someapp.com/products/654132/reviews/9876`
- This route is `Reproducable`, meaning that when you access it, it should ALWAYS open that specific review on that specific product
- the `reviews` page is `Dependant` on its `parent`, the `Product Details`, meaning that without knowing the `productId`, you can't get to the reviews list, nor the specific review
- which means we can represent our routes in a `Tree structure` where each node in the tree depends on its parents
- This also means that each `middleware`/`binding` assigned to a parent node is naturally applied to its children
- in our example, the pages can be modeled as such:
```dart
//other properties are omitted for simplicity
GetPage(    
    name: '/products',
    page: () => ProductsView(),
    children: [
        GetPage(
            name: '/:productId',
            page: () => ProductDetailsView(),
            children: [                
                GetPage(
                    name: '/likes', //displays who liked this product                   
                    page: () => ProductLikesView(),
                ),
                GetPage(
                    name: '/reviews', //displays reviews from people who bought this product
                    page: () => ProductReviewsView(),
                    children: [
                        GetPage(
                            name: '/:reviewId' //displays a single review
                            page: () => ProductReviewDetailsView(),
                        )
                    ]
                ),
            ]
        ),
    ]
)
```

# GetNavConfig

- a `GetNavConfig` is defined as such:
    ```dart
    //other members omitted for simplicity
    class GetNavConfig extends RouteInformation {
      final List<GetPage> currentTreeBranch;   

      //inherited from [RouteInformation]
      // String? location
      // Object? state   
    }
    ```
- as you can see, it's just a list of pages representing a branch in the tree
- in our example above: `https://someapp.com/products/654132/reviews/9876`
  - the `location` would be: `/products/654132/reviews/9876`
  - the `currentTreeBranch` would be:
    ```dart
    [
        GetPage(    
            name: '/products',
            page: () => ProductsView(),        
        ),
        GetPage(    
            name: '/products/654132',
            page: () => ProductDetailsView(),
            parameters: {
                'productId': '654132',
            },
        ),
        GetPage(    
            name: '/products/654132/reviews',
            page: () => ProductReviewsView(),
            parameters: {
                'productId': '654132',
            },
        ),
        GetPage(    
            name: '/products/654132/reviews/9876',
            page: () => ProductReviewDetailsView(),
            parameters: {
                'productId': '654132',
                'reviewId': '9876'
            },
        ),
    ]
    ```

# GetPage
- the building blocks for navigation in GetX
- it's basically a part of a route that can be displayed
- These are the main properties that you will usually use in Nav2
  1. name
     - represents the page name, this MUST start with a slash (`/`)
     - it can also contain regex matchers, which will populate the `parameters` property ([as demonstrated in the example above](#getnavconfig))
     - you can also combine multiple parts in one page, for example, you can have a `UserDetails` page without having a `Users` page, which will look like this:
        ```dart
        GetPage(
            name: '/users/:userId',
            page: () => UserDetails(),
            //other props
        )
        ```
  2. page
     - a function that returns the view to be displayed when building the page
  3. participatesInRootNavigator
     - will be explained further in [GetDelegate](#getdelegate)
  4. children (already explained above in [Re-think in terms of routes](#re-think-in-terms-of-routes))
  5. middlewares
     - List of `GetMiddleware`s that notify you on route changes, will be explained further in [GetMiddleware](#getmiddleware-changes)
  6. parameters
     - a key-value map of parameters that you either
       - provide manually
       - get from regex matchers (see example above in [GetNavConfig](#getnavconfig))
- you can read the original [GetPage docs](route_management.md) as well

# GetDelegate

# GetInformationParser

# GetMiddleware

# GetRouterOutlet