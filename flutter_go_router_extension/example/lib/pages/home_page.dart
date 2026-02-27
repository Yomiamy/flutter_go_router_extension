import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_widgets.dart';

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
