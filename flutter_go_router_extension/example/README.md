# Flutter Go Router Extension Example

This example application demonstrates the capabilities provided by the `flutter_go_router_extension` package, including enhanced stack manipulation and visibility detection for `StatefulShellRoute` tabs.

## Features Demonstrated

1.  **popToRoot**: Pops the navigation stack until only the initial root route remains.
2.  **popUntil**: Pops the stack backwards searching for a matching route definition, allowing you to return to specific markers gracefully.
3.  **pushAndRemoveUntil**: Pushes a new route and forcefully removes the entire navigation stack underneath it, ideal for authentication flows or returning home.
4.  **isCurrent**: Accurately checks if the provided `BuildContext` is on the very top of the navigation stack.
5.  **ShellTabVisibilityDetector**: Tracks when nested tabs managed by a `go_router` `StatefulShellRoute` actually become visible or invisible to the user.

## ShellTabVisibilityDetector usage

If you use `StatefulShellRoute` to manage bottom navigation bars, `RouteObserver` will fail to correctly notify pages when switching tabs because `go_router` pre-builds and retains the state of those branches in the background without actually pushing or popping routes.

You can wrap the outermost layer of your tab page in `ShellTabVisibilityDetector`:

```dart
@override
Widget build(BuildContext context) {
  return ShellTabVisibilityDetector(
    onVisible: () => print('Tab is now visible on screen'),
    onInVisible: () => print('Tab just became hidden from view'),
    child: Scaffold(
      appBar: AppBar(title: const Text('My Tab')),
      body: const Center(child: Text('Content')),
    ),
  );
}
```

The detector intelligently binds to Flutter's native `TickerMode` framework hooks, accurately recognizing when the branch's subtree falls out of focus during tab switching. 

## Running the Example

Run the app normally:
```bash
flutter run
```

If you modify `routes.dart` to add or remove routes in the example, remember that this project uses strongly-typed routing (`go_router_builder`). You must rebuild the generated routes file:
```bash
dart run build_runner build --delete-conflicting-outputs
```
