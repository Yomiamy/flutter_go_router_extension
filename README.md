# flutter_go_router_extension

A Flutter extension for `go_router` that provides advanced navigation behaviors, specifically simulating Android's `FLAG_ACTIVITY_CLEAR_TOP` logic.

## Features

- **`pushWithSetNewRoutePath`**: Navigates to a route while clearing the stack top. If the target route already exists in the stack, all routes above it (inclusive) are removed before pushing a new instance.
- **Dynamic Path Matching**: Supports `go_router` path patterns including parameters (e.g., `:id`) and wildcards (`*`).

## Usage

```dart
// Navigates to /user/123, clearing any routes above it if /user/:id exists in the stack
context.pushWithSetNewRoutePath('/user/123');
```

## How it works

The extension converts `go_router` path patterns into regular expressions to identify existing routes in the current navigation stack. It then uses `setNewRoutePath` to manipulate the stack and `push` to navigate to the desired destination.

For more details, see the [package directory](./flutter_go_router_extension).

