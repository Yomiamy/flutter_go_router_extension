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

    // 建立堆疊：/home → /user/123 → /user/123/posts → /comments
    context.push('/user/123');
    await tester.pumpAndSettle();

    context.push('/user/123/posts');
    await tester.pumpAndSettle();

    context.push('/comments');
    await tester.pumpAndSettle();

    expect(find.text('comments'), findsOneWidget);

    // 呼叫 popUntil，目標為 /user/123
    await context.popUntil('/user/123');
    await tester.pumpAndSettle();

    // 驗證：回到 /user/123，且上面的頁面已移除
    expect(find.text('user-123'), findsOneWidget);
    expect(find.text('posts-123'), findsNothing);
    expect(find.text('comments'), findsNothing);

    // 驗證：堆疊頂端為 /user/:id（原實體，非新推入）
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

    // /settings 不在堆疊中，不應改變堆疊
    await context.popUntil('/settings');
    await tester.pumpAndSettle();

    // 堆疊應維持不變
    expect(find.text('user-123'), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/user/:id',
    );
    // 堆疊深度不應改變（/home + /user/123 = 2）
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

    // 已在 /user/123，不應改變堆疊
    await context.popUntil('/user/123');
    await tester.pumpAndSettle();

    expect(find.text('user-123'), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.last.route.path,
      '/user/:id',
    );
    // 堆疊深度不應改變（/home + /user/123 = 2）
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

    // 建立堆疊：/home → /user/123 → /comments
    context.push('/user/123');
    await tester.pumpAndSettle();

    context.push('/comments');
    await tester.pumpAndSettle();

    expect(find.text('comments'), findsOneWidget);

    // 呼叫 popUntil('/home')，應 pop 回 root
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
