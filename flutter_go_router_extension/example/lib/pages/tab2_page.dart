import 'package:flutter/material.dart';
import 'package:flutter_go_router_extension/flutter_go_router_extension.dart';

class Tab2Page extends StatefulWidget {
  const Tab2Page({super.key});

  @override
  State<Tab2Page> createState() => _Tab2PageState();
}

class _Tab2PageState extends State<Tab2Page> {
  void _showToast(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 1000),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShellTabVisibilityDetector(
      onVisible: () => _showToast('Tab 2 became visible'),
      onInVisible: () => _showToast('Tab 2 became invisible'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tab 2 - Visibility Demo')),
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
