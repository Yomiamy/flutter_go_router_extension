import 'package:example/pages/comments_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/settings_page.dart';
import 'package:example/pages/user_page.dart';
import 'package:example/pages/user_posts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData with $HomeRoute {
  static const String path = '/home';

  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<UserRoute>(path: UserRoute.path)
class UserRoute extends GoRouteData with $UserRoute {
  static const String path = '/user/:id';
  final String id;
  const UserRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserPage(userId: id);
}

@TypedGoRoute<UserPostRoute>(path: UserPostRoute.path)
class UserPostRoute extends GoRouteData with $UserPostRoute {
  static const String path = '/user/:id/posts';
  final String id;
  const UserPostRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserPostsPage(userId: id);
}

@TypedGoRoute<CommentsRoute>(path: CommentsRoute.path)
class CommentsRoute extends GoRouteData with $CommentsRoute {
  static const String path = '/comments';
  const CommentsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CommentsPage();
}

@TypedGoRoute<SettingsRoute>(path: SettingsRoute.path)
class SettingsRoute extends GoRouteData with $SettingsRoute {
  static const String path = '/settings';
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
