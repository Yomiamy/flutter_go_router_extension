// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $userRoute,
  $userPostRoute,
  $commentsRoute,
  $settingsRoute,
];

RouteBase get $homeRoute =>
    GoRouteData.$route(path: '/home', factory: $HomeRoute._fromState);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userRoute =>
    GoRouteData.$route(path: '/user/:id', factory: $UserRoute._fromState);

mixin $UserRoute on GoRouteData {
  static UserRoute _fromState(GoRouterState state) =>
      UserRoute(id: state.pathParameters['id']!);

  UserRoute get _self => this as UserRoute;

  @override
  String get location =>
      GoRouteData.$location('/user/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userPostRoute => GoRouteData.$route(
  path: '/user/:id/posts',
  factory: $UserPostRoute._fromState,
);

mixin $UserPostRoute on GoRouteData {
  static UserPostRoute _fromState(GoRouterState state) =>
      UserPostRoute(id: state.pathParameters['id']!);

  UserPostRoute get _self => this as UserPostRoute;

  @override
  String get location =>
      GoRouteData.$location('/user/${Uri.encodeComponent(_self.id)}/posts');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $commentsRoute =>
    GoRouteData.$route(path: '/comments', factory: $CommentsRoute._fromState);

mixin $CommentsRoute on GoRouteData {
  static CommentsRoute _fromState(GoRouterState state) => const CommentsRoute();

  @override
  String get location => GoRouteData.$location('/comments');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute =>
    GoRouteData.$route(path: '/settings', factory: $SettingsRoute._fromState);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
