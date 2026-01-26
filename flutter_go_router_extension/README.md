# Flutter GoRouter Extension

A Flutter package that extends [go_router](https://pub.dev/packages/go_router) with Android-style navigation behaviors.

## Features

- **`pushWithSetNewRoutePath`**: Simulates Android's `FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_NEW_TASK` behavior
- Supports dynamic route parameters (e.g., `/user/:id`)
- Supports wildcard routes (e.g., `/files/*`)

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_go_router_extension: ^1.0.0
```

## Usage

### pushWithSetNewRoutePath

When navigating to a page that already exists in the stack, it clears all pages above and including that page, then pushes a new instance of the target page.

```dart
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

// In your widget
ElevatedButton(
  onPressed: () {
    context.pushWithSetNewRoutePath('/user/123');
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
context.pushWithSetNewRoutePath('/user/123');
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

MIT License

## References

- [go_router_pop_until_example]()
