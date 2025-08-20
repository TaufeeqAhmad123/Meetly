import 'package:flutter/material.dart';
import 'package:meetly/core/utils/const/color.dart';

class BouncingDotIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  const BouncingDotIndicator({
    super.key,
    this.color=korangColor,
    this.size = 10.0,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<BouncingDotIndicator> createState() => _BouncingDotIndicatorState();
}

class _BouncingDotIndicatorState extends State<BouncingDotIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration * 3,
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Interval(index / 3, (index + 1) / 3, curve: Curves.bounceInOut),
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, _buildDot).map((dot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: dot,
        );
      }).toList(),
    );
  }
}
