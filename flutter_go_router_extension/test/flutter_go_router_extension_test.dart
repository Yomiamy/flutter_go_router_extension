import 'package:flutter/material.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  Widget createApp() {
    router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const TestPage('home')),
        GoRoute(
          path: '/user/:id',
          builder: (_, state) => TestPage('user-${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: '/user/:id/posts',
          builder: (_, state) => TestPage('posts-${state.pathParameters['id']}'),
        ),
        GoRoute(path: '/comments', builder: (_, _) => const TestPage('comments')),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('pushAndRemoveUntil clears stack and pushes new route', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TestPage));

    // Build initial stack
    context.push('/user/123');
    await tester.pumpAndSettle();

    context.push('/user/123/posts');
    await tester.pumpAndSettle();

    context.push('/comments');
    await tester.pumpAndSettle();

    expect(find.text('comments'), findsOneWidget);

    // Execute target method
    await context.pushAndRemoveUntil('/user/123');
    await tester.pumpAndSettle();

    // Verify the result
    expect(find.text('user-123'), findsOneWidget);
    expect(find.text('posts-123'), findsNothing);
    expect(find.text('comments'), findsNothing);

    // Verify that the top of the stack is the new instance
    expect(router.routerDelegate.currentConfiguration.last.route.path, '/user/:id');
  });

  testWidgets('popUntil pops to matching route preserving existing instance',
      (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TestPage));

    // Build stack: /home → /user/123 → /user/123/posts → /comments
    context.push('/user/123');
    await tester.pumpAndSettle();

    context.push('/user/123/posts');
    await tester.pumpAndSettle();

    context.push('/comments');
    await tester.pumpAndSettle();

    expect(find.text('comments'), findsOneWidget);

    // Call popUntil targeting /user/123
    await context.popUntil('/user/123');
    await tester.pumpAndSettle();

    // Verify: back at /user/123 with pages above it removed
    expect(find.text('user-123'), findsOneWidget);
    expect(find.text('posts-123'), findsNothing);
    expect(find.text('comments'), findsNothing);

    // Verify: top of stack is /user/:id (existing instance, not a new push)
    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/user/:id',
    );
  });

  testWidgets('popUntil does nothing if target not in stack', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TestPage));

    context.push('/user/123');
    await tester.pumpAndSettle();

    // /settings is not in the stack — the stack should remain unchanged
    await context.popUntil('/settings');
    await tester.pumpAndSettle();

    // Stack should be unmodified
    expect(find.text('user-123'), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/user/:id',
    );
    // Stack depth should not change (/home + /user/123 = 2)
    expect(
      router.routerDelegate.currentConfiguration.routes
          .whereType<GoRoute>().length,
      2,
    );
  });

  testWidgets('popUntil does nothing if already at target', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TestPage));

    context.push('/user/123');
    await tester.pumpAndSettle();

    // Already at /user/123 — the stack should remain unchanged
    await context.popUntil('/user/123');
    await tester.pumpAndSettle();

    expect(find.text('user-123'), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/user/:id',
    );
    // Stack depth should not change (/home + /user/123 = 2)
    expect(
      router.routerDelegate.currentConfiguration.routes
          .whereType<GoRoute>().length,
      2,
    );
  });

  testWidgets('popUntil with root route pops to root', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(TestPage));

    // Build stack: /home → /user/123 → /comments
    context.push('/user/123');
    await tester.pumpAndSettle();

    context.push('/comments');
    await tester.pumpAndSettle();

    expect(find.text('comments'), findsOneWidget);

    // Call popUntil('/home') — should pop back to root
    await context.popUntil('/home');
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.text('user-123'), findsNothing);
    expect(find.text('comments'), findsNothing);

    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/home',
    );
    expect(
      router.routerDelegate.currentConfiguration.routes
          .whereType<GoRoute>().length,
      1,
    );
  });
}

/// Simple test page
class TestPage extends StatelessWidget {
  final String label;
  const TestPage(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}
