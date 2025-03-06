import 'package:epicor/core_packages.dart';

class DebouncedButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Duration cooldown;
  final Widget child;

  const DebouncedButton({
    super.key,
    required this.onPressed,
    this.cooldown = const Duration(seconds: 2),
    required this.child,
  });

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  bool _isEnabled = true;
  bool _isLoading = false;
  Timer? _timer;

  Future<void> _handleTap() async {
    if (_isEnabled && !_isLoading) {
      setState(() {
        _isEnabled = false;
        _isLoading = true;
      });

      try {
        await widget.onPressed();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);

          _timer?.cancel();
          _timer = Timer(widget.cooldown, () {
            if (mounted) {
              setState(() => _isEnabled = true);
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: _isEnabled && !_isLoading ? 1.0 : 0.5,
            child: widget.child,
          ),
          if (_isLoading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.colorAssent,
                ),
                strokeWidth: 2.0,
              ),
            ),
        ],
      ),
    );
  }
}

// Usage in your existing code:
