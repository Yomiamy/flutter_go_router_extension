import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_widgets.dart';

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
