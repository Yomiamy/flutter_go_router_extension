import 'package:flutter/widgets.dart';

/// 偵測 StatefulShellRoute tab 切換的可見度。
///
/// StatefulShellRoute.indexedStack 會把非 active branch 的 TickerMode 設為 false，
/// 此 widget 透過 TickerMode.of(context) 監聽切換並回呼 onVisible / onInVisible。
class ShellTabVisibilityDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onVisible;
  final VoidCallback? onInVisible;

  const ShellTabVisibilityDetector({
    super.key,
    required this.child,
    this.onVisible,
    this.onInVisible,
  });

  @override
  State<ShellTabVisibilityDetector> createState() =>
      _ShellTabVisibilityDetectorState();
}

class _ShellTabVisibilityDetectorState
    extends State<ShellTabVisibilityDetector> {
  bool? _wasActive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isActive = TickerMode.of(context);
    if (_wasActive == isActive) return;
    final previous = _wasActive;
    _wasActive = isActive;
    if (previous == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isActive) {
        widget.onVisible?.call();
      } else {
        widget.onInVisible?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
