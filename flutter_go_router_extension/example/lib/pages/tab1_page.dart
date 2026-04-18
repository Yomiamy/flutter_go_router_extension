import 'package:flutter/material.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

  @override
  State<Tab1Page> createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  void _showToast(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShellTabVisibilityDetector(
      onVisible: () => _showToast('Tab 1 became visible'),
      onInVisible: () => _showToast('Tab 1 became invisible'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tab 1 - Visibility Demo')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Switch between Tab 1 and Tab 2 to see the ShellTabVisibilityDetector as Toast alerts.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
