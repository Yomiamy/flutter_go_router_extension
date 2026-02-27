import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  /// Converts a specific URL path format to a Regex for comparison.
  String pathToRegexPattern({required String urlPath}) {
    if (urlPath.isEmpty) urlPath = '/';
    if (!urlPath.startsWith('/')) urlPath = '/$urlPath';
    // :param -> [^/]+ , * -> .*
    var r = urlPath.replaceAllMapped(RegExp(r':\w+'), (_) => '[^/]+');
    r = r.replaceAll('*', '.*');
    return '^$r\$';
  }

  /// [isCurrent]
  /// Returns true if the current [BuildContext] belongs to the top-most route in the navigation stack.
  bool get isCurrent {
    final currentPageKey = GoRouterState.of(this).pageKey;
    final topPageKey =
        GoRouter.of(this).routerDelegate.currentConfiguration.last.pageKey;
    return currentPageKey == topPageKey;
  }

  /// [pushAndRemoveUnt`il]
  /// Simulates the behavior of Android's `FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_NEW_TASK`.
  ///
  /// #### Function Description
  ///
  /// When navigating to a page that already exists in the stack, it clears all pages
  /// above and including that page, and then pushes a new instance of the target page.
  ///
  /// For example, if the original stack is:
  ///   /home -> /user/123 -> /user/123/posts -> /comments
  ///
  /// And you call:
  ///   pushAndRemoveUntil('/user/123')
  ///
  /// Processing steps:
  ///   The route definition /user/:id is converted to RegExp: ^/user/[^/]+$
  ///   Check /comments       ❌ No match, remove
  ///   Check /user/123/posts ❌ No match, remove
  ///   Check /user/123       ✅ Match
  ///
  /// Resulting stack:
  ///   /home -> /user/123 (new instance)
  ///
  /// *Reference*
  /// https://github.com/rubenlop88/go_router_pop_until_example/blob/main/lib/routes.dart
  Future<void> pushAndRemoveUntil(String redirectUrl) async {
    final router = GoRouter.of(this);
    var config = router.routerDelegate.currentConfiguration;
    var routes = config.routes.whereType<GoRoute>();
    final redirectUrlPath = Uri.parse(redirectUrl).path;

    while (routes.isNotEmpty) {
      final lastRoute = config.last.route;
      final lastPath = lastRoute.path;
      final reg = RegExp(pathToRegexPattern(urlPath: lastPath));

      if (reg.hasMatch(redirectUrlPath)) {
        config = config.remove(config.last);
        break;
      }

      if (routes.length == 1) break;
      config = config.remove(config.last);
      routes = config.routes.whereType<GoRoute>();
    }

    if (config.isEmpty) {
      // Stack is empty, use go() to completely reset and rebuild the route list.
      go(redirectUrl);
      return;
    }

    // Use routeInformationProvider.push with the trimmed config as base.
    // This performs "set base stack + push new route" in a single operation,
    // eliminating any intermediate state flicker.
    await router.routeInformationProvider.push(redirectUrl, base: config);
  }

  /// [popToRoot]
  /// Pops all routes until only the root route remains.
  ///
  /// This function simulates a "pop to root" behavior by trimming the navigation stack
  /// down to the first [GoRoute] and then updating the router configuration.
  Future<void> popToRoot() async {
    final router = GoRouter.of(this);
    var config = router.routerDelegate.currentConfiguration;
    var routes = config.routes.whereType<GoRoute>();

    // If there is 1 or fewer GoRoutes, we are already at the root.
    if (routes.length <= 1) return;

    // Remove routes from the end until only 1 remains.
    while (routes.length > 1) {
      config = config.remove(config.last);
      routes = config.routes.whereType<GoRoute>();
    }

    // Update the route path with the new configuration.
    await router.routerDelegate.setNewRoutePath(config);
  }

  /// [popUntil]
  /// Pops routes from the navigation stack until a route matching [targetUrl] is found.
  ///
  /// Unlike [pushAndRemoveUntil], this method **preserves** the existing instance
  /// of the matching route (its state, scroll position, etc. are retained).
  ///
  /// #### Function Description
  ///
  /// Traverses the navigation stack from the top, removing routes that do not match
  /// [targetUrl]. When a match is found, the stack is trimmed to include that route
  /// (as the top), and [setNewRoutePath] is called to apply the change.
  ///
  /// If [targetUrl] is not found in the stack, the method does nothing.
  ///
  /// For example, if the original stack is:
  ///   /home -> /user/123 -> /user/123/posts -> /comments
  ///
  /// And you call:
  ///   popUntil('/user/123')
  ///
  /// Processing steps:
  ///   The route definition /user/:id is converted to RegExp: ^/user/[^/]+$
  ///   Check /comments       ❌ No match, remove
  ///   Check /user/123/posts ❌ No match, remove
  ///   Check /user/123       ✅ Match, stop here
  ///
  /// Resulting stack:
  ///   /home -> /user/123 (original instance preserved)
  Future<void> popUntil(String targetUrl) async {
    final router = GoRouter.of(this);
    var config = router.routerDelegate.currentConfiguration;
    var routes = config.routes.whereType<GoRoute>();
    final targetPath = Uri.parse(targetUrl).path;

    // Record the initial route count to detect whether the stack changed.
    final initialLength = routes.length;

    // Remove routes from the top until a match is found or only one remains.
    while (routes.length > 1) {
      final lastRoute = config.last.route;
      final lastPath = lastRoute.path;
      final reg = RegExp(pathToRegexPattern(urlPath: lastPath));

      if (reg.hasMatch(targetPath)) {
        // Match found: keep this route in place and stop removing.
        break;
      }

      config = config.remove(config.last);
      routes = config.routes.whereType<GoRoute>();
    }

    // If the last remaining route still doesn't match, the target is not in the stack — do nothing.
    final lastRoute = config.last.route;
    final lastPath = lastRoute.path;
    final reg = RegExp(pathToRegexPattern(urlPath: lastPath));
    if (!reg.hasMatch(targetPath)) {
      return;
    }

    // If the stack is unchanged (already at the target), do nothing.
    if (routes.length == initialLength) {
      return;
    }

    // Apply the trimmed stack, preserving the existing instance of the matching route.
    await router.routerDelegate.setNewRoutePath(config);
  }
}
