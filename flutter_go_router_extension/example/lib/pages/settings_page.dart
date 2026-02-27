import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';
import '../widgets/shared_widgets.dart';

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
          description:
              'Pops stack back to /home, preserving its existing instance',
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
