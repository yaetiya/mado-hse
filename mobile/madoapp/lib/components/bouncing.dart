import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;
  final bool isDisabled;

  const Bouncing(
      {required this.child,
      Key? key,
      required this.onPress,
      this.isDisabled = false})
      : super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.07,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: (TapDownDetails event) {
        if (widget.isDisabled) return;
        _controller.forward();
      },
      onTapUp: (TapUpDetails event) {
        if (widget.isDisabled) return;
        _controller.reverse();
        widget.onPress();
      },
      onTapCancel: () {
        if (widget.isDisabled) return;
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
