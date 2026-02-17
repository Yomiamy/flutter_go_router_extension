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
