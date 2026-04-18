import 'package:example/pages/comments_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/settings_page.dart';
import 'package:example/pages/tab1_page.dart';
import 'package:example/pages/tab2_page.dart';
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

@TypedStatefulShellRoute<TabsDemoShellRoute>(
  branches: [
    TypedStatefulShellBranch<Tab1Branch>(
      routes: [
        TypedGoRoute<Tab1Route>(path: '/tabs/tab1'),
      ],
    ),
    TypedStatefulShellBranch<Tab2Branch>(
      routes: [
        TypedGoRoute<Tab2Route>(path: '/tabs/tab2'),
      ],
    ),
  ],
)
class TabsDemoShellRoute extends StatefulShellRouteData {
  const TabsDemoShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: 'Tab 1'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: 'Tab 2'),
        ],
      ),
    );
  }
}

class Tab1Branch extends StatefulShellBranchData {
  const Tab1Branch();
}

class Tab2Branch extends StatefulShellBranchData {
  const Tab2Branch();
}

class Tab1Route extends GoRouteData with $Tab1Route {
  const Tab1Route();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Tab1Page();
}

class Tab2Route extends GoRouteData with $Tab2Route {
  const Tab2Route();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Tab2Page();
}

