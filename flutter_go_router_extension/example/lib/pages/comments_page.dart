import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';
import '../widgets/shared_widgets.dart';

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
