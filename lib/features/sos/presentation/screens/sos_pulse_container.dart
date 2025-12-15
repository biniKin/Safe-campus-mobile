import 'package:flutter/material.dart';

class SosPulseButton extends StatefulWidget {
  final bool isEmergency;
  final VoidCallback onPressed;

  const SosPulseButton({
    super.key,
    required this.isEmergency,
    required this.onPressed,
  });

  @override
  State<SosPulseButton> createState() => _SosPulseButtonState();
}

class _SosPulseButtonState extends State<SosPulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isEmergency) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SosPulseButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isEmergency && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isEmergency && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      backgroundColor: Colors.transparent,
      elevation: 6,
      shape: const CircleBorder(),
      child: ScaleTransition(
        scale: widget.isEmergency ? _scaleAnimation : const AlwaysStoppedAnimation(1),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isEmergency ? Colors.redAccent : null,
            gradient: widget.isEmergency
                ? null
                : const LinearGradient(
                  colors: [Color(0xFF65558F), Color(0xFF8B7CB1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            boxShadow: widget.isEmergency
                ? [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: const Text(
            "SOS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
