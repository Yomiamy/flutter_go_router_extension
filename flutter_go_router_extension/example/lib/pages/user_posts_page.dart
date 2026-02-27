import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_widgets.dart';

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
