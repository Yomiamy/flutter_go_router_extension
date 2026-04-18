# Flutter GoRouter Extension

A Flutter package that extends [go_router](https://pub.dev/packages/go_router) with Android-style navigation behaviors.

## Features

- **`isCurrent`**: Returns true if the current `BuildContext` belongs to the top-most route in the navigation stack.
- **`pushAndRemoveUntil`**: Simulates Android's `FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_NEW_TASK` behavior
- **`popUntil`**: Pop routes until a specific route is reached, preserving the existing instance
- **`popToRoot`**: Pop all routes until the root route is reached.
- **`ShellTabVisibilityDetector`**: Provides visibility callbacks for tabs inside a `StatefulShellRoute`.
- Supports dynamic route parameters (e.g., `/user/:id`)
- Supports wildcard routes (e.g., `/files/*`)

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_go_router_extension: ^1.4.0
```

## Usage

### ShellTabVisibilityDetector

Tracks when nested tabs managed by a `go_router` `StatefulShellRoute` become visible or invisible.

```dart
// Wrap your tab's root widget
ShellTabVisibilityDetector(
  onVisible: () => print('Tab is visible'),
  onInVisible: () => print('Tab is hidden'),
  child: const MyTabPage(),
)
```

Because `go_router` retains the state of `StatefulShellBranch` tabs in the background, standard `RouteObserver` fails to detect tab switching. This widget intelligently binds to Flutter's native `TickerMode` to provide completely accurate visibility events.

### isCurrent

Returns true if the current `BuildContext` belongs to the top-most route in the navigation stack.

```dart
// In your widget
if (context.isCurrent) {
  // Do something only if this is the active screen
}
```

### popToRoot

Pops all routes from the navigator stack until the root route (`/`) is reached.

```dart
// In your widget
ElevatedButton(
  onPressed: () {
    context.popToRoot();
  },
  child: Text('Pop to Root'),
)
```

### pushAndRemoveUntil

When navigating to a page that already exists in the stack, it clears all pages above and including that page, then pushes a new instance of the target page.

### popUntil

Pops routes from the stack until a route matching the target URL is found, **preserving the existing instance** of that route (state, scroll position, and parameters are all retained).

Unlike `pushAndRemoveUntil`, this method does not create a new page instance—it simply removes the routes above the matching one.

```dart
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

// In your widget
ElevatedButton(
  onPressed: () {
    context.popUntil('/user/123');
  },
  child: Text('Back to User'),
)
```

**Comparison with pushAndRemoveUntil:**

| Method | Matching route instance |
|--------|------------------------|
| `pushAndRemoveUntil(url)` | **New instance** (state reset) |
| `popUntil(url)` | **Existing instance** (state preserved) |

If the target URL is not found in the stack, the method does nothing.

```dart
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

// In your widget
ElevatedButton(
  onPressed: () {
    context.pushAndRemoveUntil('/user/123');
  },
  child: Text('Go to User'),
)
```

### Example

If the original stack is:

```
/home -> /user/123 -> /user/123/posts -> /comments
```

And you call:

```dart
context.pushAndRemoveUntil('/user/123');
```

Processing steps:
1. Route `/user/:id` converts to RegExp: `^/user/[^/]+$`
2. Check `/comments` - No match, remove
3. Check `/user/123/posts` - No match, remove
4. Check `/user/123` - Match found

Resulting stack:

```
/home -> /user/123 (new instance)
```

## How It Works

1. **Path to Regex Conversion**: Dynamic parameters (`:param`) are converted to `[^/]+`, wildcards (`*`) to `.*`
2. **Stack Traversal**: Iterates from the top of the navigation stack
3. **Match & Clear**: When a matching route is found, all routes above it (including itself) are removed
4. **Push New Instance**: A fresh instance of the target page is pushed onto the stack

## Requirements

- Flutter SDK
- go_router: ^14.0.0 or higher

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## References

- [go_router_pop_until_example]()
