import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  static const navigationDelayInMills = 200;

  /// Converts a specific URL path format to a Regex for comparison.
  String pathToRegexPattern({required String urlPath}) {
    if (urlPath.isEmpty) urlPath = '/';
    if (!urlPath.startsWith('/')) urlPath = '/$urlPath';
    // :param -> [^/]+ , * -> .*
    var r = urlPath.replaceAllMapped(RegExp(r':\w+'), (_) => '[^/]+');
    r = r.replaceAll('*', '.*');
    return '^$r\$';
  }

  /// [pushWithSetNewRoutePath]
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
  ///   pushWithSetNewRoutePath('/user/123')
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
  Future<void> pushWithSetNewRoutePath(String redirectUrl) async {
    final delegate = GoRouter.of(this).routerDelegate;
    var config = delegate.currentConfiguration;
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

    if (config.isNotEmpty) {
      // GoRoute does not allow setNewRoutePath with an empty config.
      await delegate.setNewRoutePath(config);
      await Future.delayed(Duration(milliseconds: navigationDelayInMills));

      if (!mounted) return;
      await push(redirectUrl);
      return;
    }

    // At this point, pushing a page to achieve the clear_top effect might encounter
    // a situation where the config (i.e., the Route List) is empty, but the redirectUrl
    // is still in the widget tree and has not been removed. This can cause a state
    // inconsistency error, so go() must be used to completely reset the route and
    // rebuild the Route List.
    go(redirectUrl);
  }
}
