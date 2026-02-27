import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
