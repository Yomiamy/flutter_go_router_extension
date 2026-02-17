import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

void main() {
  runApp(const MyApp());
}

/// Router configuration
final GoRouter _router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/user/:id',
      name: 'user',
      builder: (context, state) {
        final userId = state.pathParameters['id'] ?? 'unknown';
        return UserPage(userId: userId);
      },
    ),
    GoRoute(
      path: '/user/:id/posts',
      name: 'userPosts',
      builder: (context, state) {
        final userId = state.pathParameters['id'] ?? 'unknown';
        return UserPostsPage(userId: userId);
      },
    ),
    GoRoute(
      path: '/comments',
      name: 'comments',
      builder: (context, state) => const CommentsPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Extension Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

/// Displays the current navigation stack
class NavigationStackDisplay extends StatelessWidget {
  const NavigationStackDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final delegate = GoRouter.of(context).routerDelegate;
    final config = delegate.currentConfiguration;
    final routes = config.routes.whereType<GoRoute>().toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Navigation Stack:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (routes.isEmpty)
            const Text('(empty)', style: TextStyle(color: Colors.grey))
          else
            ...routes.asMap().entries.map((entry) {
              final index = entry.key;
              final route = entry.value;
              final isLast = index == routes.length - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: TextStyle(
                        color: isLast ? Colors.deepPurple : Colors.black54,
                      ),
                    ),
                    Text(
                      route.path,
                      style: TextStyle(
                        fontWeight: isLast
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isLast ? Colors.deepPurple : Colors.black87,
                      ),
                    ),
                    if (isLast)
                      const Text(
                        ' (current)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

/// Base scaffold with consistent styling and stack display
class DemoScaffold extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> children;

  const DemoScaffold({
    super.key,
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const NavigationStackDisplay(), ...children],
        ),
      ),
    );
  }
}

/// Action button for navigation
class NavButton extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onPressed;
  final Color? color;

  const NavButton({
    super.key,
    required this.label,
    required this.description,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// Pages
// ============================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Home',
      color: Colors.blue,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Welcome! This demo shows how pushAndRemoveUntil and popUntil work.\n\n'
            'pushAndRemoveUntil: clears stack to a route and pushes a NEW instance.\n'
            'popUntil: pops stack to a route and PRESERVES the existing instance.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        NavButton(
          label: 'Go to User 123',
          description: 'context.push(\'/user/123\')',
          onPressed: () => context.push('/user/123'),
          color: Colors.green,
        ),
        NavButton(
          label: 'Go to Settings',
          description: 'context.push(\'/settings\')',
          onPressed: () => context.push('/settings'),
          color: Colors.orange,
        ),
      ],
    );
  }
}

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'User $userId',
      color: Colors.green,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Viewing user profile for ID: $userId',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        NavButton(
          label: 'View Posts',
          description: 'context.push(\'/user/$userId/posts\')',
          onPressed: () => context.push('/user/$userId/posts'),
          color: Colors.teal,
        ),
        NavButton(
          label: 'Go to Comments',
          description: 'context.push(\'/comments\')',
          onPressed: () => context.push('/comments'),
          color: Colors.purple,
        ),
        NavButton(
          label: 'Go to Settings',
          description: 'context.push(\'/settings\')',
          onPressed: () => context.push('/settings'),
          color: Colors.orange,
        ),
      ],
    );
  }
}

class UserPostsPage extends StatelessWidget {
  final String userId;

  const UserPostsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Posts by User $userId',
      color: Colors.teal,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Showing posts for user $userId',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        NavButton(
          label: 'Go to Comments',
          description: 'context.push(\'/comments\')',
          onPressed: () => context.push('/comments'),
          color: Colors.purple,
        ),
        NavButton(
          label: 'Go to Settings',
          description: 'context.push(\'/settings\')',
          onPressed: () => context.push('/settings'),
          color: Colors.orange,
        ),
      ],
    );
  }
}

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Comments',
      color: Colors.purple,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'This is the comments page.\n\n'
            'Try using pushAndRemoveUntil to navigate back to a previous page '
            'while clearing the stack above it.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'pushAndRemoveUntil Demo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        NavButton(
          label: 'pushAndRemoveUntil(\'/user/123\')',
          description:
              'Clears stack until /user/:id is found, then pushes /user/123',
          onPressed: () => context.pushAndRemoveUntil('/user/123'),
          color: Colors.red,
        ),
        NavButton(
          label: 'pushAndRemoveUntil(\'/home\')',
          description: 'Clears entire stack and navigates to /home',
          onPressed: () => context.pushAndRemoveUntil('/home'),
          color: Colors.red.shade700,
        ),
        const SizedBox(height: 16),
        NavButton(
          label: 'popUntil(\'/user/123\')',
          description:
              'Pops stack to /user/:id, preserving its existing instance',
          onPressed: () => context.popUntil('/user/123'),
          color: Colors.indigo,
        ),
        const SizedBox(height: 16),
        NavButton(
          label: 'popToRoot()',
          description: 'Pops all routes until only the root remains',
          onPressed: () => context.popToRoot(),
          color: Colors.redAccent,
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Regular Navigation:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        NavButton(
          label: 'Go to Settings (push)',
          description: 'context.push(\'/settings\') - adds to stack',
          onPressed: () => context.push('/settings'),
          color: Colors.orange,
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Settings',
      color: Colors.orange,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Settings page.\n\n'
            'From here you can test pushAndRemoveUntil to clear the stack.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'pushAndRemoveUntil Demo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        NavButton(
          label: 'pushAndRemoveUntil(\'/home\')',
          description: 'Clears stack and goes to home',
          onPressed: () => context.pushAndRemoveUntil('/home'),
          color: Colors.red,
        ),
        NavButton(
          label: 'pushAndRemoveUntil(\'/user/456\')',
          description:
              'If /user/:id exists in stack, clears above it and pushes /user/456',
          onPressed: () => context.pushAndRemoveUntil('/user/456'),
          color: Colors.red.shade700,
        ),
        const SizedBox(height: 16),
        NavButton(
          label: 'popUntil(\'/home\')',
          description: 'Pops stack back to /home, preserving its existing instance',
          onPressed: () => context.popUntil('/home'),
          color: Colors.indigo,
        ),
        const SizedBox(height: 16),
        NavButton(
          label: 'popToRoot()',
          description: 'Pops all routes until only the root remains',
          onPressed: () => context.popToRoot(),
          color: Colors.redAccent,
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Build Deeper Stack:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        NavButton(
          label: 'Go to User 789',
          description: 'context.push(\'/user/789\')',
          onPressed: () => context.push('/user/789'),
          color: Colors.green,
        ),
        NavButton(
          label: 'Go to Comments',
          description: 'context.push(\'/comments\')',
          onPressed: () => context.push('/comments'),
          color: Colors.purple,
        ),
      ],
    );
  }
}
